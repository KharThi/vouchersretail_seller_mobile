import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/customer.dart';

class CustomerAPI {
  postCustomer(Customer? customer, Profile profile) async {
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
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers"),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> dataResponse = await json.decode(response.body);
      Map profileData = {
        "status": "Active",
        "sex": profile.sex,
        "phoneNumber": profile.phoneNumber,
        "dateOfBirth": profile.dateOfBirth,
        "name": profile.name,
        "civilIdentify": profile.civilIdentify,
        "customerId": dataResponse["id"]
      };
      var body2 = json.encode(profileData);
      print("body2" + body2);
      var response2 = await http.post(
          Uri.parse(
              "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
                  dataResponse["id"].toString() +
                  "/profiles"),
          body: body2,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + jwt.toString()
          });
      print("object" + dataResponse["id"]);
      return dataResponse["id"];
    } else {
      return null;
    }

    return "";
  }

  putCustomer(Profile profile) async {
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
      "sex": profile.sex,
      "phoneNumber": profile.phoneNumber,
      "dateOfBirth": profile.dateOfBirth,
      "name": profile.name,
      "civilIdentify": profile.civilIdentify,
      "customerId": profile.customerId,
      "status": "Active"
    };

    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    var body = json.encode(userInfo);
    print("jwt " + jwt.toString());
    print("body" + body);

    var response = await http.put(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
                profile.customerId.toString() +
                "/profiles/" +
                profile.id.toString()),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> dataResponse = await json.decode(response.body);
      return dataResponse["id"];
    }

    return "";
  }

  getListCustomer() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    print("jwt " + jwt.toString());

    var response = await http.get(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response.body);
    // ignore: unused_local_variable
    // List<dynamic> dataResponse = await json.decode(response.body);
    Iterable l = json.decode(response.body);
    List<Customer> customers =
        List<Customer>.from(l.map((model) => Customer.fromJson(model)));
    return customers;
  }
}
