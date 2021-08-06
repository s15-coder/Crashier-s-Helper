import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_scanner/models/product_model.dart';
import 'package:market_scanner/providers/products_inventory.dart';
import 'package:market_scanner/resources/alerts.dart';
import 'package:market_scanner/resources/hive_database.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/resources/utils.dart';
import 'package:market_scanner/views/widget/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetProductPage extends StatefulWidget {
  SetProductPage({Key? key}) : super(key: key);
  static final routeName = "set_product_page";

  @override
  _SetProductPageState createState() => _SetProductPageState();
}

class _SetProductPageState extends State<SetProductPage> {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  XFile? file;
  late ProductsInventory productsInventory;
  late SetProductArguments arguments;
  bool firstCharge = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstCharge) {
      final args = ModalRoute.of(context)!.settings.arguments;
      assert(args != null && args is SetProductArguments);
      arguments = (args as SetProductArguments);
      if (arguments.pageEvent == PageEvent.Update) {
        codeController.value =
            TextEditingValue(text: arguments.productModel!.barCode);
        nameController.text = arguments.productModel!.name;
        priceController.text =
            Utils().moneyFormat(arguments.productModel!.price);
        if (arguments.productModel!.path != null)
          file = XFile(arguments.productModel!.path!);
      }
      firstCharge = false;
    }

    productsInventory = Provider.of<ProductsInventory>(context);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onBack,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: StaticResources.darkPuple,
          centerTitle: true,
          title: Text(arguments.pageEvent == PageEvent.Create
              ? AppLocalizations.of(context)!.newProduct
              : AppLocalizations.of(context)!.update),
          actions: [
            arguments.pageEvent == PageEvent.Update
                ? TextButton(
                    onPressed: () async {
                      bool close = await onBack();
                      if (close) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))
                : Container()
          ],
        ),
        body: Container(
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                _imageButton(size, context),
                SizedBox(height: size.height * 0.05),
                _barCodeSection(size, codeController),
                SizedBox(height: size.height * 0.05),
                _nameField(size, nameController),
                SizedBox(height: size.height * 0.05),
                _priceField(size, priceController),
                SizedBox(height: size.height * 0.05),
                _submitButton(size, context),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _barCodeSection(Size size, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Row(
        children: [
          _labelText('${AppLocalizations.of(context)!.barCode}:'),
          Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: CustomTextField(
                  controller: controller,
                  hintText: '1234',
                  keyboardType: TextInputType.name,
                )),
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(StaticResources.darkPuple),
              ),
              onPressed: () async {
                String cancel = AppLocalizations.of(context)!.cancel;
                String barcodeScanRes = await Utils().openScanBar(cancel);
                print('CODE: ' + barcodeScanRes);
                controller.text = barcodeScanRes;
              },
              child: Icon(
                FontAwesomeIcons.qrcode,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  Text _labelText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  Widget _imageButton(Size size, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        file = await Utils().choosePhotoSourceAlert(context);
        setState(() {});
      },
      child: Container(
        width: size.width * 0.5,
        height: size.width * 0.5,
        decoration: BoxDecoration(
            border: Border.all(
              color: StaticResources.darkPuple,
              width: 10,
            ),
            borderRadius: BorderRadius.circular(40)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: size.width * 0.5,
            height: size.width * 0.5,
            child: this.file != null
                ? Image.file(
                    File(file!.path),
                    fit: BoxFit.cover,
                  )
                : Image(
                    image: AssetImage(StaticResources.defaultProductPath),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _nameField(Size size, TextEditingController controller) {
    return Container(
      width: size.width * 0.6,
      child: CustomTextField(
        labelText: AppLocalizations.of(context)!.nameProduct,
        prefixIcon: Icon(
          FontAwesomeIcons.productHunt,
          color: StaticResources.darkPuple,
        ),
        hintText: AppLocalizations.of(context)!.rice,
        controller: controller,
      ),
    );
  }

  Widget _priceField(Size size, TextEditingController controller) {
    return Container(
      width: size.width * 0.6,
      child: CustomTextField(
        labelText: AppLocalizations.of(context)!.price,
        format: Format.toPesos,
        keyboardType: TextInputType.number,
        hintText: '2.500',
        controller: controller,
        prefixIcon: Icon(
          Icons.monetization_on,
          color: StaticResources.darkPuple,
        ),
      ),
    );
  }

  Widget _submitButton(Size size, BuildContext context) {
    return ElevatedButton(
      onPressed: onSet,
      child: Text(
        arguments.pageEvent == PageEvent.Create
            ? AppLocalizations.of(context)!.save.toUpperCase()
            : AppLocalizations.of(context)!.update.toUpperCase(),
        style: TextStyle(fontSize: 17),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
        backgroundColor: MaterialStateProperty.all(StaticResources.darkPuple),
      ),
    );
  }

  Future onSet() async {
    bool areFilled = validateFields();
    if (areFilled) {
      ProductModel productModel = await _collectProductInfo();
      arguments.pageEvent == PageEvent.Create
          ? saveProduct(productModel)
          : updateProduct(productModel);
    } else {
      Alerts().showGenericAlert(
        context: context,
        tilte: AppLocalizations.of(context)!.unfilledFields,
        description: AppLocalizations.of(context)!.requiredFields,
        actionOne: ActionModel(
          onPressed: () => Navigator.pop(context),
          title: AppLocalizations.of(context)!.accept,
          filled: false,
        ),
      );
    }
  }

  Future saveProduct(ProductModel productModel) async {
    ProductModel? produtcFound =
        await DBHive().getProductByKey(productModel.barCode);
    bool existsProduct = produtcFound != null;
    if (existsProduct) {
      bool overwrite = await areYouSureOverwriteProduct();
      if (overwrite) {
        productsInventory.updateProductBase(productModel, productModel);
        DBHive().insertProduct(productModel);
        Navigator.pop(context);
      }
    } else {
      productsInventory.addToProductsBase(productModel);
      DBHive().insertProduct(productModel);
      Navigator.pop(context);
    }
  }

  Future updateProduct(ProductModel productModel) async {
    if (await areYouSureUpdate()) {
      if (productModel.barCode == arguments.productModel!.barCode) {
        productsInventory.updateProductBase(
          productModel,
          productModel,
        );
      } else {
        productsInventory.updateProductBase(
          arguments.productModel!,
          productModel,
        );
        DBHive().deleteProduct(arguments.productModel!.barCode);
      }

      DBHive().insertProduct(productModel);
      productsInventory.clearSelectedProducts();
      Navigator.pop(context);
    }
  }

  Future<ProductModel> _collectProductInfo() async {
    ProductModel productModel = ProductModel(
      dateTime: DateTime.now(),
      name: this.nameController.text,
      barCode: this.codeController.text,
      price: (this.priceController.text).replaceAll(".", ""),
    );
    if (this.file != null) {
      productModel.path = await Utils().saveFile(
        file: file!,
        fileName: "${DateTime.now().microsecondsSinceEpoch}.png",
      );
    }
    return productModel;
  }

  bool validateFields() {
    return nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        codeController.text.isNotEmpty;
  }

  bool anyFieldFilled() {
    return nameController.text.isNotEmpty ||
        priceController.text.isNotEmpty ||
        codeController.text.isNotEmpty ||
        file != null;
  }

  Future<bool> areYouSureCloseAlert() async {
    bool close = false;
    await Alerts().showGenericAlert(
      isDismissible: false,
      context: context,
      tilte: AppLocalizations.of(context)!.comeBack,
      description:
          "${AppLocalizations.of(context)!.areYouSureComeback}\n${AppLocalizations.of(context)!.changesWillBeLost}",
      actionOne: ActionModel(
        onPressed: () {
          close = false;
          Navigator.pop(context);
        },
        title: AppLocalizations.of(context)!.cancel,
        filled: false,
      ),
      actionTwo: ActionModel(
        onPressed: () {
          close = true;
          Navigator.pop(context);
        },
        title: AppLocalizations.of(context)!.accept,
        filled: true,
      ),
    );
    return close;
  }

  Future<bool> areYouSureOverwriteProduct() async {
    bool save = false;
    await Alerts().showGenericAlert(
      context: context,
      tilte: AppLocalizations.of(context)!.save,
      description:
          "${AppLocalizations.of(context)!.alreadyBarCodeSaved}\n\n${AppLocalizations.of(context)!.doYouWantOverwrite}",
      actionOne: ActionModel(
        onPressed: () {
          save = false;
          Navigator.pop(context);
        },
        filled: false,
        title: AppLocalizations.of(context)!.cancel,
      ),
      actionTwo: ActionModel(
        onPressed: () => save = true,
        filled: true,
        title: AppLocalizations.of(context)!.accept,
      ),
    );
    return save;
  }

  Future<bool> areYouSureUpdate() async {
    bool save = false;
    await Alerts().showGenericAlert(
      context: context,
      tilte: AppLocalizations.of(context)!.update.toUpperCase(),
      description: AppLocalizations.of(context)!.areYouSureUpdateProduct,
      actionOne: ActionModel(
        onPressed: () {
          save = false;
          Navigator.pop(context);
        },
        filled: false,
        title: AppLocalizations.of(context)!.cancel,
      ),
      actionTwo: ActionModel(
        onPressed: () {
          save = true;
          Navigator.pop(context);
        },
        filled: true,
        title: AppLocalizations.of(context)!.accept,
      ),
    );
    return save;
  }

  Future<bool> onBack() async {
    if (anyFieldFilled()) {
      bool close = await areYouSureCloseAlert();
      if (arguments.pageEvent == PageEvent.Update) {
        productsInventory.clearSelectedProducts();
      }
      return close;
    } else {
      return true;
    }
  }
}

enum PageEvent { Create, Update }

class SetProductArguments {
  PageEvent pageEvent;
  ProductModel? productModel;

  SetProductArguments({
    required this.pageEvent,
    this.productModel,
  }) {
    if (PageEvent.Update == pageEvent) {
      assert(productModel != null);
    }
  }
}
