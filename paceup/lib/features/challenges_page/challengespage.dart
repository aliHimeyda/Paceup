import 'package:flutter/material.dart';
import 'package:paceup/widgets/addCard.dart';
import 'package:paceup/widgets/eventCard.dart';
import 'package:paceup/widgets/nothingW.dart';
import 'package:paceup/widgets/searchW/searchW.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(height: 5),
            SearchBarW(),
            SizedBox(height: 24),
            nothing(context),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Events",
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
