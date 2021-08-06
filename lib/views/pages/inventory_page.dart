import 'package:flutter/material.dart';
import 'package:market_scanner/models/product_model.dart';
import 'package:market_scanner/providers/products_inventory.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/views/pages/set_product_page.dart';
import 'package:market_scanner/views/widget/app_bar_inventory.dart';
import 'package:market_scanner/views/widget/product_card.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productsInventory = Provider.of<ProductsInventory>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: StaticResources.darkPuple,
        onPressed: () {
          Navigator.pushNamed(context, SetProductPage.routeName,
              arguments: SetProductArguments(pageEvent: PageEvent.Create));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBarInventory(appBar: AppBar()),
      body: Container(
          child: Column(
        children: getProducts(
          size,
          productsInventory,
        ),
      )),
    );
  }

  List<Widget> getProducts(
    Size size,
    ProductsInventory productsInventory,
  ) {
    List<Widget> widgets = [];
    for (var i = 0; i < productsInventory.productsBase.length; i++) {
      ProductModel product = productsInventory.productsBase[i];
      widgets
        ..add(GestureDetector(
          onLongPress: () {
            if (!productsInventory.selectedProducts.contains(product)) {
              productsInventory.addToSelectedProducts(
                productsInventory.productsBase[i],
              );
            }
          },
          onTap: () {
            if (!productsInventory.selectedProducts.contains(product)) {
              productsInventory.addToSelectedProducts(
                productsInventory.productsBase[i],
              );
            } else {
              productsInventory.removeFromSelectedProducts(product);
            }
          },
          child: ProductCard(
            traveling: Text(
              "${product.dateTime.year}/${product.dateTime.month}/${product.dateTime.day}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            selected: productsInventory.selectedProducts.contains(product),
            size: size,
            productName: product.name,
            price: product.price,
            barCode: product.barCode,
            pathImage: product.path,
          ),
        ));
    }
    return widgets;
  }
}
