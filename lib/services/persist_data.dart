import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setTheme(bool isDarkMode) async {
    await prefs.setBool('theme', isDarkMode);
  }

  static Future<void> setFont(String font) async {
    await prefs.setString('font', font);
  }

  static Future<void> setAuto(bool isAutoCorrect) async {
    await prefs.setBool('auto', isAutoCorrect);
  }

  static Future<void> setSort(String sort) async {
    await prefs.setString('sort', sort);
  }

  static Future<void> setIndex(int index) async {
    await prefs.setInt('index', index);
  }

  static bool? getTheme() => prefs.getBool('theme');

  static String? getFont() => prefs.getString('font');

  static bool? getAuto() => prefs.getBool('auto');

  static String? getSort() => prefs.getString('sort');

  static int? getIndex() => prefs.getInt('index');
}
