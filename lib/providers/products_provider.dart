import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://image.shutterstock.com/image-photo/girls-beautiful-yellow-skinny-trousers-600w-712737529.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product productFindById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  // void addProduct() {
  //   //add products
  //   notifyListeners();
  // }
}
