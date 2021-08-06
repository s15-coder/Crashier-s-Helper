import 'package:flutter/material.dart';
import 'package:market_scanner/views/pages/cash_register_page.dart';
import 'package:market_scanner/views/pages/inventory_page.dart';
import 'package:market_scanner/views/widget/bottom_navigator_custom.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static final routeName = "home_page";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: [CashRegisterPage(), InventoryPage()],
        ),
        bottomNavigationBar:
            BottomNavigatorCustom(pageController: this._pageController),
      ),
    );
  }
}
