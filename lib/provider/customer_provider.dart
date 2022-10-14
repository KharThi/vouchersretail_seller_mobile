import 'package:flutter/cupertino.dart';
import 'package:nyoba/models/customer.dart';
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

  Future<List<Customer>> getListCustomer(context) async {
    loading = true;
    List<Customer> customers = List.empty(growable: true);
    await CustomerAPI().getListCustomer().then((data) {
      if (data.length != 0 || data != "") {
        // Iterable l = data;
        // customers =
        //     List<Customer>.from(l.map((model) => Customer.fromJson(model)));
        customers = data;
        // for (var element in customers) {
        //   print(element.customerName);
        // }
        loading = false;
        notifyListeners();
        return customers;
      }
    });
    return customers;
  }
}
