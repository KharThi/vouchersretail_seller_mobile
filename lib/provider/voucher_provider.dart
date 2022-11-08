// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:nyoba/services/voucher_api.dart';

import '../models/product_model.dart';

class VoucherProvider with ChangeNotifier {
  bool loading = false;
  List<Voucher> listVoucher = [];
  Future<List<Voucher>?> fetchVouchers() async {
    loading = true;
    var result;
    List<Voucher> list = List.empty(growable: true);
    await VoucherAPI().fetchVoucher().then((data) {
      result = data;
      list = data.cast<Voucher>();
    });
    listVoucher.clear();
    listVoucher = list;
    loading = false;
    notifyListeners();
    return list;
  }
}
