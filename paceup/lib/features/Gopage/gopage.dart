import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paceup/widgets/loader.dart';
import 'package:paceup/features/Gopage/goprovider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class GoPage extends StatefulWidget {
  const GoPage({super.key});

  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final go = context.watch<GoProvider>();

    return Scaffold(
      body: FutureBuilder<Position>(
        future: determinePosition(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Provider.of<Loader>(
                context,
                listen: false,
              ).loader(context),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('konum bilgisi yok'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('hata olustu'));
          }
          final Position pos = snapshot.data;
          return Stack(
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
              // Rastgele mavi daire (map marker DEĞİL)
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // "1 km more" siyah etiket
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0D),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pos.latitude.toString(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              249,
                              169,
                              140,
                            ).withOpacity(.6),
                            blurRadius: 12,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _StatsGrid(
                              runningTime: go.elapsedText,
                              avgPace:
                                  '${go.avgPaceMins.toStringAsFixed(0)} mins',
                              distance:
                                  '${go.distanceKm.toStringAsFixed(0)} km',
                              calories: '${go.calories} kcal',
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: go.toggle,
                                    icon: Icon(
                                      go.isRunning
                                          ? Icons.stop
                                          : Icons.play_arrow,
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                    ),
                                    label: Text(
                                      go.isRunning
                                          ? 'Stop'
                                          : 'Continue Running',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
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
                                      side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      go.stop();
                                    },
                                    child: Text(
                                      'Finish',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate(delay: 120.ms)
                  .fadeIn(duration: 280.ms, curve: Curves.easeOut)
                  .move(
                    begin: const Offset(0, 120),
                    end: Offset.zero,
                    duration: 520.ms,
                    curve: Curves.easeOutBack,
                  )
                  .then()
                  .move(
                    begin: const Offset(0, -6),
                    end: Offset.zero,
                    duration: 180.ms,
                    curve: Curves.easeInOut,
                  ),
            ],
          );
        },
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
        zoom: 7,
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
            border: Border.all(
              color: const Color.fromRGBO(142, 142, 144, 0.15),
            ),
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
    Widget card(
      String title,
      String value, {
      IconData? icon,
      Color? valueColor,
    }) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 1,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: Colors.grey.shade700),
                  const SizedBox(height: 6),
                ],
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color:
                    valueColor ?? Theme.of(context).textTheme.bodyLarge!.color,
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
        card(
          'Running Time',
          runningTime,
          icon: Icons.timer_outlined,
          valueColor: Colors.red,
        ),
        card('AVG Pace', avgPace, icon: Icons.bolt_outlined),
        card('Distance', distance, icon: Icons.directions_run),
        card('Calories', calories, icon: Icons.local_fire_department_outlined),
      ],
    );
  }
}
