import 'package:flutter/material.dart';
import 'package:market_scanner/providers/products_cash_register.dart';
import 'package:market_scanner/resources/alerts.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/resources/utils.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({Key? key, required this.productsCashRegister})
      : super(key: key);
  final ProductsCashRegister productsCashRegister;

  @override
  Widget build(BuildContext context) {
    int totalPrice = getTotalPrice();
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('TOTAL'),
                Text(
                  Utils().moneyFormat((totalPrice).toString()),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (totalPrice > 0)
            Container(
                margin: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    bool clear = await _areYouSureClearProducts(context);
                    if (clear) {
                      productsCashRegister.clearProductsBase();
                      productsCashRegister.clearSelectedProducts();
                    }
                  },
                  child: Text('Restore'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(StaticResources.darkPuple)),
                ))
          else
            Container()
        ],
      ),
      width: double.infinity,
      height: size.height * 0.15,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(5, 5),
          color: Colors.grey,
        )
      ]),
    );
  }

  Future<bool> _areYouSureClearProducts(BuildContext context) async {
    bool clear = false;
    await Alerts().showGenericAlert(
      context: context,
      tilte: "Restore",
      description: "Are you sure of restoring the products registered?",
      actionOne: ActionModel(
        onPressed: () {
          clear = false;
          Navigator.pop(context);
        },
        title: "Cancel",
        filled: false,
      ),
      actionTwo: ActionModel(
        onPressed: () {
          clear = true;
          Navigator.pop(context);
        },
        title: "Accept",
      ),
    );
    return clear;
  }

  int getTotalPrice() {
    int totalPrice = 0;
    productsCashRegister.productsBase.forEach((product) {
      int totalPriceTwo =
          int.parse((int.parse(product.price) * product.amount!).toString());
      totalPrice += totalPriceTwo;
    });
    return totalPrice;
  }
}
