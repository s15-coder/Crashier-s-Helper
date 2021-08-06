import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/resources/utils.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.hintText,
      this.keyboardType,
      this.labelText,
      this.maxLength,
      this.format = Format.none,
      this.maxLines = 1,
      this.textCapitalization = TextCapitalization.none,
      this.prefixIcon})
      : super(key: key);
  final TextInputType? keyboardType;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final TextCapitalization textCapitalization;
  final Format format;
  final int? maxLength;
  final int maxLines;

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: this.maxLength,
      keyboardType: keyboardType,
      cursorColor: StaticResources.darkPuple,
      controller: controller,
      maxLines: maxLines,
      inputFormatters: [
        if (format == Format.justInteger)
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) return newValue;
            bool isInteger = int.tryParse(newValue.text) != null;
            if (!isInteger) {
              return oldValue;
            }
            return newValue;
          })
      ],
      onChanged: (String value) {
        if (format != Format.toPesos) return;
        switch (format) {
          case Format.toPesos:
            value = Utils().moneyFormat(value);
            controller.value = TextEditingValue(
                text: value,
                selection: TextSelection.collapsed(offset: value.length));
            break;
          default:
        }
      },
      textCapitalization: this.textCapitalization,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: StaticResources.darkPuple),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: StaticResources.darkPuple)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: StaticResources.darkPuple)),
      ),
    );
  }
}

enum Format { toPesos, justInteger, none } 

// TextStyle(color: StaticResources.darkPuple)