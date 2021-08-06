import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_scanner/providers/products_cash_register.dart';
import 'package:market_scanner/providers/products_inventory.dart';
import 'package:market_scanner/resources/alerts.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/resources/utils.dart';
import 'package:market_scanner/views/pages/developer_page.dart';
import 'package:market_scanner/views/widget/custom_textfield.dart';
import 'package:market_scanner/views/widget/price_widget.dart';
import 'package:market_scanner/views/widget/product_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CashRegisterPage extends StatefulWidget {
  const CashRegisterPage({Key? key}) : super(key: key);

  @override
  _CashRegisterPageState createState() => _CashRegisterPageState();
}

class _CashRegisterPageState extends State<CashRegisterPage> {
  int totalPrice = 0;
  late ProductsCashRegister productsCashRegister;
  late ProductsInventory productsInventory;

  @override
  Widget build(BuildContext context) {
    productsCashRegister = Provider.of<ProductsCashRegister>(context);
    productsInventory = Provider.of<ProductsInventory>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StaticResources.darkPuple,
        title: Text(AppLocalizations.of(context)!.cashRegister),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(
            context,
            DeveloperPage.routeName,
          ),
          icon: Icon(Icons.code),
        ),
        actions: [
          productsCashRegister.selectedProducts.length > 0
              ? IconButton(
                  onPressed: () async {
                    if (await areYouSureRemove()) {
                      productsCashRegister.selectedProducts
                          .forEach((productSelected) {
                        productsCashRegister.productsBase.removeWhere(
                          (productBase) =>
                              productBase.barCode == productSelected.barCode,
                        );
                      });
                      productsCashRegister.clearSelectedProducts();
                    }
                  },
                  icon: Icon(Icons.delete),
                )
              : Container(),
          productsCashRegister.selectedProducts.length == 0
              ? IconButton(
                  onPressed: () async {
                    String barCode = await _askCodeBar();
                    if (barCode.isNotEmpty) {
                      await addProduct(barCode);
                    }
                  },
                  icon: Icon(Icons.add_box),
                )
              : Container(),
          productsCashRegister.selectedProducts.length == 0
              ? IconButton(
                  onPressed: () async {
                    String barCode = await Utils()
                        .openScanBar(AppLocalizations.of(context)!.cancel);
                    if (barCode != "-1") {
                      await addProduct(barCode);
                    }
                  },
                  icon: Icon(FontAwesomeIcons.barcode),
                )
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: size.height * 0.65,
                margin: EdgeInsets.only(bottom: size.height * 0.02),
                child: ListView.builder(
                    itemCount: productsCashRegister.productsBase.length,
                    itemBuilder: (_, index) {
                      var product = productsCashRegister.productsBase[index];
                      var selected = productsCashRegister.selectedProducts
                          .contains(product);
                      return GestureDetector(
                        onTap: () {
                          if (selected) {
                            productsCashRegister
                                .removeFromSelectedProducts(product);
                          } else {
                            productsCashRegister.addToSelectedProducts(product);
                          }
                        },
                        onLongPress: () {
                          if (selected) {
                            productsCashRegister
                                .removeFromSelectedProducts(product);
                          } else {
                            productsCashRegister.addToSelectedProducts(product);
                          }
                        },
                        child: ProductCard(
                          selected: selected,
                          size: size,
                          traveling: GestureDetector(
                              onTap: () async {
                                int newAmount =
                                    await _selectNewAmount(product.amount!);
                                if (newAmount > 0) {
                                  product.amount = newAmount;
                                  productsCashRegister.updateProductBase(
                                      product, product);
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      color: StaticResources.darkPuple,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    product.amount.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ))),
                          productName: product.name,
                          price: product.price,
                          barCode: product.barCode,
                          pathImage: product.path,
                        ),
                      );
                    }),
              ),
              PriceWidget(
                productsCashRegister: productsCashRegister,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addProduct(String barCode) async {
    int index = productsInventory.productsBase
        .indexWhere((product) => product.barCode == barCode);
    bool hasFoundProduct = index >= 0;
    if (hasFoundProduct) {
      bool isAlreadyInBase = productsCashRegister.productsBase.any(
        (product) => product.barCode == barCode,
      );
      if (isAlreadyInBase) {
        var productInBase = productsCashRegister.productsBase
            .firstWhere((product) => product.barCode == barCode);
        var newProduct = productInBase;
        int amountPlusOne = newProduct.amount! + 1;
        newProduct.amount = amountPlusOne;
        productsCashRegister.updateProductBase(productInBase, newProduct);
      } else {
        var productFound = productsInventory.productsBase[index];
        productFound.amount = 1;
        productsCashRegister.addToProductsBase(productFound);
      }
    } else {
      Alerts().showGenericAlert(
        context: context,
        tilte: AppLocalizations.of(context)!.notFound,
        description:
            "${AppLocalizations.of(context)!.theProductWithTheCodeBar} $barCode ${AppLocalizations.of(context)!.hasNotBeenFound}",
        actionOne: ActionModel(
          onPressed: () => Navigator.pop(context),
          title: AppLocalizations.of(context)!.accept,
        ),
      );
    }
  }

  Future<String> _askCodeBar() async {
    var controller = TextEditingController();
    await Alerts().showGenericAlert(
      isDismissible: false,
      context: context,
      tilte: AppLocalizations.of(context)!.insertProduct,
      description: AppLocalizations.of(context)!.insertTheCodeBar,
      content: Column(
        children: [
          SizedBox(height: 25),
          CustomTextField(
            controller: controller,
            hintText: '1234',
          ),
        ],
      ),
      actionOne: ActionModel(
        onPressed: () {
          controller.text = "";
          Navigator.pop(context);
        },
        title: AppLocalizations.of(context)!.cancel,
        filled: false,
      ),
      actionTwo: ActionModel(
        onPressed: () {
          if (controller.text.isNotEmpty) {
            Navigator.pop(context);
          }
        },
        title: AppLocalizations.of(context)!.confirm,
        filled: true,
      ),
    );
    controller.dispose();
    return controller.text;
  }

  Future<int> _selectNewAmount(int amount) async {
    TextEditingController controller = TextEditingController();

    controller.text = amount.toString();
    await Alerts().showGenericAlert(
      context: context,
      tilte: AppLocalizations.of(context)!.amount,
      content: Column(
        children: [
          SizedBox(height: 25),
          CustomTextField(
            controller: controller,
            keyboardType: TextInputType.number,
            format: Format.justInteger,
          )
        ],
      ),
      description: AppLocalizations.of(context)!.selectAmountToRegister,
      actionOne: ActionModel(
          onPressed: () {
            controller.text = "-1";
            Navigator.pop(context);
          },
          title: AppLocalizations.of(context)!.cancel,
          filled: false),
      actionTwo: ActionModel(
          onPressed: () {
            Navigator.pop(context);
          },
          title: AppLocalizations.of(context)!.accept),
    );
    if (controller.text.isEmpty) controller.text = "-1";
    return int.parse(controller.text);
  }

  Future<bool> areYouSureRemove() async {
    bool remove = false;
    await Alerts().showGenericAlert(
      context: context,
      tilte: AppLocalizations.of(context)!.remove,
      description:
          "${AppLocalizations.of(context)!.areYouSureOfRemove} ${productsCashRegister.selectedProducts.length} products from the bill?",
      actionOne: ActionModel(
        onPressed: () {
          remove = false;
          Navigator.pop(context);
        },
        filled: false,
        title: "Cancel",
      ),
      actionTwo: ActionModel(
        onPressed: () {
          remove = true;
          Navigator.pop(context);
        },
        filled: true,
        title: AppLocalizations.of(context)!.accept,
      ),
    );
    return remove;
  }
}
