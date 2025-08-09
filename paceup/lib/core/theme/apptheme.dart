import 'package:flutter/material.dart';
import 'package:paceup/core/constants/global_values.dart';
import 'package:paceup/core/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Savethemeinformation {
  late String modeinformation = 'light';
}

class AppTheme extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  ThemeData themeData = AppTheme.lightMode;
  late bool isdarkmode = false;
  late IconData temaiconu = Icons.light_mode;
  ThemeData get theme => themeData;
  AppTheme() {
    _loadTheme();
  }
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('thmemode') ?? 'system';

    switch (savedTheme) {
      case 'light':
        themeData = AppTheme.lightMode;
        isdarkmode = false;
        break;
      case 'dark':
        themeData = AppTheme.darkMode;
        isdarkmode = true;

        break;
      default:
        themeData = AppTheme.lightMode;
        isdarkmode = false;
    }

    notifyListeners();
  }

  void changetheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (themeData == AppTheme.lightMode) {
      themeData = AppTheme.darkMode;
      isdarkmode = true;
      temaiconu = Icons.dark_mode;
      await prefs.setString('thmemode', 'dark');
      notifyListeners();
    } else {
      themeData = AppTheme.lightMode;
      isdarkmode = false;
      temaiconu = Icons.light_mode;
      await prefs.setString('thmemode', 'light');
      notifyListeners();
    }
  }

  /// **Açık Tema (Light Mode)**
  static final ThemeData lightMode = ThemeData(
    popupMenuTheme: PopupMenuThemeData(
      color: MyColors.lightgray, // Arka plan rengi
    ),
    brightness: Brightness.light, // Tema parlaklığını açık mod olarak ayarlar
    primaryColor: MyColors.darkorange, // Uygulamanın ana rengini belirler
    secondaryHeaderColor: MyColors.green, // turuncumsu
    cardColor: MyColors.lightorange,
    canvasColor: MyColors.darkgray,
    scaffoldBackgroundColor:
        Colors.white, // Sayfanın arka plan rengini belirler

    iconTheme: IconThemeData(
      color: MyColors
          .darkgray, // Genel ikon rengini koyu gri yapar (örn: klasör ikonları)
      size: 17.23,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: MyColors
          .darkorange, // FAB (Floating Action Button) rengini kırmızı yapar
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: MyColors.darkorange),
      unselectedItemColor: MyColors.darkgray, // Seçili olmayan öğelerin rengi
      type: BottomNavigationBarType.fixed, // Tüm öğeleri eşit genişlikte göster
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontSize: 21.54,
        fontWeight: FontWeight.bold,
      ), // Genel metin stilini belirler (büyük)
      bodyMedium: TextStyle(
        color: MyColors.verydarkgray,
        fontSize: 12,
      ), // Genel metin stilini belirler (orta)
      titleLarge: TextStyle(
        color: Colors.white, // Başlık yazılarının rengini bordo yapar
        fontSize: 20, // Başlık yazılarının boyutunu belirler
        fontWeight: FontWeight.bold, // Başlık yazılarını kalın yapar
      ),
      titleMedium: TextStyle(
        color: MyColors.lightgray,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(color: MyColors.lightgray, fontSize: 12),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors
            .darkorange, // Yükseltilmiş butonların (ElevatedButton) arka plan rengini belirler
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ), // Buton köşelerini yuvarlatır
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        // Varsayılan kenarlık tipi
        borderRadius: BorderRadius.circular(radius), // Kenarları yuvarlat
        borderSide: const BorderSide(
          color: MyColors.lightorange,
        ), // Kenar rengi
      ),

      enabledBorder: OutlineInputBorder(
        // TextField aktif ama focus değilken
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: MyColors.lightorange), // Gri kenar
      ),

      focusedBorder: OutlineInputBorder(
        // TextField focus (tıklanmış) olduğunda
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: MyColors.lightorange,
          width: 2,
        ), // Kalın mavi kenar
      ),

      labelStyle: const TextStyle(
        color: MyColors.lightorange,
        fontSize: 13.54,
        fontWeight: FontWeight.bold,
      ), // Label (üstteki yazı) rengi
      hintStyle: const TextStyle(
        color: MyColors.lightorange,
        fontSize: 13.54,
        fontWeight: FontWeight.bold,
      ), // Hint (ipucu yazısı) rengi
      iconColor: MyColors.lightorange, // prefixIcon ya da suffixIcon rengi
    ),
  );

  /// **Koyu Tema (Dark Mode)**
  static final ThemeData darkMode = ThemeData(
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.black, // Arka plan rengi
    ),
    brightness: Brightness.dark, // Tema parlaklığını açık mod olarak ayarlar
    primaryColor: MyColors.darkorange, // Uygulamanın ana rengini belirler
    secondaryHeaderColor: MyColors.green, // turuncumsu
    cardColor: MyColors.lightorange,
    canvasColor: MyColors.darkgray,
    scaffoldBackgroundColor:
        Colors.black, // Sayfanın arka plan rengini belirler

    iconTheme: IconThemeData(
      color: MyColors
          .darkgray, // Genel ikon rengini koyu gri yapar (örn: klasör ikonları)
      size: 17.23,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: MyColors
          .darkorange, // FAB (Floating Action Button) rengini kırmızı yapar
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: MyColors.darkorange),
      unselectedItemColor: MyColors.darkgray, // Seçili olmayan öğelerin rengi
      type: BottomNavigationBarType.fixed, // Tüm öğeleri eşit genişlikte göster
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 21.54,
      ), // Genel metin stilini belirler (büyük)
      bodyMedium: TextStyle(
        color: MyColors.verydarkgray,
        fontSize: 12,
      ), // Genel metin stilini belirler (orta)
      titleLarge: TextStyle(
        color: Colors.white, // Başlık yazılarının rengini bordo yapar
        fontSize: 20, // Başlık yazılarının boyutunu belirler
        fontWeight: FontWeight.bold, // Başlık yazılarını kalın yapar
      ),
      titleMedium: TextStyle(
        color: MyColors.lightgray,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(color: MyColors.lightgray, fontSize: 12),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors
            .darkorange, // Yükseltilmiş butonların (ElevatedButton) arka plan rengini belirler
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ), // Buton köşelerini yuvarlatır
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        // Varsayılan kenarlık tipi
        borderRadius: BorderRadius.circular(radius), // Kenarları yuvarlat
        borderSide: const BorderSide(
          color: MyColors.lightorange,
        ), // Kenar rengi
      ),

      enabledBorder: OutlineInputBorder(
        // TextField aktif ama focus değilken
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: MyColors.lightorange), // Gri kenar
      ),

      focusedBorder: OutlineInputBorder(
        // TextField focus (tıklanmış) olduğunda
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: MyColors.lightorange,
          width: 2,
        ), // Kalın mavi kenar
      ),

      labelStyle: const TextStyle(
        color: MyColors.lightorange,
        fontSize: 13.54,
        fontWeight: FontWeight.bold,
      ), // Label (üstteki yazı) rengi
      hintStyle: const TextStyle(
        color: MyColors.lightorange,
        fontSize: 13.54,
        fontWeight: FontWeight.bold,
      ), // Hint (ipucu yazısı) rengi
      iconColor: MyColors.lightorange, // prefixIcon ya da suffixIcon rengi
    ),
  );
}
