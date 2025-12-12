import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/fbi_list.dart";
import "package:its_aa_pn_2025_cross_platform/models.dart";
import "package:its_aa_pn_2025_cross_platform/saved_fbi_list.dart";
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
      home: const FbiWantedApp(),
    );
  }
}

class FbiWantedApp extends ConsumerStatefulWidget {
  const FbiWantedApp({
    super.key,
  });

  @override
  ConsumerState<FbiWantedApp> createState() => _FbiWantedAppState();
}

class _FbiWantedAppState extends ConsumerState<FbiWantedApp> {
  @override
  Widget build(BuildContext context) {
    final wantedList = ref.watch(fbiListProvider);
    final saved = ref.watch(savedFbiListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty Episodes"),
        actions: [
          Padding(
            padding: const .symmetric(horizontal: 16),
            child: Badge.count(
              isLabelVisible: saved.isNotEmpty,
              count: saved.length,
              child: IconButton(
                onPressed: showSaved,
                icon: const Icon(Icons.bookmark),
              ),
            ),
          ),
        ],
      ),
      body: switch (wantedList) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        AsyncError() => const Center(
          child: Text("qualcosa è andato storto, riprova più tardi"),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final wantedPerson in value)
              Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return FbiWantedPersonDetailsDialog(wantedPerson);
                      },
                    );
                  },
                  child: Column(
                    children: [
                      if (wantedPerson.previewImage case final value?)
                        Image.network(
                          value,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image);
                          },
                        )
                      else
                        const Text("no images found"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      },
    );
  }

  void showSaved() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return const SavedFbiDialog();
      },
    );
  }
}

class SavedFbiDialog extends ConsumerWidget {
  const SavedFbiDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(savedFbiListProvider);

    final theme = Theme.of(context);

    return Dialog(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("my favorite criminals! 💅🏽"),
        ),
        body: list.isEmpty
            ? Center(
                child: Text(
                  "you don't have any favorite felon, yet ☹️",
                  style: theme.textTheme.headlineSmall,
                ),
              )
            : ListView(
                children: [
                  for (final wantedPerson in list)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          if (wantedPerson.previewImage case final value?)
                            Image.network(
                              value,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image);
                              },
                            )
                          else
                            const Text("no images found"),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class FbiWantedPersonDetailsDialog extends ConsumerStatefulWidget {
  const FbiWantedPersonDetailsDialog(
    this.wanted, {
    super.key,
  });
  final FbiModel wanted;

  @override
  ConsumerState<FbiWantedPersonDetailsDialog> createState() =>
      _FbiWantedPersonDetailsDialogState();
}

class _FbiWantedPersonDetailsDialogState
    extends ConsumerState<FbiWantedPersonDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: const .symmetric(
        horizontal: 480,
        vertical: 96,
      ),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: saveForLater,
              icon: const Icon(Icons.save),
            ),
            IconButton(
              onPressed: remove,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.wanted.displayDetails),
              Text(widget.wanted.displayReason),
              SizedBox(
                height: size.height * 0.4,
                child: ListView(
                  scrollDirection: .horizontal,
                  children: [
                    for (final image in widget.wanted.images) //
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.network(image),
                      ),
                  ],
                ),
              ),
              Text(widget.wanted.displayAge),
              Text(widget.wanted.displayHeight),
              Text(widget.wanted.displayWeight),
              Text(widget.wanted.displayReward),
            ],
          ),
        ),
      ),
    );
  }

  void saveForLater() {
    ref.read(savedFbiListProvider.notifier).addFavorite(widget.wanted);
  }

  void remove() {
    ref.read(savedFbiListProvider.notifier).removeFavorite(widget.wanted);
  }
}
