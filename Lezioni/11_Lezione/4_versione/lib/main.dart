// main.dart

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/misc.dart";
// Importa la nuova API
import "package:its_aa_pn_2025_cross_platform/http_cat_api.dart"; 
import "package:talker_dio_logger/talker_dio_logger_interceptor.dart";
import "package:talker_riverpod_logger/talker_riverpod_logger.dart";
import "package:its_aa_pn_2025_cross_platform/http_cat_api.dart";


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
          seedColor: Colors.deepPurple, // Colore a tema per Http.cat
        ),
        useMaterial3: true,
      ),
      home: const HttpCatApp(),
    );
  }
}

class HttpCatApp extends ConsumerStatefulWidget {
  const HttpCatApp({
    super.key,
  });

  @override
  ConsumerState<HttpCatApp> createState() => _HttpCatAppState();
}

class _HttpCatAppState extends ConsumerState<HttpCatApp> {
  // Stato per memorizzare il codice HTTP inserito
  int statusCode = 404; // Valore predefinito

  @override
  Widget build(BuildContext context) {
    // 2. Riverpod: guarda il provider con il codice di stato corrente
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
                    if (newCode != null) {
                      setState(() {
                        statusCode = newCode;
                      });
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
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 10),
                        Text(
                          "Errore nel caricare l'immagine:\n${error.toString().split(':').last.trim()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        // Mostra un codice 404 generico se il codice è invalido
                        const Text("Riprova con un codice HTTP valido (es. 200, 404, 500)"),
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
                            child: Text("Impossibile visualizzare l'immagine (formato non supportato o dati corrotti)."),
                          );
                        },
                      ),
                    ),
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

// 2. Riverpod: Provider che fetcha i byte dell'immagine per un codice di stato specifico
// Restituisce un Uint8List che è l'equivalente Flutter/Dart di List<int>
final FutureProviderFamily<Uint8List, int> httpCatProvider =
    FutureProvider.autoDispose.family<Uint8List, int>((ref, statusCode) async {
  final logger = TalkerDioLogger();
  final client = Dio();
  client.interceptors.add(logger);
  
  final api = HttpCatApi(client);
  final result = await api.fetchCatImage(statusCode);

  // Converte List<int> in Uint8List per l'uso con Image.memory
  return Uint8List.fromList(result);
});

// Ho rimosso i vecchi provider dei personaggi e degli episodi per mantenere main.dart pulito 
// e focalizzato su HttpCatApp.