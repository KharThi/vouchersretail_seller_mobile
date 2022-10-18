import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/customer.dart';

class CustomerAPI {
  postCustomer(Customer? customer) async {
    // Map data = {
    //   'cookie': Session.data.getString('cookie'),
    //   'post': postId,
    //   'comment': comment
    // };
    // var response = await baseAPI.postAsync(
    //   '$postComment',
    //   data,
    //   isCustom: true,
    // );
    // return response;
    Map userInfo = {
      // "user_email": email,
      // "user_login": username,
      "status": "Active",
      "email": customer!.userInfo!.email,
      "avatarLink": null,
      "userName": customer.userInfo!.userName,
      "role": "Customer",
      "phoneNumber": customer.userInfo!.phoneNumber
    };
    Map customerData = {
      // "user_email": email,
      // "user_login": username,
      "customerName": customer.customerName,
      "status": "Active",
      "userInfo": userInfo,
    };
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    var body = json.encode(customerData);
    print("jwt " + jwt.toString());
    print("body" + body);

    var response = await http.post(
        Uri.parse(
            "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers"),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response.body);
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    return dataResponse["data"];
  }

  getListCustomer() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    print("jwt " + jwt.toString());

    var response = await http.get(
        Uri.parse(
            "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    // print(response.body);
    // ignore: unused_local_variable
    List<dynamic> dataResponse = await json.decode(response.body);
    Iterable l = json.decode(response.body);
    List<Customer> customers =
        List<Customer>.from(l.map((model) => Customer.fromJson(model)));
    return customers;
  }
}
