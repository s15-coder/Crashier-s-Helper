import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_scanner/providers/page_provider.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:provider/provider.dart';

class BottomNavigatorCustom extends StatelessWidget {
  const BottomNavigatorCustom({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    return BottomNavigationBar(
      currentIndex: pageProvider.currentIndex,
      backgroundColor: StaticResources.darkPuple,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        pageProvider.currentIndex = index;
        pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      items: getNavigatorOptions(),
    );
  }
}

List<BottomNavigationBarItem> getNavigatorOptions() {
  return [
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.cashRegister),
      label: 'Cash Register',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.inventory),
      label: 'Inventory',
    ),
  ];
}
