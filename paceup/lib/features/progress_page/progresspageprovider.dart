import 'package:flutter/widgets.dart';

class Progresspageprovider with ChangeNotifier {
  final now = DateTime.now();
  double get progress => 2.25 / 3; // 2h15m = 2.25 hours out of 3
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
