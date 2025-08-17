// - padding: kenar boşluğu (px)
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Track'i (LatLng listesi) düz bir resme çizer ve PNG baytlarını döner.
/// - size: çıktı görsel boyutu
/// - padding: kenar boşluğu (px)
/// - strokeColor / strokeWidth: çizgi stili
/// - backgroundColor: arka plan (transparent da olabilir)
///
///
Future<Uint8List?> drawTrackPng(
  List<LatLng> track, {
  Size size = const Size(500, 500),
  double padding = 20,
  Color strokeColor = const Color(0xFFFC7049),
  double strokeWidth = 6,
  Color backgroundColor = Colors.transparent,
  bool drawEndpoints = true,
}) async {
  if (track.length < 2) return null;

  // 1) Lat/Lon -> yerel metrik (x,y) (ENU/equirectangular approx.)
  const R = 6371000.0; // Dünya yarıçapı (m)
  final lat0 = track.first.latitude * math.pi / 180.0;
  final lon0 = track.first.longitude * math.pi / 180.0;
  final cosLat0 = math.cos(lat0);

  final xs = <double>[];
  final ys = <double>[];
  for (final p in track) {
    final lat = p.latitude * math.pi / 180.0;
    final lon = p.longitude * math.pi / 180.0;
    final x = R * cosLat0 * (lon - lon0); // Doğu (+)
    final y = R * (lat - lat0); // Kuzey (+)
    xs.add(x);
    ys.add(y);
  }

  // 2) BBox + uniform ölçek + offset
  double xMin = xs.reduce(math.min), xMax = xs.reduce(math.max);
  double yMin = ys.reduce(math.min), yMax = ys.reduce(math.max);
  double wM = (xMax - xMin).abs();
  double hM = (yMax - yMin).abs();

  final innerW = (size.width - 2 * padding).clamp(1.0, double.infinity);
  final innerH = (size.height - 2 * padding).clamp(1.0, double.infinity);

  double sx = wM > 0 ? innerW / wM : double.infinity;
  double sy = hM > 0 ? innerH / hM : double.infinity;
  double scale;
  if (sx.isFinite && sy.isFinite) {
    scale = math.min(sx, sy);
  } else if (sx.isFinite) {
    scale = sx;
  } else if (sy.isFinite) {
    scale = sy;
  } else {
    scale = 1.0; // tüm noktalar aynıysa
  }

  // 3) Çizim hazırlığı
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Offset.zero & size);

  // Arka plan
  if (backgroundColor != Colors.transparent) {
    final bg = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bg);
  }

  // Path oluştur (kuzey yukarı kalsın diye Y'yi tersliyoruz)
  final path = Path();
  for (int i = 0; i < track.length; i++) {
    final X = padding + (xs[i] - xMin) * scale;
    final Y = padding + (yMax - ys[i]) * scale; // invert Y
    if (i == 0) {
      path.moveTo(X, Y);
    } else {
      path.lineTo(X, Y);
    }
  }

  final paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = strokeColor;

  canvas.drawPath(path, paint);

  // Başlangıç/Bitiş noktalarını vurgula (opsiyonel)
  if (drawEndpoints) {
    final startX = padding + (xs.first - xMin) * scale;
    final startY = padding + (yMax - ys.first) * scale;
    final endX = padding + (xs.last - xMin) * scale;
    final endY = padding + (yMax - ys.last) * scale;

    final pinFill = Paint()..color = strokeColor;
    final pinOutline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.9);

    canvas.drawCircle(Offset(startX, startY), strokeWidth * 0.9, pinFill);
    canvas.drawCircle(Offset(startX, startY), strokeWidth * 0.9, pinOutline);

    canvas.drawCircle(Offset(endX, endY), strokeWidth * 0.9, pinFill);
    canvas.drawCircle(Offset(endX, endY), strokeWidth * 0.9, pinOutline);
  }

  // 4) PNG'ye çevir
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.width.toInt(), size.height.toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return bytes?.buffer.asUint8List();
}
