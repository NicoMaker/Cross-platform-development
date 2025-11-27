import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(
      cartProvider.select(
        (cart) => cart.fold(
          0.0,
          (sum, e) => sum + e.price * e.quantity,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('CART'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/products'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('EMPTY'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                          'qta: ${item.quantity}  unit: ${item.price}  tot: ${(item.price * item.quantity).toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .decrementItem(item.productId);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .incrementItem(item.productId);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .removeItem(item.productId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Text('TOTAL:'),
                const SizedBox(width: 8),
                Text(total.toStringAsFixed(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
