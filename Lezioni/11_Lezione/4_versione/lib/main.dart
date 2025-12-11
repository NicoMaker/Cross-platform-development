// main.dart

import "dart:typed_data"; // Necessario per Uint8List

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter/services.dart"; // (qui in realtà non serve per Uint8List, ma se ti serve altro lascialo)

import "http_cat_api.dart";
import "package:talker_dio_logger/talker_dio_logger_interceptor.dart";
import "package:talker_riverpod_logger/talker_riverpod_logger.dart";

void main() {
  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          settings: const TalkerRiverpodLoggerSettings(
            printProviderDisposed: true,
          ),
        ),
      ],
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
          seedColor: Colors.deepPurple, // Colore a tema per Http.cat
        ),
        useMaterial3: true,
      ),
      home: const HttpCatApp(),
    );
  }
}

class HttpCatApp extends ConsumerStatefulWidget {
  const HttpCatApp({super.key});

  @override
  ConsumerState<HttpCatApp> createState() => _HttpCatAppState();
}

class _HttpCatAppState extends ConsumerState<HttpCatApp> {
  // Stato per memorizzare il codice HTTP inserito
  int statusCode = 404; // Valore predefinito

  @override
  Widget build(BuildContext context) {
    // Riverpod: guarda il provider con il codice di stato corrente
    final catImageResult = ref.watch(httpCatProvider(statusCode));

    return Scaffold(
      appBar: AppBar(
        title: const Text("HTTP Status Cats 😼"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextField per l'input del codice di stato
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Codice Stato HTTP (es. 200, 404, 500)",
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onSubmitted: (value) {
                    final newCode = int.tryParse(value);

                    // Controllo sul range dei codici HTTP
                    if (newCode != null &&
                        newCode >= 100 &&
                        newCode < 600) {
                      setState(() {
                        statusCode = newCode;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Inserisci un codice HTTP valido (100-599).",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Visualizzazione dell'immagine
              Expanded(
                child: switch (catImageResult) {
                  AsyncLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  AsyncError(:final error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Errore nel caricare l'immagine:\n"
                            "${error is DioException ? error.message : error.toString().split(':').last.trim()}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const Text(
                            "Riprova con un codice HTTP valido (es. 200, 404, 500)",
                          ),
                        ],
                      ),
                    ),
                  AsyncData(:final value) => Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.memory(
                          value, // Visualizza i byte dell'immagine
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                "Impossibile visualizzare l'immagine (formato non supportato o dati corrotti).",
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  // Caso di fallback
                  _ => const Center(
                      child: Text("Stato Provider inatteso."),
                    ),
                },
              ),
              const SizedBox(height: 10),
              Text(
                "Attualmente visualizzato: Codice $statusCode",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Provider che fetcha i byte dell'immagine per un codice di stato specifico
final httpCatProvider =
    FutureProvider.autoDispose.family<Uint8List, int>((ref, statusCode) async {
  final logger = TalkerDioLogger();
  final client = Dio();

  client.interceptors.add(logger);

  // Rimuove l'interceptor alla fine per evitare memory leak
  ref.onDispose(() {
    client.interceptors.remove(logger);
    client.close();
  });

  final api = HttpCatApi(client);
  final result = await api.fetchCatImage(statusCode);

  // Converte List<int> in Uint8List per l'uso con Image.memory
  return Uint8List.fromList(result);
});
