import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double ammount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.ammount,
    @required this.products,
    @required this.dateTime,
  });
}
