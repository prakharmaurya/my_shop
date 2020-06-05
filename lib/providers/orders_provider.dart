import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/cart.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String uid;
  OrdersProvider(this.authToken, this._orders, this.uid);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shop-app-f3190.firebaseio.com/users/$uid/orders.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          ammount: orderData['ammount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shop-app-f3190.firebaseio.com/users/$uid/orders.json?auth=$authToken';
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
