import 'package:flutter/material.dart';

Widget weeklyTCard(
  BuildContext context,
  double progress,
  double endingkm,
  double remainderkm,
  DateTime time,
) {
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
              Container(
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
                child: Image.asset('assets/icons/Target.png'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    "Weekly Target",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "$endingkm km / ",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "$remainderkm km",
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
                    value: progress,
                    color: Colors.white,
                    backgroundColor: Colors.white30,
                    strokeWidth: 4,
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
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
                    "${time.hour}h:${time.minute}m:${time.second}s",
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
                  Text("$endingkm km", style: Theme.of(context).textTheme.titleMedium),
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
                    "1,203 kcal",
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
