import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products_provider.dart';
import './widgets/user_product_item.dart';
import '../../widgets/app_drawer.dart';
import '../edit_product_screen/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context); //will trigger inf loop
    print('Run Once ✌');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                UserProductItem(
                                  productsData.items[index].id,
                                  productsData.items[index].title,
                                  productsData.items[index].imageUrl,
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
