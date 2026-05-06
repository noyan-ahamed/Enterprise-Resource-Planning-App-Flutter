import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:enterprise_resource_planning/data/models/supplier_model.dart';

class SupplierService {
  static const String baseUrl = 'http://10.0.2.2:8080/supplier';

  /// -------------------------
  /// GET ALL SUPPLIERS
  /// -------------------------
  Future<List<SupplierModel>> getAllSuppliers() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data
          .map((e) => SupplierModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load suppliers: ${response.body}');
    }
  }

  /// -------------------------
  /// GET SUPPLIER BY ID
  /// -------------------------
  Future<SupplierModel> getSupplierById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return SupplierModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load supplier');
    }
  }

  /// -------------------------
  /// CREATE SUPPLIER
  /// -------------------------
  Future<SupplierModel> createSupplier(SupplierModel supplier) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create-supplier'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(supplier.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SupplierModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create supplier: ${response.body}');
    }
  }

  /// -------------------------
  /// UPDATE SUPPLIER
  /// -------------------------
  Future<SupplierModel> updateSupplier(
      int id, SupplierModel supplier) async {

    final response = await http.put(
      Uri.parse('$baseUrl/update-supplier/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(supplier.toJson()),
    );

    if (response.statusCode == 200) {
      return SupplierModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update supplier: ${response.body}');
    }
  }

  /// -------------------------
  /// DELETE SUPPLIER
  /// -------------------------
  Future<void> deleteSupplier(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-supplier/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete supplier');
    }
  }
}