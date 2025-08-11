import 'package:flutter/material.dart';

class HomepageProvider with ChangeNotifier {
  final now = DateTime.now();
  double get progress => 2.25 / 3; // 2h15m = 2.25 hours out of 3
  
  
}
