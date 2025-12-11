// ignore_for_file: specify_nonobvious_property_types

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
      home: const ReviewListWidget(),
    );
  }
}

class ReviewListWidget extends ConsumerStatefulWidget {
  const ReviewListWidget({
    super.key,
  });

  @override
  ConsumerState<ReviewListWidget> createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends ConsumerState<ReviewListWidget> {
  Future<void> addReview() async {
    final result = await showDialog<Json>(
      context: context,
      builder: (context) {
        return const Dialog(child: EditReviewForm());
      },
    );

    if (result == null) return;

    ref.read(reviewsProvider.notifier).addReview(result);
  }

  Future<void> editReview(int index) async {
    final current = ref.read(reviewsProvider)[index];

    final result = await showDialog<Json>(
      context: context,
      builder: (context) {
        return Dialog(
          child: EditReviewForm(
            review: current,
          ),
        );
      },
    );

    if (result == null) return;

    ref.read(reviewsProvider.notifier).editReview(index, result);
  }

  void deleteReview(int index) {
    ref.read(reviewsProvider.notifier).deleteReview(index);
  }

  Future<void> openDetails(int index) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: ReviewDetailWidget(
            index: index,
            onDelete: () {
              ref.read(reviewsProvider.notifier).deleteReview(index);
            },
            onEdit: (form) {
              ref.read(reviewsProvider.notifier).editReview(index, form);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(reviewsProvider);

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
              onTap: () {
                unawaited(openDetails(i));
              },
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

class ReviewDetailWidget extends ConsumerStatefulWidget {
  const ReviewDetailWidget({
    required this.index,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });
  final int index;
  final VoidCallback onDelete;
  final ValueSetter<Json> onEdit;

  @override
  ConsumerState<ReviewDetailWidget> createState() => _ReviewDetailWidgetState();
}

class _ReviewDetailWidgetState extends ConsumerState<ReviewDetailWidget> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(reviewsProvider);
    final review = list[widget.index];

    return Scaffold(
      appBar: AppBar(
        title: Text(review.title),
        actions: [
          // IconButton(
          //   onPressed: editReview,
          //   icon: const Icon(Icons.edit),
          // ),
          IconButton(
            onPressed: deleteReview,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (review.comment case final value?) Text(value),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < review.rating; i++)
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
              for (var i = 0; i < 5 - review.rating; i++)
                const Icon(
                  Icons.star_border,
                  color: Colors.yellow,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteReview() {
    widget.onDelete();
    Navigator.pop(context);
  }

  // Future<void> editReview() async {
  //   final edited = widget.onEdit();
  //   if (edited == null) return;

  //   setState(() {
  //     review = edited;
  //   });
  // }
}

final reviewsProvider = NotifierProvider.autoDispose<ReviewsNotifier, List<Review>>(
  ReviewsNotifier.new,
);

class ReviewsNotifier extends Notifier<List<Review>> {
  @override
  List<Review> build() {
    return [];
  }

  void addReview(Json form) {
    final newReview = Review(
      title: form["title"]! as String,
      rating: form["rating"]! as int,
      comment: form["comment"] as String?,
    );

    state.add(newReview);
    ref.notifyListeners();
  }

  void editReview(int index, Json form) {
    final editedReview = Review(
      title: form["title"]! as String,
      rating: form["rating"]! as int,
      comment: form["comment"] as String?,
    );

    state[index] = editedReview;
    ref.notifyListeners();
  }

  void deleteReview(int index) {
    state.removeAt(index);
    ref.notifyListeners();
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
