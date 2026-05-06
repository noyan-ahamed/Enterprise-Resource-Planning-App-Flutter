// here we save login and token
import 'dart:convert';

import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/auth_response_model.dart';
import 'package:enterprise_resource_planning/data/models/login_request_model.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static const String baseUrl =
      "http://10.0.2.2:8080/authentication";

  Future<AuthResponseModel> login(
      LoginRequestModel request
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/authenticate"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final authResponse =
      AuthResponseModel.fromJson(data);

      /// SAVE TOKEN
      await TokenService.saveToken(authResponse.token);

      /// SAVE ROLE
      await TokenService.saveRoles(authResponse.roles);

      return authResponse;

    } else {
      throw Exception("Invalid username or password");
    }
  }
}