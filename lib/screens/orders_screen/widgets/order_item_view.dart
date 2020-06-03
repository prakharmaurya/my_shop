import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';

class OrderItemView extends StatelessWidget {
  final OrderItem order;
  OrderItemView(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('₹${order.ammount}'),
            subtitle: Text(
              DateFormat('E-dd/MMM/yyyy-hh:mm a').format(order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
