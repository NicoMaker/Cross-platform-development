import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/colors_page/state/brightness_changer.dart";
import "package:its_aa_pn_2025_cross_platform/colors_page/state/color_changer.dart";
import "package:its_aa_pn_2025_cross_platform/router.dart";

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final color = ref.watch(colorChangerProvider);
    final brightness = ref.watch(brightnessProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color,
          brightness: brightness,
        ),
      ),
    );
  }
}
