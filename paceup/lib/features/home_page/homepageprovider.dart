import 'package:flutter/material.dart';
import 'package:paceup/data/models/dailyGoal.dart';

class HomepageProvider with ChangeNotifier {
  final now = DateTime.now();
  Dailygoal goal = Dailygoal(endingkm: 50, remainderkm: 70, time: DateTime.now(),kalory: 1000 );
  
  
}
