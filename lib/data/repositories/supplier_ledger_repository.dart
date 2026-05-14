import 'dart:convert';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/ledger/supplier_ledger_model.dart';
import 'package:enterprise_resource_planning/data/models/ledger/supplier_payment_model.dart';


class SupplierLedgerRepository {
  final String baseUrl = "http://10.0.2.2:8080";

  Future<List<SupplierLedgerSummary>> getAllSuppliers() async {
    final res = await ApiClient.get(
      Uri.parse("$baseUrl/supplier-ledger/due-summary"),
    );

    final data = jsonDecode(res.body) as List;

    return data.map((e) => SupplierLedgerSummary.fromJson(e)).toList();
  }

  Future<List<SupplierLedgerDetails>> getSupplierLedgerDetails(int id) async {
    final res = await ApiClient.get(
      Uri.parse("$baseUrl/supplier-ledger/$id"),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => SupplierLedgerDetails.fromJson(e)).toList();
  }

  Future<SupplierPaymentResponse> createPayment(SupplierPaymentRequest req) async {
    final response = await ApiClient.post(
      Uri.parse("$baseUrl/supplier-payments"),
      jsonEncode(req.toJson()),
    );
    return SupplierPaymentResponse.fromJson(jsonDecode(response.body));
  }
}