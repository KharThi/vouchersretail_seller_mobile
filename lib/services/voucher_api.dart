//PQ voucher
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_model.dart';

class VoucherAPI {
  fetchVoucher() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://webapp-221010174451.azurewebsites.net/api/v1/vouchers"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    var dataResponse = await json.decode(response.body);

    Iterable list = dataResponse['data'];

    final listData = list.cast<Map<String, dynamic>>();
    final result = await listData.map<Voucher>((json) {
      return Voucher.fromJson(json);
    }).toList();
    return result;
  }
}