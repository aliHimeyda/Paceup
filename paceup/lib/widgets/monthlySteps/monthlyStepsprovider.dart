import 'package:flutter/widgets.dart';

class Monthlystepsprovider with ChangeNotifier{

  final List<int> monthlySteps = [
    8000,
    5200,
    3900,
    8500,
    7400,
    10200,
    3600,
    8000,
    10000,
    12000,
    6000,
    10000,
  ];

  int selectedMonthIndex = 5;

  void selectMonth(int index) {
    selectedMonthIndex = index;
    notifyListeners();
  }
}