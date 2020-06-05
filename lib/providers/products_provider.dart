import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String uid;

  ProductsProvider(this.authToken, this._items, this.uid);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Product productFindById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    try {
      final filterString =
          filterByUser ? 'orderBy="creatorId"&equalTo="$uid"' : '';
      var url =
          'https://shop-app-f3190.firebaseio.com/products.json?auth=$authToken&$filterString';
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-app-f3190.firebaseio.com/users/$uid/userFavourites.json?auth=$authToken';

      final favRes = await http.get(url);
      final favData = json.decode(favRes.body);

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: double.parse(prodData['price'].toString()),
            imageUrl: prodData['imageUrl'],
            isFavourite: favData == null ? false : favData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-f3190.firebaseio.com/products.json?auth=$authToken';
    try {
      final res = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': uid,
        }),
      );
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final urlNew =
          'https://shop-app-f3190.firebaseio.com/products/$id.json?auth=$authToken';
      http.patch(
        urlNew,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final urlNew =
        'https://shop-app-f3190.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final res = await http.delete(urlNew);

    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete.');
    } else {
      existingProduct = null;
    }
  }
}
