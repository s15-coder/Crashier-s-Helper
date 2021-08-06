import 'package:flutter/material.dart';
import 'package:market_scanner/models/product_model.dart';

class ProductsCashRegister extends ChangeNotifier {
  List<ProductModel> _selectedProducts = [];
  List<ProductModel> _productsBase = [];
  ProductsCashRegister();

  List<ProductModel> get selectedProducts {
    return this._selectedProducts;
  }

  void clearSelectedProducts() {
    this._selectedProducts.clear();
    notifyListeners();
  }

  void addToSelectedProducts(ProductModel productModel) {
    _selectedProducts.add(productModel);
    notifyListeners();
  }

  void removeSelectedAndBaseProducts() {
    this._selectedProducts.forEach((product) {
      this._productsBase.remove(product);
    });
    this._selectedProducts.clear();

    notifyListeners();
  }

  void removeFromSelectedProducts(ProductModel productModel) {
    this._selectedProducts.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get productsBase {
    return this._productsBase;
  }

  void addToProductsBase(ProductModel productModel) {
    this._productsBase.add(productModel);
    notifyListeners();
  }

  void removeFromProductsBase(ProductModel productModel) {
    this._productsBase.remove(productModel);
    notifyListeners();
  }

  void clearProductsBase() {
    this._productsBase.clear();
    notifyListeners();
  }

  void updateProductBase(
    ProductModel oldProduct,
    ProductModel newProduct,
  ) {
    int index = this._productsBase.indexOf(oldProduct);
    this._productsBase[index] = newProduct;
    notifyListeners();
  }
}
