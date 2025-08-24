import 'package:paceup/data/models/monthlystat.dart';

class Yearlystats {
  final int year;
  final List<Monthlystat> monthlystats;
  const Yearlystats({required this.year, required this.monthlystats});
}
