import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../dummy_products.dart';
import './widgets/product_item.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Product> loadedProducts = dummyProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ProductItem(
            id: loadedProducts[index].id,
            title: loadedProducts[index].title,
            imageUrl: loadedProducts[index].imageUrl,
          );
        },
        itemCount: loadedProducts.length,
      ),
    );
  }
}
