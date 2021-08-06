import 'package:hive/hive.dart';

///To get more info about [Hive](https://docs.hivedb.dev/#/).
///
///If u need regenerate HiveAdapters use the next command:
///```
///flutter packages pub run build_runner build
///```
part 'product_model.g.dart'; // Name of the TypeAdapter that we will generate in the future

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  String barCode;
  @HiveField(1)
  String name;
  @HiveField(2)
  int? amount;
  @HiveField(3)
  String? path;
  @HiveField(4)
  String price;
  @HiveField(6)
  DateTime dateTime;
  ProductModel(
      {this.amount,
      required this.name,
      required this.barCode,
      required this.dateTime,
      this.path,
      required this.price});
}
