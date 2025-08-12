import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paceup/features/Gopage/goprovider.dart';
import 'package:provider/provider.dart';

class GoPage extends StatefulWidget {
  const GoPage({super.key});

  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
  late final Alignment _randomAlign;

  @override
  void initState() {
    super.initState();
    final r = Random();
    // -0.8 .. 0.8 arası rastgele hizalama (ekranın kenarlarına çok yapışmasın)
    _randomAlign = Alignment(
      -0.8 + r.nextDouble() * 1.6,
      -0.6 + r.nextDouble() * 1.2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final go = context.watch<GoProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // GOOGLE MAP
          const _GoMap(),

          // Sol üst geri butonu (beyaz daire + ince border)
          Positioned(
            top: 16 + MediaQuery.of(context).padding.top,
            left: 16,
            child: _CircleButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),

          // ÜST SAĞ SHARE DAİRESİ ***YOK*** (istenmedi)

          // Rastgele mavi daire (map marker DEĞİL)
          Align(
            alignment: _randomAlign,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // "1 km more" siyah etiket
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '1 km more',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade600,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade300.withOpacity(.6),
                        blurRadius: 12,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ALT SAYFA (bottom sheet görünümü)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 0),
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
              width: 390,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(8, -8),
                    blurRadius: 24,
                    color: Color.fromRGBO(194, 194, 194, 0.15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Kart grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _StatsGrid(
                      runningTime: go.elapsedText,
                      avgPace: '${go.avgPaceMins.toStringAsFixed(0)} mins',
                      distance: '${go.distanceKm.toStringAsFixed(0)} km',
                      calories: '${go.calories} kcal',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Share butonu (altta)
                  TextButton.icon(
                    onPressed: () {
                      // TODO: paylaşım
                    },
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share'),
                  ),

                  const SizedBox(height: 8),

                  // Continue/Stop ve Finish
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0455BF), // Primary/500
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: go.toggle,
                            icon: Icon(go.isRunning ? Icons.stop : Icons.play_arrow),
                            label: Text(go.isRunning ? 'Stop' : 'Continue Running'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: BorderSide(color: const Color(0xFF0455BF).withOpacity(.6)),
                            ),
                            onPressed: () {
                              // Finish → timer durur, istersen resetle
                              go.stop();
                              // go.reset();
                            },
                            child: const Text('Finish'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Google Map widget (zoom=5)
class _GoMap extends StatelessWidget {
  const _GoMap();

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(41.015137, 28.979530), // İstanbul örnek
        zoom: 5,
      ),
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      buildingsEnabled: true,
    );
  }
}

// Küçük yuvarlak ikonlu buton (back vs.)
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: const Color.fromRGBO(142, 142, 144, 0.15)),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
      ),
    );
  }
}

// Alt bölümdeki 2x2 kartlar
class _StatsGrid extends StatelessWidget {
  final String runningTime;
  final String avgPace;
  final String distance;
  final String calories;

  const _StatsGrid({
    required this.runningTime,
    required this.avgPace,
    required this.distance,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    Widget card(String title, String value, {IconData? icon, Color? valueColor}) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.grey.shade700),
              const SizedBox(height: 6),
            ],
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: valueColor ?? Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.9,
      ),
      children: [
        card('Running Time', runningTime, icon: Icons.timer_outlined, valueColor: Colors.red),
        card('AVG Pace', avgPace, icon: Icons.bolt_outlined),
        card('Distance', distance, icon: Icons.directions_run),
        card('Calories', calories, icon: Icons.local_fire_department_outlined),
      ],
    );
  }
}
