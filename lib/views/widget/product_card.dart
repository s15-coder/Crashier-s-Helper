import 'dart:io';

import 'package:flutter/material.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/resources/utils.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.size,
    required this.traveling,
    required this.productName,
    required this.price,
    required this.barCode,
    this.pathImage,
    this.selected = false,
  }) : super(key: key);
  final Size size;
  final String productName;
  final Widget traveling;
  final String price;
  final String barCode;
  final String? pathImage;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: this.selected,
      selectedTileColor: StaticResources.lightPurple,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              productName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            traveling
          ],
        ),
      ),
      subtitle: Text(
        Utils().moneyFormat(price),
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      leading: Container(
        width: size.height * 0.07,
        height: size.height * 0.07,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(
              color: StaticResources.darkPuple,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(40)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: size.height * 0.07,
            height: size.height * 0.07,
            child: this.pathImage != null
                ? Image.file(
                    File(pathImage!),
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
}
