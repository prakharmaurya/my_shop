import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite = false;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void toggleFavoriteStatus(String token, String uid) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://shop-app-f3190.firebaseio.com/users/$uid/userFavourites/$id.json?auth=$token';
    try {
      final res = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (res.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (err) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
