import 'package:flutter/material.dart';

class BeautyDivider extends StatelessWidget {
  const BeautyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.008),
            width: size.width * 0.35,
            height: 1,
            color: Colors.grey,
          ),
          Container(
            height: size.width * 0.1,
            width: size.width * 0.1,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(40)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.008),
            width: size.width * 0.35,
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
