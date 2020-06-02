import 'package:flutter/material.dart';
import 'package:my_shop/screens/product_details/product_details_screen.dart';

import './screens/products_overview/products_overview_screens.dart';
import './screens/product_details/product_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailsScreen.routeName: (context) =>
            ProductDetailsScreen(title: 'jeelo'),
      },
    );
  }
}
