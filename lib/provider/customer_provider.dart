import 'package:flutter/cupertino.dart';
import 'package:nyoba/services/customer_api.dart';
import 'package:nyoba/utils/utility.dart';

class CustomerProvider with ChangeNotifier {
  bool loading = false;
  bool loadingUse = false;

  Future<bool> addCustomer(context, customer) async {
    loading = true;
    await CustomerAPI().postCustomer(customer).then((data) {
      if (data != null || data != "") {
        snackBar(context,
            message: 'Tạo mới customer thành công!', color: Color(0xFF00FF00));
        loading = false;

        notifyListeners();
        return true;
      } else {
        snackBar(context,
            message: 'Tạo mới customer thất bại!', color: Color(0xFFFF0000));
        loading = false;
        notifyListeners();
        return false;
      }
    });
    return false;
  }
}
