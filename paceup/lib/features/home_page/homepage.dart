import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/core/constants/global_values.dart';
import 'package:paceup/features/home_page/homepageprovider.dart';
import 'package:paceup/routing/paths.dart';
import 'package:paceup/widgets/addCard.dart';
import 'package:paceup/widgets/eventCard.dart';
import 'package:paceup/widgets/monthlySteps/monthlyStats.dart';
import 'package:paceup/widgets/weeklyTCard.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final watchprovider = context.watch<HomepageProvider>();
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
                      GestureDetector(
                        onTap: () {
                          context.push(Paths.notificationspage);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade200,
                          child: Image.asset(
                            width: 15,
                            height: 15,
                            'assets/icons/Notification.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).canvasColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(thickness: 2, color: Theme.of(context).canvasColor),
            const SizedBox(height: 10),
            Text("today's goal", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 15),
            // Weekly Target
            weeklyTCard(
              context,
              watchprovider.progress,
              59,
              60,
              watchprovider.now,
            ),
            const SizedBox(height: 24),

            // 3. Monthly Stats
            Text(
              "Your Monthly Stats",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15),
            Monthlystats(),

            const SizedBox(height: 20),

            // 4. Running Event
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pepole's Running Events",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: Theme.of(context).textTheme.bodySmall,
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
