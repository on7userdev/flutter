import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beacon_bloom/models/user.dart';

class UserStorageService {
  static const String _userKey = 'current_user';

  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) {
      final defaultUser = _getDefaultUser();
      await saveUser(defaultUser);
      return defaultUser;
    }
    try {
      return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (e) {
      final defaultUser = _getDefaultUser();
      await saveUser(defaultUser);
      return defaultUser;
    }
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  User _getDefaultUser() => User(
    id: 'user_1',
    name: 'Alex Morgan',
    email: 'alex.morgan@example.com',
    avatarUrl: 'https://ui-avatars.com/api/?name=Alex+Morgan&background=FF6B6B&color=fff',
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    updatedAt: DateTime.now(),
  );
}
