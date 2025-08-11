import 'package:flutter/material.dart';

Widget addCard(
  IconData icon,
  String? image,
  String title,
  BuildContext context,
) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: 150,
      height: 172,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Theme.of(context).primaryColor, // 0%
            Color(0xFFFAA74A), // 50%
            Theme.of(context).primaryColor, // 100%
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset(2, 5),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 2),
                ),
                child: Center(
                  child: Icon(
                    Icons.chevron_right,
                    size: 25,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
