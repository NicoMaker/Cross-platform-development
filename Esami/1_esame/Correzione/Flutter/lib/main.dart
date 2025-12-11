import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:reactive_forms/reactive_forms.dart";
import "package:talker_riverpod_logger/talker_riverpod_logger.dart";

void main() {
  runApp(
    ProviderScope(
      // a simple logger for riverpod states
      // you can ignore this if you don't want it
      observers: [
        TalkerRiverpodObserver(
          settings: const TalkerRiverpodLoggerSettings(
            printProviderDisposed: true,
          ),
        ),
      ],
      // a configuration that denies retries when a provider fails
      // you can ignore this if you don't want it
      retry: (retryCount, error) {
        return null;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
        ),
      ),
      // TODO: your root goes here
      home: const ReviewListWidget(),
    );
  }
}

class ReviewListWidget extends StatefulWidget {
  const ReviewListWidget({
    super.key,
  });

  @override
  State<ReviewListWidget> createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends State<ReviewListWidget> {
  List<Review> list = <Review>[];

  Future<void> addReview() async {
    final result = await showDialog<Json>(
      context: context,
      builder: (context) {
        return const Dialog(child: EditReviewForm());
      },
    );

    if (result == null) return;

    final review = Review(
      title: result["title"]! as String,
      rating: result["rating"]! as int,
      comment: result["comment"] as String?,
    );

    setState(() {
      list.add(review);
    });
  }

  Future<void> editReview(int index) async {
    final currentReview = list[index];
    final result = await showDialog<Json>(
      context: context,
      builder: (context) {
        return Dialog(
          child: EditReviewForm(
            review: currentReview,
          ),
        );
      },
    );

    if (result == null) return;

    final editedReview = Review(
      title: result["title"]! as String,
      rating: result["rating"]! as int,
      comment: result["comment"] as String?,
    );

    setState(() {
      list[index] = editedReview;
    });
  }

  void deleteReview(int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("le nostre recensioni! 🎉"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addReview,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final (i, review) in list.indexed)
            ListTile(
              title: Text(review.title),
              subtitle: switch (review.comment) {
                null => null,
                final value => Text(value),
              },
              leading: IconButton(
                onPressed: () {
                  unawaited(editReview(i));
                },
                icon: const Icon(Icons.edit),
              ),
              trailing: IconButton(
                onPressed: () {
                  deleteReview(i);
                },
                icon: const Icon(Icons.delete),
              ),
            ),
        ],
      ),
    );
  }
}

class EditReviewForm extends StatefulWidget {
  const EditReviewForm({
    super.key,
    this.review,
  });
  final Review? review;

  @override
  State<EditReviewForm> createState() => _EditReviewFormState();
}

class _EditReviewFormState extends State<EditReviewForm> {
  late final FormGroup form;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      "title": FormControl<String>(
        value: widget.review?.title,
        validators: [
          Validators.required,
          Validators.minLength(2),
        ],
      ),
      "comment": FormControl<String>(
        value: widget.review?.comment,
      ),
      "rating": FormControl<int>(
        value: widget.review?.rating,
        validators: [
          Validators.required,
          Validators.min(1),
          Validators.max(5),
        ],
      ),
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: form,
      child: Column(
        children: [
          ReactiveTextField<String>(
            formControlName: "title",
          ),
          ReactiveTextField<String>(
            formControlName: "comment",
          ),
          ReactiveTextField<int>(
            formControlName: "rating",
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return ElevatedButton.icon(
                onPressed: form.valid ? saveReview : null,
                icon: const Icon(Icons.save),
                label: const Text("salva"),
              );
            },
          ),
        ],
      ),
    );
  }

  void saveReview() {
    Navigator.pop(context, form.value);
  }
}

class Review {
  Review({
    required this.title,
    required this.rating,
    this.comment,
  });
  String title;
  int rating;
  String? comment;
}

typedef Json = Map<String, Object?>;
