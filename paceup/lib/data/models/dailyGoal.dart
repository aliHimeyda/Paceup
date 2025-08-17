class Dailygoal {
  double endingkm;
  double remainderkm;
  double kalory;
  DateTime time;
  Dailygoal({
    required this.endingkm,
    required this.remainderkm,
    required this.time,
    required this.kalory,
  });
  double progress() {
    if (endingkm <= 0) return 0; // 0’a bölmeyi önle
    final p = endingkm / remainderkm; // tamamlanan oran
    return p;
  }
}
