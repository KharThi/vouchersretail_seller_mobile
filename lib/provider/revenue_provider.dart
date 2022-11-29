import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nyoba/models/login_model.dart';
import 'package:nyoba/models/revenue.dart';
import 'package:nyoba/services/register_api.dart';
import 'package:nyoba/services/revenue_api.dart';
import 'package:nyoba/utils/utility.dart';

class RevenueProvider with ChangeNotifier {
  LoginModel? userLogin;
  bool loading = false;
  String? message;

  Future<List<Revenue>> getListRevenue(String year) async {
    var result;
    await RevenueApi().fetchRevenues(year).then((data) {
      result = data;
      loading = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }
}
