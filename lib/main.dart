import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview/products_overview_screens.dart';
import './screens/product_details/product_details_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './screens/cart_screen/cart_screen.dart';
import './providers/orders_provider.dart';
import './screens/orders_screen/oreders_screen.dart';
import './screens/user_products_screen/user_products_screen.dart';
import './screens/edit_product_screen/edit_product_screen.dart';
import './screens/auth_screen/auth_screen.dart';
import './providers/auth_provider.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (ctx, authData, previousProducts) => ProductsProvider(
            authData.token,
            previousProducts == null ? [] : previousProducts.items,
            authData.uid,
          ),
          create: (_) {
            return;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            update: (ctx, authData, previousOrders) => OrdersProvider(
                  authData.token,
                  previousOrders == null ? [] : previousOrders.orders,
                  authData.uid,
                ),
            create: (_) {
              return;
            }),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Lato',
          ),
          home: authData.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.routeName: (context) =>
                ProductsOverviewScreen(),
            ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
