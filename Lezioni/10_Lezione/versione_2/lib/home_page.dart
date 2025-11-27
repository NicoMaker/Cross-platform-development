import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("esercitazioni di gruppo - correzioni"),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 40,
          vertical: 16,
        ),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            _HomeCard(
              onTap: () async {
                await context.push("/counter");
              },
              label: "Esercitazione 1.1",
            ),
            _HomeCard(
              label: "Esercitazione 1.2",
              onTap: () async {
                await context.push("/greet");
              },
            ),
            _HomeCard(
              label: "Esercitazione 1.3",
              onTap: () async {
                await context.push("/colors");
              },
            ),
            _HomeCard(
              label: "Esercitazione 2.1",
              onTap: () async {
                await context.push("/todo");
              },
            ),
            _HomeCard(
              label: "Esercitazione 2.2",
              onTap: () async {
                await context.push("/recipes");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.label,
    required this.onTap,
  });
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
