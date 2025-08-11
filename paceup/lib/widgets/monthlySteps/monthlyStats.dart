import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paceup/features/home_page/homepageprovider.dart';
import 'package:paceup/widgets/monthlySteps/monthlyStepsprovider.dart';
import 'package:provider/provider.dart';

class Monthlystats extends StatelessWidget {
  const Monthlystats({super.key});

  @override
  Widget build(BuildContext context) {
    final watchprovider = context.watch<Monthlystepsprovider>();
    final provider = Provider.of<Monthlystepsprovider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Color.fromARGB(255, 249, 249, 249)),
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
    );
  }
}
