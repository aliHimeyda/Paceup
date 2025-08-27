import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/data/models/dailyGoal.dart';
import 'package:paceup/routing/paths.dart';

Widget weeklyTCard(BuildContext context, Dailygoal goal) {
  final totalTime = formatHmsFromSeconds(goal.totaltime);
  final dayNames = [
    'Monday',
    'Tuesday',
    'Wedensday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final currentday = dayNames[goal.time.weekday - 1];
  return Container(
    height: 173,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).secondaryHeaderColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 56,
          child: Row(
            spacing: 6,
            children: [
              GestureDetector(
                onTap: () {
                  context.push(Paths.gopage, extra: goal);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.5, 1.0],
                      colors: [
                        Color.fromARGB(255, 79, 157, 110), // 0%
                        Color.fromARGB(255, 102, 207, 144), // 50%
                        Color.fromARGB(255, 79, 157, 110), // 100%
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12), // varsa
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 25,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    "${currentday} Target",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${goal.endingkm} km / ",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "${goal.totalkm}. km",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: goal.progress(),
                    color: Colors.white,
                    backgroundColor: Colors.white30,
                    strokeWidth: 4,
                  ),
                  Text(
                    '${(goal.progress() * 100).toInt()}%',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 3,
                    children: [
                      Image.asset(
                        width: 16,
                        height: 16,
                        'assets/icons/Clock.png',
                      ),
                      Text(
                        "Total Time",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  Text(
                    totalTime,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 3,
                    children: [
                      Image.asset(
                        width: 16,
                        height: 16,
                        'assets/icons/Shoes.png',
                      ),
                      Text(
                        "Distance",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  Text(
                    "${goal.endingkm} km",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 3,
                    children: [
                      Image.asset(
                        width: 16,
                        height: 16,
                        'assets/icons/Fire.png',
                      ),
                      Text(
                        "Calories",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  Text(
                    "${goal.calory} kcal",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

String formatHmsFromSeconds(
  int totalSeconds, {
  bool pad = true,
  bool omitZeroHours = false,
}) {
  final h = totalSeconds ~/ 3600;
  final m = (totalSeconds % 3600) ~/ 60;
  final s = totalSeconds % 60;

  final mm = pad ? m.toString().padLeft(2, '0') : '$m';
  final ss = pad ? s.toString().padLeft(2, '0') : '$s';

  if (omitZeroHours && h == 0) {
    // Örn: 75s -> "01m:15s"
    return '${mm}m:${ss}s';
  }
  // Örn: 3671s -> "1h:01m:11s"
  return '${h}h:${mm}m:${ss}s';
}
