import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders_provider.dart';
import './widgets/order_item_view.dart';
import '../../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    print('run Once✌');
    // final orderData = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            return Center(
              child: Text('There is an error'),
            );
          } else {
            return Consumer<OrdersProvider>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemBuilder: (ctx, index) {
                  return OrderItemView(orderData.orders[index]);
                },
                itemCount: orderData.orders.length,
              ),
            );
          }
        },
      ),
    );
  }
}
