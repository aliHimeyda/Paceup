import 'package:flutter/material.dart';

Widget nothing(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/nothing.png',
          width: 50,
          height: 50,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            Text(
              'No Items In The Result',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "We can't found any result for your search input.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    ),
  );
}
