import 'dart:convert';

import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://10.0.2.2:8080/user";

  static Future<UserModel?> getCurrentUser() async {
    try {
      final token = await TokenService.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/me"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return UserModel.fromJson(data);
      }

      return null;
    } catch (e) {
      print("Get Current User Error : $e");
      return null;
    }
  }
}