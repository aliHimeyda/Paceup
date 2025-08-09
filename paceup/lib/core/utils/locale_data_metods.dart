import 'package:paceup/core/constants/global_values.dart';
import 'package:paceup/core/services/locale_datas_key_values.dart';
import 'package:shared_preferences/shared_preferences.dart';


void getIsLoggedinData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? isLoggedin = prefs.getBool(isUserLoggedIn);
  if (isLoggedin != null) {
    if (isLoggedin) {
      isloggedin = true;
    } 
  }
}
