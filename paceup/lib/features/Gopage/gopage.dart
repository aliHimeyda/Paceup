import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paceup/core/utils/drawtrackpng.dart';
import 'package:paceup/core/utils/getcurrentposition.dart';
import 'package:paceup/data/datasources/remote_datasource/firebaseservices.dart';
import 'package:paceup/data/models/dailyGoal.dart';
import 'package:paceup/routing/paths.dart';
import 'package:paceup/widgets/loader.dart';
import 'package:paceup/features/Gopage/goprovider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class GoPage extends StatelessWidget {
  final Dailygoal currentgoal;
  const GoPage({super.key, required this.currentgoal});

  @override
  Widget build(BuildContext context) {
    final positionprovider = context.read<GoProvider>();
    final valuesprovider = context.read<GoValuesprovider>();
    final loaderProvider = context.watch<Loader>();
    return Consumer<GoValuesprovider>(
      child: _GoMap(),
      builder: (context, v, mapChild) {
        v.setelapsed = currentgoal.totaltime;
        return Scaffold(
          body: Stack(
            children: [
              mapChild!,

              Positioned(
                top: 16 + MediaQuery.of(context).padding.top,
                left: 16,
                child: _CircleButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
              DraggableScrollableSheet(
                    initialChildSize:
                        0.55,
                    minChildSize: 0.40, 
                    maxChildSize: 0.55, 
                    snap: true,
                    snapSizes: const [
                      0.40,
                      0.55,
                    ], 
                    builder: (context, controller) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
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
                        child: SingleChildScrollView(
                          controller:
                              controller, 
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Divider(
                                  thickness: 7,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                              // ↓↓↓ Senin mevcut içeriğin ( _StatsGrid, butonlar, Finish vb.) ↓↓↓
                              _StatsGrid(
                                runningTime: v.elapsedText,
                                avgPace:
                                    '${v.avgPaceMinsPerKm(v.elapsed.inSeconds, currentgoal.calory).toStringAsFixed(2)} mins',
                                distance:
                                    '${currentgoal.endingkm.toStringAsFixed(0)} km',
                                calories: '${currentgoal.calory} kcal',
                              ),
                              const SizedBox(height: 20),
                               Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width /
                                              2 -
                                          20,
                                      height: 52,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          debugPrint('girdi');
                                          if (valuesprovider.isRunning) {
                                            debugPrint(
                                              'ilk kosula girdi girdi',
                                            );

                                            valuesprovider.stop();
                                            positionprovider.stopsub();
                                          } else {
                                            debugPrint('ikinci kosula girdi');

                                            valuesprovider.start();
                                            positionprovider.startListening();
                                          }
                                        },
                                        icon: Icon(
                                          v.isRunning
                                              ? Icons.stop
                                              : Icons.play_arrow,
                                          color: Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                        ),
                                        label: Text(
                                          v.isRunning ? 'Stop' : 'Continue',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width /
                                              2 -
                                          20,
                                      height: 52,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                        ),
                                        onPressed: () async {
                                          Provider.of<Loader>(
                                            context,
                                            listen: false,
                                          ).loading = true;
                                          Provider.of<Loader>(
                                            context,
                                            listen: false,
                                          ).change();

                                          //llllllllllllllll
                                          Provider.of<Loader>(
                                            context,
                                            listen: false,
                                          ).loading = false;
                                          Provider.of<Loader>(
                                            context,
                                            listen: false,
                                          ).change();
                                        },
                                        child: Text(
                                          'save progress',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 12),
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 30,
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
                                    onPressed: () async {
                                      Provider.of<Loader>(
                                        context,
                                        listen: false,
                                      ).loading = true;
                                      Provider.of<Loader>(
                                        context,
                                        listen: false,
                                      ).change();
                                      final png = await drawTrackPng(
                                        context
                                            .read<GoProvider>()
                                            .latlonPositionsList,
                                        size: const Size(500, 500),
                                        padding: 20,
                                        strokeColor: Colors.white,
                                        strokeWidth: 6,
                                        backgroundColor: Theme.of(
                                          context,
                                        ).primaryColor, // veya Colors.transparent
                                      );
                                      final result = await uploadToFirebase(
                                        png!,
                                        "myImage123.jpg",
                                      );
                                      print(result);
                                      valuesprovider.finish();
                                      positionprovider.finish();
                                      Provider.of<Loader>(
                                        context,
                                        listen: false,
                                      ).loading = false;
                                      Provider.of<Loader>(
                                        context,
                                        listen: false,
                                      ).change();
                                      final sizeInKb = png.lengthInBytes / 1024;
                                      final sizeInMb =
                                          png.lengthInBytes / (1024 * 1024);
                                      print(
                                        "Boyut: ${sizeInKb.toStringAsFixed(2)} KB",
                                      );
                                      print(
                                        "Boyut: ${sizeInMb.toStringAsFixed(2)} MB",
                                      );

                                      context.pop();
                                      context.push(
                                        Paths.progressresultpage,
                                        extra: png,
                                      );
                                    },
                                    child: Text(
                                      'Finish',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
              loaderProvider.loading
                  ? Provider.of<Loader>(context, listen: false).loader(context)
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

// Google Map widget (zoom=5)
class _GoMap extends StatefulWidget {
  const _GoMap();

  @override
  State<_GoMap> createState() => _GoMapState();
}

class _GoMapState extends State<_GoMap> {
  late Future<Position> getposition;

  @override
  void initState() {
    super.initState();
    getposition = determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoProvider>(context, listen: false);
    return SizedBox(
      height: (MediaQuery.of(context).size.height / 3) * 2,
      child: FutureBuilder<Position>(
        future: getposition,
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
            return Center(child: Text('Please start your gps service'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('please try again for next time'));
          }
          final Position pos = snapshot.data;
          provider.latlonPositionsList.add(LatLng(pos.latitude, pos.longitude));

          return Consumer<GoProvider>(
            builder: (context, v, child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(pos.latitude, pos.longitude), // İstanbul örnek
                  zoom: 17,
                ),
                polylines: v.polylines,
                markers: v.markers,
                mapType: MapType.terrain,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                buildingsEnabled: true,
              );
            },
          );
        },
      ),
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
