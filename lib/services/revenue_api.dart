//PQ voucher
// ignore_for_file: await_only_futures

import 'package:nyoba/models/revenue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_model.dart';

class RevenueApi {
  fetchRevenues(String year) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/kpi?year=" +
                year),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    var dataResponse = await json.decode(response.body);

    Iterable list = dataResponse;

    final listData = list.cast<Map<String, dynamic>>();
    final result = await listData.map<Revenue>((json) {
      return Revenue.fromJson(json);
    }).toList();
    return result;
  }
}
