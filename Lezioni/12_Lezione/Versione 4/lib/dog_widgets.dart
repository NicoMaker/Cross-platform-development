import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/dogs.dart";

class DogBreedsWidget extends ConsumerWidget {
  const DogBreedsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dogBreeds = ref.watch(dogBreedsProvider);
    final favorites = ref.watch(dogFavoriteBreedsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dog Breeds"),
      ),
      body: switch (dogBreeds) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        AsyncError(:final error) => Center(
          child: Text("Error: $error"),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final breed in value.breeds)
              ListTile(
                onTap: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (context) {
                      return DogBreedImagesWidget(breed: breed);
                    },
                  );
                },
                title: Text(breed),
                trailing: IconButton(
                  onPressed: () {
                    ref.read(dogFavoriteBreedsProvider.notifier).toggleFavorite(breed);
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

class DogBreedImagesWidget extends ConsumerWidget {
  const DogBreedImagesWidget({
    required this.breed,
    super.key,
  });
  final String breed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(dogImagesByBreedProvider(breed));
    return Dialog(
      child: Scaffold(
        appBar: AppBar(
          title: Text(breed),
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
              for (final imageUrl in value.imageUrls)
                Padding(
                  padding: const .all(8),
                  child: Image.network(imageUrl),
                ),
            ],
          ),
        },
      ),
    );
  }
}
