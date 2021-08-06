import 'package:flutter/cupertino.dart';

class PageProvider extends ChangeNotifier {
  int _currentIndex = 0;
  set currentIndex(int currentIndex) {
    this._currentIndex = currentIndex;
    notifyListeners();
  }

  int get currentIndex => this._currentIndex;
}
