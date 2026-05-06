import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/presentation/screens/dashboard/AdminLayoutScreen.dart';
import 'package:enterprise_resource_planning/presentation/screens/login/login_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/supplier/supplier_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLogin() async {
    return await TokenService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.data == true) {
            return const AdminLayoutScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
