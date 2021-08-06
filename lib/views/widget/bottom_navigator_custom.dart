import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_scanner/providers/page_provider.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      items: getNavigatorOptions(context),
    );
  }
}

List<BottomNavigationBarItem> getNavigatorOptions(BuildContext context) {
  return [
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.cashRegister),
      label: AppLocalizations.of(context)!.cashRegister,
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.inventory),
        label: AppLocalizations.of(context)!.products),
  ];
}
