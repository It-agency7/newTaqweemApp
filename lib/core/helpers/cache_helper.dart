import 'package:shared_preferences/shared_preferences.dart';

const String kToken = 'token';
const String lang = 'lang';

class TaqwimPref {
  final SharedPreferences _sharedPreferences;
  TaqwimPref(this._sharedPreferences);

  Future<bool> setLang(String languageCode) async {
    return await _sharedPreferences.setString(lang, languageCode);
  }

  String getLang() {
    return _sharedPreferences.getString(lang) ?? "ar";
  }

  //* SAVE TOKEN
  Future<bool> saveToken(String token) async {
    return _sharedPreferences.setString(kToken, token);
  }

  //* GET TOKEN
  String? getToken() {
    return _sharedPreferences.getString(kToken);
  }

  //* REMOVE TOKEN
  Future<bool> removeToken() async {
    return _sharedPreferences.remove(kToken);
  }
}
