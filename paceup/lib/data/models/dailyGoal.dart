class Dailygoal {
  double endingkm;
  double totalkm;
  double calory;
  DateTime time;
  DateTime totaltime;
  Dailygoal({
    required this.endingkm,
    required this.totalkm,
    required this.time,
    required this.totaltime,
    required this.calory,
  });
  double progress() {
    if (endingkm <= 0) return 0; // 0’a bölmeyi önle
    final p = endingkm / totalkm; // tamamlanan oran
    return p;
  }
}
