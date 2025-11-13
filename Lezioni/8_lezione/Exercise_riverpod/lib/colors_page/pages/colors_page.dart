import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/colors_page/state/brightness_changer.dart";
import "package:its_aa_pn_2025_cross_platform/colors_page/state/color_changer.dart";

class ColorsPage extends ConsumerStatefulWidget {
  const ColorsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ColorsPageState();
}

class _ColorsPageState extends ConsumerState<ColorsPage> {
  @override
  Widget build(BuildContext context) {
    final brightness = ref.watch(brightnessProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("esercitazione 1.3"),
        actions: [
          Switch(
            value: brightness == Brightness.light,
            onChanged: (value) {
              ref.read(brightnessProvider.notifier).toggle(value: value);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 40),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Cambia il tuo colore!!"),
            const SizedBox(height: 40),
            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(colorChangerProvider.notifier).red();
                  },
                  child: const Text("rosso!"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(colorChangerProvider.notifier).green();
                  },
                  child: const Text("verde!"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(colorChangerProvider.notifier).blue();
                  },
                  child: const Text("blu!"),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(colorChangerProvider.notifier).randomize();
              },
              icon: const Icon(Icons.shuffle),
              label: const Text("a caso!"),
            ),
          ],
        ),
      ),
    );
  }
}
