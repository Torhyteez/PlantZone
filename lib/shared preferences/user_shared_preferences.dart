import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class UserPrefs {
  static late SharedPreferences _prefs;

  static const String _kUserKey = 'user_data';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  // Hàm lưu thông tin người dùng
  static Future<void> saveUser(UserModel user) async {
    String userJsonString = jsonEncode(user.toJson());
    await _prefs.setString(_kUserKey, userJsonString);
  }

  // Hàm lấy thông tin người dùng
  static UserModel? getUser() {
    String? userJsonString = _prefs.getString(_kUserKey);

    if (userJsonString == null) return null;

    Map<String, dynamic> userMap = jsonDecode(userJsonString);
    return UserModel.fromJson(userMap);
  }

  // Hàm XÓA
  static Future<void> removeUser() async {
    await _prefs.remove(_kUserKey);
  }
}