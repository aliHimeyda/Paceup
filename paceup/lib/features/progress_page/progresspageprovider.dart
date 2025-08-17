import 'package:flutter/widgets.dart';
import 'package:paceup/data/models/dailyGoal.dart';
import 'package:paceup/data/models/weeklygoals.dart';

class Progresspageprovider with ChangeNotifier {
  final now = DateTime.now();
  Dailygoal goal = Dailygoal(
    endingkm: 50,
    remainderkm: 70,
    time: DateTime.now(),
    kalory: 1000,
  );
  late List<Dailygoal?> dailygoals =[goal, null, goal, null, null, goal, null];
  late Weeklygoals goals = Weeklygoals(
    goals: dailygoals,
  );
  // 2h15m = 2.25 hours out of 3
  late int selectedDayIndex = now.weekday % 7;

  void selectDay(int index) {
    selectedDayIndex = index;
    notifyListeners();
  }

  late List<Map<String, dynamic>> events = [
    {
      "image": "assets/images/1.png",
      "title": "Moonlight Marathon Madness",
      "location": "Ersel Street",
    },
    {
      "image": "assets/images/1.png",
      "title": "Moonlight Marathon Madness",
      "location": "Ersel Street",
    },
    {
      "image": "assets/images/1.png",
      "title": "Moonlight Marathon Madness",
      "location": "Ersel Street",
    },
    {
      "image": "assets/images/1.png",
      "title": "Moonlight Marathon Madness",
      "location": "Ersel Street",
    },
  ];
}
