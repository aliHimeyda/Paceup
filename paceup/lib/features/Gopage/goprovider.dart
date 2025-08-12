import 'dart:async';
import 'package:flutter/material.dart';

class GoProvider extends ChangeNotifier {
  // UI değerleri (örnek defaultlar)
  Duration _elapsed = Duration.zero;
  double avgPaceMins = 65;   // dakikada ortalama pace
  double distanceKm  = 48;   // km
  int calories       = 621;  // kcal

  Timer? _timer;
  bool _running = false;

  bool get isRunning => _running;
  Duration get elapsed => _elapsed;

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

  void toggle() => _running ? stop() : start();

  void reset() {
    stop();
    _elapsed = Duration.zero;
    notifyListeners();
  }
}
