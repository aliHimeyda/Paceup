import 'package:flutter/material.dart';

class HomepageProvider with ChangeNotifier {
  final now = DateTime.now();

  int get currentDayIndex => now.weekday % 7; // Sunday=0
  double get progress => 2.25 / 3; // 2h15m = 2.25 hours out of 3
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
