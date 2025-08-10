import 'package:flutter/material.dart';

Widget eventCard(
  String image,
  String title,
  String location,
  BuildContext context,
) {
  return Container(
    width: 250,
    height: 172,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    
    child: Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x000A0A0A), // %0 opacity
          Color(0xFF0A0A0A), // %100 opacity
        ],
        stops: [0.0, 0.99],
      ),
    ),
        ),
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "New Event",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Image.asset(
                  width: 16,
                  height: 16,
                  'assets/icons/moreVector.png',
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 10,

          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                   Icon(Icons.location_on, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(location, style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
