import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cart.dart';
import '../../../providers/cart_provider.dart';

class CartItemView extends StatelessWidget {
  final CartItem _item;
  final String productId;

  CartItemView(
    this._item,
    this.productId,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you really want to remove the item fomr cart?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      background: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('₹${_item.price.toString()}'),
                ),
              ),
            ),
            title: Text(_item.title),
            subtitle: Text('Total: ₹${_item.quantity * _item.price}'),
            trailing: Text('${_item.quantity.toString()} x'),
          ),
        ),
      ),
    );
  }
}
