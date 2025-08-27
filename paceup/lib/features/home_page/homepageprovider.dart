import 'package:flutter/material.dart';
import 'package:paceup/data/models/dailyGoal.dart';

class HomepageProvider with ChangeNotifier {
  final now = DateTime.now();
  Dailygoal goal = Dailygoal(
    endingkm: 50,
    totalkm: 70,
    time: DateTime.now(),
    calory: 1000,
    totaltime: 1000,
  );
}
