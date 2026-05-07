import 'package:enterprise_resource_planning/presentation/screens/category/product_category_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/dashboard_home.dart';
import 'package:enterprise_resource_planning/presentation/screens/department/department_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/designation/designation_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/supplier/supplier_screen.dart';
import 'package:enterprise_resource_planning/presentation/widgets/side_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLayoutScreen extends StatefulWidget {
  const AdminLayoutScreen({super.key});

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreen();
}

class _AdminLayoutScreen extends State<AdminLayoutScreen> {
  String selectedMenu = "dashboard";

  Widget getScreen() {
    switch (selectedMenu) {
      case "suppliers":
        return const SupplierScreen();
      case "category":
        return const ProductCategoryScreen();
      case "department":
        return const DepartmentScreen();

      case "designation":
        return const DesignationScreen();

      case "employee":
        // return const EmployeeScreen();
      default:
        return DashboardHome();
    }
  }

  String getTitle() {
    switch (selectedMenu) {
      case "suppliers":
        return "Suppliers";
      case "category":
        return "Product Categories";
      case "products":
        return "Products";
      case "department":
        return "Departments";
      case "designation":
        return "Designations";

      case "employee":
        return "Employees";
      default:
        return "Dashboard Overview";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
          title: Text(
            getTitle(),
            style: GoogleFonts.poppins(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
      IconButton(
      icon: const Icon(Icons.notifications_none_rounded,
          color: Color(0xFF64748B)),
      onPressed: () {},
    ),
    // const Padding(
    // padding: EdgeInsets.only(right: 16.0),
    // child: CircleAvatar(
    // radius: 16,
    // // backgroundImage: userImageUrl != null
    // // ? NetworkImage(userImageUrl)
    // //     : null,
    // // child: userImageUrl == null
    // // ? Icon(Icons.person)
    // //     : null,
    // ),
    // ),
    const Padding(
    padding: EdgeInsets.only(right: 16.0),
    child: CircleAvatar(
    radius: 16,
    backgroundColor: Color(0xFFE2E8F0),
    child: Icon(
    Icons.person,
    size: 18,
    color: Color(0xFF64748B),
    ),
    ),
    ),
    ],
    ),
    drawer: SideNav(
    onMenuSelect: (value) {
    setState(() {
    selectedMenu = value;
    });
    Navigator.pop(context);
    },
    ),
    body: getScreen(),
    );
  }
}
