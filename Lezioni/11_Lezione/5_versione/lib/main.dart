import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/misc.dart";
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

class RickAndMortyApp extends ConsumerStatefulWidget {
  const RickAndMortyApp({
    super.key,
  });

  @override
  ConsumerState<RickAndMortyApp> createState() => _RickAndMortyAppState();
}

class _RickAndMortyAppState extends ConsumerState<RickAndMortyApp> {
  String? q;

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(rickAndMortyProvider(q));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty Episodes"),
      ),
      body: Column(
        spacing: 20,
        children: [
          Padding(
            padding: const .symmetric(horizontal: 320),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  q = value;
                });
              },
            ),
          ),
          Expanded(
            child: switch (result) {
              AsyncLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              AsyncError() => const Center(
                child: Text("qualcosa è andato storto, riprova più tardi"),
              ),
              AsyncData(:final value) => ListView(
                children: [
                  for (final character in value.results)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return CharacterDetailDialog(
                                    characterId: character.id,
                                  );
                                },
                              );
                            },
                            child: Text(character.name),
                          ),
                          Image.network(character.image),
                        ],
                      ),
                    ),
                ],
              ),
            },
          ),
        ],
      ),
    );
  }
}

class CharacterDetailDialog extends ConsumerWidget {
  const CharacterDetailDialog({
    required this.characterId,
    super.key,
  });
  final int characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterDetails = ref.watch(characterProvider(characterId));

    return Dialog(
      insetPadding: const .symmetric(
        horizontal: 480,
        vertical: 96,
      ),
      child: Scaffold(
        body: Center(
          child: switch (characterDetails) {
            AsyncLoading() => const CircularProgressIndicator(),
            AsyncError() => const Text("qualcosa è andato storto, riprova più tardi"),
            AsyncData(:final value) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value.name),
                Image.network(value.image),
                Text("Status: ${value.status}"),
                Text("Species: ${value.species}"),
              ],
            ),
          },
        ),
      ),
    );
  }
}

final FutureProviderFamily<RickAndMortyResponse, String?> rickAndMortyProvider =
    FutureProvider.autoDispose.family<RickAndMortyResponse, String?>((ref, query) async {
      final logger = TalkerDioLogger();
      final client = Dio();
      ref.onDispose(client.close);
      client.interceptors.add(logger);
      final api = RickAndMortyApi(client);
      final result = await api.fetchCharacters(query: query);

      return result;
    });

final FutureProviderFamily<EpisodeResponseList, String?> episodesProvider = FutureProvider
    .autoDispose
    .family<EpisodeResponseList, String?>((ref, query) async {
      final logger = TalkerDioLogger();
      final client = Dio();
      ref.onDispose(client.close);
      client.interceptors.add(logger);
      final api = RickAndMortyApi(client);
      final result = await api.fetchEpisodes(query: query);

      return result;
    });

final FutureProviderFamily<CharacterResponse, int> characterProvider = FutureProvider
    .autoDispose
    .family<CharacterResponse, int>((ref, id) async {
      final logger = TalkerDioLogger();
      final client = Dio();
      ref.onDispose(client.close);
      client.interceptors.add(logger);
      final api = RickAndMortyApi(client);

      await Future<void>.delayed(const Duration(seconds: 4));
      final result = await api.fetchCharacterById(id);

      return result;
    });
