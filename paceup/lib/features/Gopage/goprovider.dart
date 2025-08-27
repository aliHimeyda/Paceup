import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoValuesprovider extends ChangeNotifier {
  // UI değerleri (örnek defaultlar)
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _running = false;

  bool get isRunning => _running;
  Duration get elapsed => _elapsed;
  set setelapsed(int v) => _elapsed = Duration(seconds: v);
  String get elapsedText {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void start() {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      notifyListeners();
    });
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    notifyListeners();
  }

  void reset() {
    stop();
    _elapsed = Duration.zero;
    notifyListeners();
  }

  Future<void> finish() async {
    reset();
    _elapsed = Duration.zero;
  }

  double avgPaceMinsPerKm(int totalSeconds, double endingKm) {
    if (endingKm <= 0) throw ArgumentError('endingKm > 0 olmalı');
    return (totalSeconds / 60.0) / endingKm;
  }
}

class GoProvider extends ChangeNotifier {
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  StreamSubscription<Position>? sub;

  List<LatLng> latlonPositionsList = [];
  LatLng? currentLatlng;

  void addEdge(LatLng a, LatLng b) {
    debugPrint(
      'a: $a  , b: $b  ==== yeni latlen boyutu : ${latlonPositionsList.length}',
    );
    final id = PolylineId(
      'route_${a.latitude}_${b.latitude}_${latlonPositionsList.length}',
    );
    final line = Polyline(
      polylineId: id,
      points: [a, b], // iki nokta arası kenar
      width: 5, // kalınlık
      color: const Color(0xFFFC7049), // renk
      geodesic: true, // Dünya eğriliğine uygun (büyük mesafede daha doğru)
      zIndex: 1,
    );
    polylines = {...polylines, line};
    markers = {
      Marker(
        markerId: const MarkerId('me'),
        position: b, // her event’te güncel konum
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        anchor: const Offset(0.6, 0.6),
      ),
    };
    notifyListeners();
  }

  Future<void> startListening() async {
    // Servis ve izin kontrolü (özet)
    if (!await Geolocator.isLocationServiceEnabled()) return;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied)
      perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever)
      return;

    // Platformdan bağımsız ayarlar
    const settings = LocationSettings(
      accuracy: LocationAccuracy.best, // hassasiyet (pil tüketimi artar)
      distanceFilter: 5, // en az 10 m hareket olursa event gönder
    );
    if (sub != null) return; // ikinci kez başlatma
    sub = Geolocator.getPositionStream(locationSettings: settings).listen((
      pos,
    ) {
      // HAREKET OLDU → yeni konum burada
      debugPrint(
        'hareket oldu , yeni position : $pos,yeni boyut ${latlonPositionsList.length} ===================================================en son value : ${latlonPositionsList}',
      );
      // pos.latitude, pos.longitude, pos.speed, pos.heading, pos.timestamp...
      final newlatlon = LatLng(pos.latitude, pos.longitude);

      addEdge(latlonPositionsList[latlonPositionsList.length - 1], newlatlon);
      latlonPositionsList.add(newlatlon);

      notifyListeners();
    });
  }

  Future<void> stopsub() async {
    await sub?.cancel();
    sub = null;
  }

  Future<void> finish() async {
    await sub?.cancel();
    sub = null;

    polylines = {};
    latlonPositionsList.clear();
  }
}
