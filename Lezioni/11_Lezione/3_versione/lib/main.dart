// main.dart

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/misc.dart";
import "package:its_aa_pn_2025_cross_platform/rick_and_morty_api.dart";
import "package:its_aa_pn_2025_cross_platform/episode_api.dart";
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
          seedColor: Colors.green, // Cambiato il colore a tema episodio
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
    // 2. riverpod: Guarda il nuovo provider degli episodi
    final result = ref.watch(episodeListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty Episodes"),
      ),
      // 3. UI: Aggiornamento per mostrare la lista degli episodi
      body: switch (result) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        AsyncError() => const Center(
          child: Text(
            "Qualcosa è andato storto nel caricare gli episodi, riprova più tardi",
            textAlign: TextAlign.center,
          ),
        ),
        AsyncData(:final value) => ListView.builder(
          itemCount: value.results.length,
          itemBuilder: (context, index) {
            final episode = value.results[index];
            return ListTile(
              // Titolo: Nome dell'episodio (es. "Pilot")
              title: Text(episode.name),
              // Sottotitolo: Data di trasmissione (es. "December 2, 2013")
              subtitle: Text("Aired: ${episode.airDate}"),
              // Trailer: Numero episodio (es. "S01E01")
              trailing: Text(episode.episode),
            );
          },
        ),
      },
    );
  }
}

// 2. riverpod: Provider per la lista degli episodi
final FutureProvider<EpisodeResponse> episodeListProvider =
    FutureProvider.autoDispose<EpisodeResponse>((ref) async {
  final logger = TalkerDioLogger();
  final client = Dio();
  client.interceptors.add(logger);
  
  // Usa la nuova classe EpisodeApi
  final api = EpisodeApi(client); 
  final result = await api.fetchEpisodes();

  return result;
});


// Il vecchio provider per i personaggi è stato mantenuto ma non più usato nell'UI principale,
// per non eliminare parti di codice che potresti riutilizzare per altre parti dell'app
final FutureProviderFamily<RickAndMortyResponse, String?> rickAndMortyProvider =
    FutureProvider.autoDispose.family<RickAndMortyResponse, String?>((ref, query) async {
      final logger = TalkerDioLogger();
      final client = Dio();
      client.interceptors.add(logger);
      final api = RickAndMortyApi(client);
      final result = await api.fetchCharacters(query: query);

      return result;
    });