import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String tokenKey = "jwt_token";
  static const String roleKey = "user_roles";

  /// SAVE TOKEN
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(tokenKey, token);
  }

  /// GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(tokenKey);
  }

  /// SAVE ROLES
  static Future<void> saveRoles(List<String> roles) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(roleKey, roles);
  }

  /// GET ROLES
  static Future<List<String>> getRoles() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(roleKey) ?? [];
  }

  /// CLEAR
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  /// CHECK LOGIN
  static Future<bool> isLoggedIn() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    /// CHECK EXPIRED
    bool isExpired = JwtDecoder.isExpired(token);

    if (isExpired) {
      await clearAll();

      return false;
    }

    return true;
  }
}