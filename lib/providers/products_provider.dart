import 'package:flutter/material.dart';

import '../models/product.dart';
import '../dummy_products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items {
    return [..._items];
  }

  Product productFindById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  void addProduct() {
    // TODO: add product
    notifyListeners();
  }
}
