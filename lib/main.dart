import 'package:flutter/material.dart';
import 'package:market_scanner/providers/products_cash_register.dart';
import 'package:market_scanner/providers/products_inventory.dart';
import 'package:market_scanner/resources/hive_database.dart';
import 'package:market_scanner/views/pages/developer_page.dart';
import 'package:market_scanner/views/pages/home_page.dart';
import 'package:market_scanner/views/pages/set_product_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'providers/page_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHive().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsInventory(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsCashRegister(),
        ),
      ],
      child: MaterialApp(
        routes: {
          HomePage.routeName: (_) => HomePage(),
          SetProductPage.routeName: (_) => SetProductPage(),
          DeveloperPage.routeName: (_) => DeveloperPage()
        },
        title: 'Material App',
        initialRoute: HomePage.routeName,
        localizationsDelegates: [
          AppLocalizations.delegate, // Add this line

          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), // English, no country code
          Locale('es', ''), // Spanish, no country code
        ],
      ),
    );
  }
}
