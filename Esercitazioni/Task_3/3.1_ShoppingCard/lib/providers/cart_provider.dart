import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addItem(Product product) {
    final existingIndex = state.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [
        ...state,
        CartItem(
          productId: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          quantity: 1,
        ),
      ];
    }
  }

  void incrementItem(String productId) {
    state = [
      for (final item in state)
        if (item.productId == productId)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ];
  }

  void decrementItem(String productId) {
    final existingIndex = state.indexWhere((item) => item.productId == productId);
    
    if (existingIndex >= 0) {
      if (state[existingIndex].quantity > 1) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == existingIndex)
              state[i].copyWith(quantity: state[i].quantity - 1)
            else
              state[i],
        ];
      } else {
        state = state.where((item) => item.productId != productId).toList();
      }
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => state.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);
