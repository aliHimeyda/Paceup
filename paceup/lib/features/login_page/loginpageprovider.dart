import 'package:flutter/material.dart';

class Loginpageprovider with ChangeNotifier {
  late TextEditingController sifreController = TextEditingController();
  late bool isLogin = true;
   bool _sifreGizli = true;

  bool get sifreGizli => _sifreGizli;

  void sifreyiGosterGizle() {
    _sifreGizli = !_sifreGizli;
    notifyListeners();
  }

  void savechanges() {
    notifyListeners();
  }
   void disposeControllers() {
    sifreController.text='';
  }
}
