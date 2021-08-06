import 'package:flutter/material.dart';
import 'package:market_scanner/providers/products_inventory.dart';
import 'package:market_scanner/resources/alerts.dart';
import 'package:market_scanner/resources/hive_database.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/views/pages/set_product_page.dart';
import 'package:provider/provider.dart';

class AppBarInventory extends StatelessWidget implements PreferredSizeWidget {
  const AppBarInventory({Key? key, required this.appBar}) : super(key: key);
  final AppBar appBar;
  @override
  Widget build(BuildContext context) {
    ProductsInventory productsInventory = Provider.of(context);
    return AppBar(
      backgroundColor: StaticResources.darkPuple,
      title: Text('Inventory'),
      centerTitle: true,
      actions: [
        productsInventory.selectedProducts.length > 0
            ? IconButton(
                onPressed: () async {
                  bool removeItems = await _areYouSureRemoveItems(
                      context, productsInventory.selectedProducts.length);
                  if (removeItems) {
                    productsInventory.selectedProducts.forEach((product) {
                      DBHive().deleteProduct(product.barCode);
                    });
                    productsInventory.removeSelectedAndBaseProducts();
                  }
                },
                icon: Icon(Icons.delete))
            : Container(),
        productsInventory.selectedProducts.length == 1
            ? IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SetProductPage.routeName,
                      arguments: SetProductArguments(
                        pageEvent: PageEvent.Update,
                        productModel: productsInventory.selectedProducts.first,
                      ));
                },
                icon: Icon(Icons.edit))
            : Container(),
      ],
    );
  }

  Future<bool> _areYouSureRemoveItems(
      BuildContext context, int amountItems) async {
    bool remove = false;
    await Alerts().showGenericAlert(
      context: context,
      tilte: "Irreversible action",
      description: "Are you sure of remove $amountItems items from inventory?",
      actionOne: ActionModel(
        onPressed: () {
          remove = false;
          Navigator.pop(context);
        },
        title: "Cancel",
        filled: false,
      ),
      actionTwo: ActionModel(
        onPressed: () {
          remove = true;
          Navigator.pop(context);
        },
        title: "Accept",
      ),
    );
    return remove;
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
