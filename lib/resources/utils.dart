import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_scanner/views/widget/buttom_sheet_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Utils {
  static final _singleton = Utils._();
  Utils._();
  factory Utils() => _singleton;
  Future<XFile?> openCamera() async {
    ImagePicker imagePicker = new ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.camera);
  }

  ///Saves a [file] and returns the path where is saved..
  Future<String> saveFile(
      {required XFile file, required String fileName}) async {
    String pathBase = (await getApplicationDocumentsDirectory()).path;
    File localFile = File("$pathBase/$fileName");
    File newFile = await localFile.writeAsBytes(await file.readAsBytes());
    return newFile.path;
  }

  Future<XFile?> openGallery() async {
    ImagePicker imagePicker = new ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<String> openScanBar(String cancelWord) async {
    return await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      cancelWord,
      true,
      ScanMode.BARCODE,
    );
  }

  Future launchTo(String path) async {
    await launch(path);
  }

  Future<XFile?> choosePhotoSourceAlert(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    XFile? file;
    await showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtomSheetItem(
                  label: AppLocalizations.of(context)!.camera,
                  onPressed: () async {
                    file = await this.openCamera();
                    Navigator.pop(context);
                  },
                  size: size,
                  icon: Icons.camera,
                ),
                ButtomSheetItem(
                  label: AppLocalizations.of(context)!.gallery,
                  onPressed: () async {
                    file = await this.openGallery();
                    Navigator.pop(context);
                  },
                  size: size,
                  icon: FontAwesomeIcons.image,
                ),
              ],
            ),
          );
        });
    return file;
  }

  String moneyFormat(String price) {
    var value = price;
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
    return value;
  }
}
