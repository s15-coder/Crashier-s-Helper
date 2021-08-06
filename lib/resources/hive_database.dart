import 'package:hive/hive.dart';
import 'package:market_scanner/models/product_model.dart';
import 'package:path_provider/path_provider.dart';

class DBHive {
  static final _singleton = DBHive._();
  DBHive._();
  factory DBHive() => _singleton;
  late Box<ProductModel> productBox;
  init() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    Hive.init(path);
    Hive.registerAdapter(ProductModelAdapter());
    productBox = await Hive.openBox('product_box');
  }

  Future insertProduct(ProductModel productModel) async {
    productBox.put(productModel.barCode, productModel);
  }

  Future<ProductModel?> getProductByKey(String barCode) async {
    return productBox.get(barCode);
  }

  Future deleteProduct(String barCode) async {
    await productBox.delete(barCode);
  }

  Future<ProductModel?> getProduct(String barCode) async {
    return (await DBHive().getProductByKey(barCode));
  }

  List<ProductModel> getProducts() {
    return productBox.values.cast<ProductModel>().toList();
  }
}
