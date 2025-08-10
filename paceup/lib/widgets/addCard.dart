  import 'package:flutter/material.dart';

Widget addCard(
    IconData icon,
    String? image,
    String title,
    BuildContext context,
  ) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
         image: image != null
      ? DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        )
      : null,
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
      
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white,size: 25,),
            ),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }