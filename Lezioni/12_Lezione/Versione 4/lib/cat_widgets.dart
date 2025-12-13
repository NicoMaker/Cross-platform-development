import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/cats.dart";

class CatBreedsWidget extends ConsumerWidget {
  const CatBreedsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catBreeds = ref.watch(catBreedsProvider);
    final favorites = ref.watch(catFavoriteBreedsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cat Breeds"),
      ),
      body: switch (catBreeds) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        AsyncError(:final error) => Center(
          child: Text("Error: $error"),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final breed in value)
              ListTile(
                onTap: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (context) {
                      return CatBreedImagesWidget(breedId: breed.id);
                    },
                  );
                },
                title: Text(breed.name),
                trailing: IconButton(
                  onPressed: () {
                    ref.read(catFavoriteBreedsProvider.notifier).toggleFavorite(breed);
                  },
                  icon: Icon(
                    favorites.contains(breed) ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
              ),
          ],
        ),
      },
    );
  }
}

class CatBreedImagesWidget extends ConsumerWidget {
  const CatBreedImagesWidget({
    required this.breedId,
    super.key,
  });
  final String breedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(catImagesByBreedProvider(breedId));

    return Dialog(
      child: Scaffold(
        appBar: AppBar(
          title: Text(breedId),
        ),
        body: switch (images) {
          AsyncLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          AsyncError(:final error) => Center(
            child: Text("Error: $error"),
          ),
          AsyncData(:final value) => GridView.count(
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
            children: [
              for (final image in value)
                Padding(
                  padding: const .all(8),
                  child: Image.network(image.url),
                ),
            ],
          ),
        },
      ),
    );
  }
}
