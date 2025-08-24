import 'dart:convert'; // jsonEncode / jsonDecode için
import 'package:paceup/core/constants/localeDkeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

//for user data:======================
Future<void> saveUserDataLS(Map<String, dynamic> Userdata) async {
  final prefs = await SharedPreferences.getInstance();

  // Map → String (JSON)
  String jsonString = jsonEncode(Userdata);

  await prefs.setString(userdata, jsonString);
}

Future<Map<String, dynamic>?> getUserDataLS() async {
  final prefs = await SharedPreferences.getInstance();

  String? jsonString = prefs.getString(userdata);
  if (jsonString == null) return null;

  // String (JSON) → Map
  return jsonDecode(jsonString);
}

Future<void> updateUserDataLS(Map<String, dynamic> newData) async {
  final prefs = await SharedPreferences.getInstance();

  // read lost map
  String? jsonString = prefs.getString(userdata);
  Map<String, dynamic> current = {};
  if (jsonString != null) {
    current = jsonDecode(jsonString);
  }

  // combining old and new
  current.addAll(newData);

  // save changes
  await prefs.setString(userdata, jsonEncode(current));
}

Future<void> deleteUserDataLS() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(userdata);
}

//==================\
Future<List<Map<String, dynamic>>?> loadMapList() async {
  final prefs = await SharedPreferences.getInstance();

  String? jsonString = prefs.getString('myMapListKey');
  if (jsonString == null) return null;

  // String → List<dynamic>
  List<dynamic> decoded = jsonDecode(jsonString);

  // dynamic → Map<String, dynamic>
  return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
}
