import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/rick_and_morty_api.dart";
import "package:talker_dio_logger/talker_dio_logger_interceptor.dart";
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
      home: const RickAndMortyApp(),
    );
  }
}

class RickAndMortyApp extends ConsumerWidget {
  const RickAndMortyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(rickAndMortyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty Characters"),
      ),
      body: switch (result) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        AsyncError() => const Center(
          child: Text("qualcosa è andato storto, riprova più tardi"),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final character in value.results)
              Column(
                children: [
                  Text(character.name),
                  Image.network(character.image),
                  Text(character.status),
                ],
              ),
          ],
        ),
      },
    );
  }
}

final FutureProvider<RickAndMortyResponse> rickAndMortyProvider =
    FutureProvider.autoDispose<RickAndMortyResponse>((ref) async {
      final logger = TalkerDioLogger();
      final client = Dio();
      client.interceptors.add(logger);
      final api = RickAndMortyApi(client);
      final result = await api.fetchCharacters();

      return result;
    });
