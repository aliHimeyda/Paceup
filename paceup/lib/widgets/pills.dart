import 'package:flutter/material.dart';

/// Ör: final widget = cityPicks(context, ["Kadıköy","Üsküdar",...]);
Widget cityPicks(BuildContext context, List<String> bolgeler) {
  final Color c = Theme.of(context).primaryColor;

  Widget pill(String text) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {}, // tıklama gerekmezse silebilirsin
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: c, width: 1.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(color: c, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  return SizedBox(
    width: 430, // CSS’teki genişlik
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
         Text(
          "City Picks",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 26), // CSS gap
        Center(
          child: Wrap(
            spacing: 16, // yatay boşluk
            runSpacing: 16, // dikey boşluk
            children: bolgeler.map(pill).toList(),
          ),
        ),
      ],
    ),
  );
}
