import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:paceup/core/services/loader.dart';
import 'package:paceup/features/progress_page/progresspageprovider.dart';
import 'package:paceup/widgets/addCard.dart';
import 'package:paceup/widgets/eventCard.dart';
import 'package:paceup/widgets/monthlySteps/monthlyStats.dart';
import 'package:paceup/widgets/weeklyTCard.dart';
import 'package:provider/provider.dart';

class Progresspage extends StatefulWidget {
  const Progresspage({super.key});

  @override
  State<Progresspage> createState() => _ProgresspageState();
}

class _ProgresspageState extends State<Progresspage> {
  late Future<void> gettingdata;
  @override
  void initState() {
    super.initState();
    gettingdata = getdata();
  }

  Future<void> getdata() async {
    Future.delayed(Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    final watchprovider = context.watch<Progresspageprovider>();
    final provider = Provider.of<Progresspageprovider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final dayNumbers = List.generate(
      7,
      (i) => DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday % 7 - i))
          .day,
    );
    return Scaffold(
      body: FutureBuilder(
        future: gettingdata,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Provider.of<Loader>(
                context,
                listen: false,
              ).loader(context),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  "Daily Goals",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final isToday = index == watchprovider.selectedDayIndex;
                      return SizedBox(
                        height: 75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              dayNames[index],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.selectDay(index);
                              },
                              child: Container(
                                width: width / 9,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  dayNumbers[index].toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                watchprovider.selectedDayIndex != 3
                    ? weeklyTCard(context, 75, 59, 70, DateTime.now())
                          .animate()
                          .slideX(
                            begin: -0.4,
                            end: 0,
                            curve: Curves.easeOutCubic,
                            duration: 450.ms,
                          )
                          .fadeIn(duration: 300.ms)
                    : addCard(Icons.add, '', 'Add New Goal', context)
                          .animate()
                          .slideX(
                            begin: -0.4,
                            end: 0,
                            curve: Curves.easeOutCubic,
                            duration: 450.ms,
                          )
                          .fadeIn(duration: 300.ms),
                const SizedBox(height: 20),
                Text(
                  "Your Monthly Stats",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 15),
                Monthlystats(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Running Events",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.add),
                          Text(
                            'Add',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                provider.events.isEmpty
                    ? addCard(Icons.add, '', 'Add New Event', context)
                    : Column(
                        children: [
                          ...provider.events.map((e) {
                            return Column(
                              children: [
                                const SizedBox(height: 15),
                                Center(
                                  child: SizedBox(
                                    width: width - 50,
                                    child: eventCard(
                                      e['image'],
                                      e['title'],
                                      e['location'],
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
