import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Comingsoonpage extends StatelessWidget {
  const Comingsoonpage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final baseDelay = 200.ms;

    return Center(
      child: SizedBox(
        width: size.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Animate(
                  onPlay: (c) => c.repeat(reverse: true),
                  effects: [
                    ScaleEffect(
                      begin: const Offset(0.98, 0.98),
                      end: const Offset(1.02, 1.02),
                      duration: 2600.ms,
                      curve: Curves.easeInOut,
                    ),
                    BlurEffect(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(1.2, 1.2),
                      duration: 2600.ms,
                      curve: Curves.easeInOut,
                    ),
                  ],
                  child:
                      Image.asset(
                            'assets/images/comingsoonu.png',
                            height: size.height * 0.26,
                            fit: BoxFit.contain,
                          )
                          .animate()
                          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                          .move(
                            begin: const Offset(0, 20),
                            duration: 600.ms,
                            curve: Curves.easeOut,
                          ),
                ),
                Text(
                      'We Are Updated This App !',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    )
                    .animate(delay: baseDelay)
                    .fadeIn(duration: 400.ms)
                    .move(
                      begin: const Offset(0, 12),
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
                Text(
                      'Thank you for using this service, but the application is still under development...',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    )
                    .animate(delay: baseDelay * 2)
                    .fadeIn(duration: 400.ms)
                    .move(
                      begin: const Offset(0, 10),
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
                Text(
                      'We will provide this service as soon as possible.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    )
                    .animate(delay: baseDelay * 3)
                    .fadeIn(duration: 400.ms)
                    .move(
                      begin: const Offset(0, 8),
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    )
                    .shimmer(
                      delay: 1200.ms,
                      duration: 1800.ms,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.35),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
              ],
            ),
            SizedBox(
              height: 56,
              width: double.infinity,
              child:
                  ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Go Back'),
                      )
                      .animate(delay: baseDelay * 4)
                      .fadeIn(duration: 450.ms)
                      .move(
                        begin: const Offset(0, 14),
                        duration: 450.ms,
                        curve: Curves.easeOut,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.03, 1.03),
                        duration: 280.ms,
                        curve: Curves.easeOut,
                      )
                      .scale(
                        begin: const Offset(1.03, 1.03),
                        end: const Offset(1.0, 1.0),
                        duration: 280.ms,
                        curve: Curves.easeIn,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
