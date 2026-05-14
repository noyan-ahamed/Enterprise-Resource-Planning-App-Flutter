import 'dart:convert';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/ledger/customer_ledger_model.dart';

class CustomerLedgerRepository {
  final String baseUrl = "http://10.0.2.2:8080";

  Future<List<CustomerLedgerSummary>> getAllCustomersDueSummary() async {
    final res = await ApiClient.get(
      Uri.parse("$baseUrl/customer-ledger/due-summary"),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => CustomerLedgerSummary.fromJson(e)).toList();
  }

  Future<List<CustomerLedgerDetails>> getCustomerLedgerDetails(int id) async {
    final res = await ApiClient.get(
      Uri.parse("$baseUrl/customer-ledger/$id"),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => CustomerLedgerDetails.fromJson(e)).toList();
  }
}
