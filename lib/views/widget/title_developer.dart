import 'package:flutter/material.dart';

class DeveloperTitle extends StatelessWidget {
  const DeveloperTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code),
          Container(
            child: Text(
              'DEVELOPER CONTACT',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
          Icon(Icons.code),
        ],
      ),
    );
  }
}
