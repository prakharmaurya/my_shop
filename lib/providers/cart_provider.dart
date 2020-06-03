import 'package:flutter/foundation.dart';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (exsitingCartItem) => CartItem(
          id: exsitingCartItem.id,
          title: exsitingCartItem.title,
          quantity: exsitingCartItem.quantity + 1,
          price: exsitingCartItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  double get getTotalAmmount {
    double total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }
}
