import 'package:shared_preferences/shared_preferences.dart';

class MyStorageImpl {
  static Future<String> getToken() async {
    var pres = await SharedPreferences.getInstance();
    return pres.getString("token") ?? "";
  }

  static removeToken() async {
    var pres = await SharedPreferences.getInstance();
    await pres.remove('token');
  }

  static setToken(String token) async {
    var pres = await SharedPreferences.getInstance();
    pres.setString("token", token);
  }
}
