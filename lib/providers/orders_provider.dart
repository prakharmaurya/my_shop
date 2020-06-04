import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/cart.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-f3190.firebaseio.com/orders.json';
    final dateTime = DateTime.now();
    try {
      final res = await http.post(
        url,
        body: json.encode({
          'ammount': total,
          'dateTime': dateTime.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          ammount: total,
          dateTime: dateTime,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (err) {}
  }
}
