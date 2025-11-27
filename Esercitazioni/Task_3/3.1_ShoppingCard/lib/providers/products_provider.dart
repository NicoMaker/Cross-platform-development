// providers/products_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final productsProvider = Provider<List<Product>>((ref) {
  return [
    Product(id: '1', name: 'Laptop', price: 999.99, imageUrl: 'https://via.placeholder.com/150'),
    Product(id: '2', name: 'Smartphone', price: 699.99, imageUrl: 'https://via.placeholder.com/150'),
    Product(id: '3', name: 'Headphones', price: 199.99, imageUrl: 'https://via.placeholder.com/150'),
    Product(id: '4', name: 'Tablet', price: 499.99, imageUrl: 'https://via.placeholder.com/150'),
    Product(id: '5', name: 'Smartwatch', price: 299.99, imageUrl: 'https://via.placeholder.com/150'),
  ];
});
