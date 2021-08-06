import 'package:flutter/material.dart';
import 'package:market_scanner/resources/static_r.dart';

class SocialContainer extends StatelessWidget {
  const SocialContainer({
    Key? key,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);
  final IconData iconData;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Icon(
            iconData,
            size: MediaQuery.of(context).size.width * 0.12,
            color: Colors.white,
          ),
          decoration: BoxDecoration(
              color: StaticResources.darkPuple,
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
