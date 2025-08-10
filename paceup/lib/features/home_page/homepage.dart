import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paceup/core/constants/global_values.dart';
import 'package:paceup/features/home_page/homepageprovider.dart';
import 'package:paceup/widgets/addCard.dart';
import 'package:paceup/widgets/eventCard.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final watchprovider = context.watch<HomepageProvider>();
    final provider = Provider.of<HomepageProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final dayNumbers = List.generate(
      7,
      (i) => DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday % 7 - i))
          .day,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            // 1. Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 51,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Morning, George 👋",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Ready to beat your personal record?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 51,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        child: Image.asset(
                          width: 10,
                          height: 10,
                          'assets/icons/Notification.png',
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).canvasColor,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Weekday Row
            SizedBox(
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final isToday = index == watchprovider.currentDayIndex;
                  return SizedBox(
                    height: 75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          dayNames[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Container(
                          width: width / 9,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isToday
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            dayNumbers[index].toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Weekly Target
            Container(
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
                                  "59 km / ",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  "64 km",
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
                              value: watchprovider.progress,
                              color: Colors.white,
                              backgroundColor: Colors.white30,
                              strokeWidth: 4,
                            ),
                            Text(
                              '${(watchprovider.progress * 100).toInt()}%',
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
                              "2h:15m:8s",
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
                              "59 km",
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
            ),
            const SizedBox(height: 24),

            // 3. Monthly Stats
            Text(
              "Your Monthly Stats",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 249, 249, 249),
              ),
              height: 180,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 5,
                  children: List.generate(12, (i) {
                    final steps = provider.monthlySteps[i];
                    final isSelected = watchprovider.selectedMonthIndex == i;
                    final barHeight = (steps / 100);

                    return GestureDetector(
                      onTap: () {
                        provider.selectMonth(i);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${(steps / 1000).toStringAsFixed(1)}K",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          Container(
                            width: 43.02,
                            height: min(barHeight, 130),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(6),
                                right: Radius.circular(6),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            [
                              "Jan",
                              "Feb",
                              "Mar",
                              "Apr",
                              "May",
                              "Jun",
                              "Jul",
                              "Aug",
                              "Sep",
                              "Oct",
                              "Nov",
                              "Dec",
                            ][i],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Running Event
            Row(
              children: [
                Text(
                  "Pepole's Running Events",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  eventCard(
                    "assets/images/1.png",
                    "Moonlight Marathon Madness",
                    "Ersel Street",
                    context,
                  ),
                  eventCard(
                    "assets/images/2.png",
                    "Sunset Serenity Run",
                    "Annapolis Junction",
                    context,
                  ),
                  eventCard(
                    "assets/images/3.png",
                    "City Lights Sprint",
                    "Brooklyn Ave",
                    context,
                  ),
                  addCard(Icons.add, null, 'title', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
