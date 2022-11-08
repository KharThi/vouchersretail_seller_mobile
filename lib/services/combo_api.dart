//PQ voucher
// ignore_for_file: await_only_futures

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_model.dart';

class ComboAPI {
  fetchCombo() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://webapp-221010174451.azurewebsites.net/api/v1/combos"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    var dataResponse = await json.decode(response.body);

    Iterable list = dataResponse['data'];

    final listData = list.cast<Map<String, dynamic>>();
    final result = await listData.map<Combo>((json) {
      return Combo.fromJson(json);
    }).toList();
    return result;
  }
}
