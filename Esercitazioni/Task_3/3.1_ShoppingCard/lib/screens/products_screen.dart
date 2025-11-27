import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final cartCount = ref.watch(
      cartProvider.select(
        (cart) => cart.fold(0, (sum, e) => sum + e.quantity),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODOTTI'),
        actions: [
          TextButton(
            onPressed: () => context.go('/cart'),
            child: Text('CART ($cartCount)'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return ListTile(
            title: Text(p.name),
            subtitle: Text(p.price.toString()),
            trailing: ElevatedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).addItem(p);
              },
              child: const Text('ADD'),
            ),
          );
        },
      ),
    );
  }
}
