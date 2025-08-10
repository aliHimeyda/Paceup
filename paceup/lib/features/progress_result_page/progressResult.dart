import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProgressResultPage extends StatelessWidget {
  const ProgressResultPage({
    super.key,
    this.imageUrl = 'assets/images/2.png',
    this.durationText = '00:59:21',
    this.subtitle = "Congrats on your streak!",
    this.distanceKm = 48,
    this.avgPaceMins = 65,
    this.calories = 621,
    this.onShare,
    this.onBack,
  });

  final String imageUrl;
  final String durationText;
  final String subtitle;
  final int distanceKm;
  final int avgPaceMins;
  final int calories;
  final VoidCallback? onShare;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // BACKGROUND IMAGE
            Positioned.fill(child: Image.asset(imageUrl, fit: BoxFit.cover)),

            // BOTTOM GRADIENT (CSS'e göre)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 517,
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0, -1), // yukarı
                      end: Alignment(0, 1), // aşağı
                      colors: [
                        Color.fromARGB(0, 255, 255, 255), // şeffaf
                        Colors.white, // beyaz
                      ],
                      stops: [-0.1161, 0.4978], // verilen değerlere yakın
                    ),
                  ),
                ),
              ),
            ),

            // TOP CONTENT
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ACHIEVEMENT CARD (mavi)
                    _AchievementCard(
                          durationText: durationText,
                          subtitle: subtitle,
                        )
                        .animate()
                        .slideX(
                          begin: -0.4,
                          end: 0,
                          curve: Curves.easeOutCubic,
                          duration: 450.ms,
                        )
                        .fadeIn(duration: 300.ms),
                    // boşluk – görsel alanı
                    SizedBox(height: size.height * 0.37),

                    // METRICS + BUTTONS BLOKU
                    _BottomInfoBlock(
                          distanceKm: distanceKm,
                          avgPaceMins: avgPaceMins,
                          calories: calories,
                          onShare: onShare,
                          onBack: onBack,
                        )
                        .animate()
                        .slideY(
                          begin: 0.30,
                          end: 0,
                          curve: Curves.easeOutCubic,
                          duration: 480.ms,
                        )
                        .fadeIn(duration: 300.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.durationText, required this.subtitle});

  final String durationText;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 115,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor, // Primary/500
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // simple decorative path (placeholder)
          Align(
            alignment: Alignment.centerRight,
            child: Opacity(
              opacity: 0.25,
              child: Icon(Icons.route, size: 56, color: Colors.white),
            ),
          ),
          // content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  durationText,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomInfoBlock extends StatelessWidget {
  const _BottomInfoBlock({
    required this.distanceKm,
    required this.avgPaceMins,
    required this.calories,
    this.onShare,
    this.onBack,
  });

  final int distanceKm;
  final int avgPaceMins;
  final int calories;
  final VoidCallback? onShare;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // WHITE INFO CARD
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Metric(
              icon: 'assets/icons/Shoes.png',
              title: 'Distance',
              value: '$distanceKm km',
            ),
            _Metric(
              icon: 'assets/icons/proVector.png',
              title: 'AVG Pace',
              value: '$avgPaceMins mins',
            ),
            _Metric(
              icon: 'assets/icons/Fire.png',
              title: 'Calories',
              value: '$calories kcal',
            ),
          ],
        ),
        const SizedBox(height: 32),

        // PRIMARY BUTTON
       Container(
          width: 358,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share_outlined,size: 24,color: Colors.white,),
                SizedBox(width: 8),
                Text(
                  'Share This Results',
                  style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),

        // OUTLINED BUTTON
        SizedBox(
          width: 358,
          height: 56,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              backgroundColor: Colors.white,
            ),
            onPressed: onBack,
            child:  Text(
              'Back to Home',
              style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.title, required this.value});

  final String icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                icon,
                width: 16,
                height: 16,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 6),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
