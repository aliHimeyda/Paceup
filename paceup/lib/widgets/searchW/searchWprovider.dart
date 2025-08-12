import 'package:flutter/foundation.dart';

class Searchwprovider with ChangeNotifier {
  late bool isactive = false;
  void change() {
    notifyListeners();
  }
}
