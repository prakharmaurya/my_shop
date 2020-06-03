import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders_provider.dart';
import './widgets/order_item_view.dart';
import '../../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return OrderItemView(orderData.orders[index]);
        },
        itemCount: orderData.orders.length,
      ),
    );
  }
}
