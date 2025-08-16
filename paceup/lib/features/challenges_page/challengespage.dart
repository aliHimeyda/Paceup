import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paceup/features/challenges_page/challengespageprovider.dart';
import 'package:paceup/widgets/addCard.dart';
import 'package:paceup/widgets/eventCard.dart';
import 'package:paceup/widgets/fluttertoast.dart';
import 'package:paceup/widgets/loader.dart';
import 'package:paceup/widgets/nothingW.dart';
import 'package:paceup/widgets/pills.dart';
import 'package:paceup/widgets/searchW/searchW.dart';
import 'package:provider/provider.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  Future<void> searching() async {}
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Challengespageprovider>(
      context,
      listen: false,
    );
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(height: 5),
            SearchBarW(),
            SizedBox(height: 24),
            FutureBuilder<void>(
              future: searching(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Provider.of<Loader>(
                      context,
                      listen: false,
                    ).loader(context),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  fluttertoast(context, "Not found any result");
                  return Center(child: nothing(context));
                }
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(child: Text('sonuc var'));
                  },
                );
              },
            ),
            SizedBox(height: 14),

            Divider(color: Theme.of(context).primaryColor),
            SizedBox(height: 24),
            cityPicks(context, provider.anadoluIlceler),
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
