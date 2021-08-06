import 'package:flutter/material.dart';
import 'package:market_scanner/resources/static_r.dart';

class ButtomSheetItem extends StatelessWidget {
  const ButtomSheetItem({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.size,
    required this.icon,
  }) : super(key: key);
  final Size size;
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: size.width * 0.2,
      height: size.width * 0.2,
      decoration: BoxDecoration(
        color: StaticResources.darkPuple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Colors.white,
              )),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
