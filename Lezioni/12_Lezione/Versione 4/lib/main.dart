import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/cat_widgets.dart";
import "package:its_aa_pn_2025_cross_platform/dog_widgets.dart";
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
      home: const DogsAndCatsApp(),
    );
  }
}

class DogsAndCatsApp extends ConsumerStatefulWidget {
  const DogsAndCatsApp({
    super.key,
  });

  @override
  ConsumerState<DogsAndCatsApp> createState() => _DogsAndCatsAppState();
}

class _DogsAndCatsAppState extends ConsumerState<DogsAndCatsApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty Episodes"),
      ),
      body: const DefaultTabController(
        length: 2,
        child: TabBarView(
          children: [
            DogBreedsWidget(),
            CatBreedsWidget(),
          ],
        ),
      ),
    );
  }
}
