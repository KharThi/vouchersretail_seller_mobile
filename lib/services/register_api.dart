import 'dart:convert';

import 'package:http/http.dart' as http;

class RegisterAPI {
  register(String? firstName, String? lastName, String? email, String? username,
      String? password, String phone) async {
    Map data = {
      // "user_email": email,
      // "user_login": username,
      "userName": username,
      "password": password,
      "email": email,
      "role": "Admin",
      // "last_name": lastName,
      "phoneNumber": phone
    };
    // var response2 = await baseAPI2.postAsync(
    //   '$signUp2',
    //   data,
    //   isCustom: true,
    // );
    var body = json.encode(data);
    var response = await http.post(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/login/signup"),
        headers: {"Content-Type": "application/json"},
        body: body);
    print(body);
    var dataResponse = await json.decode(response.body);
    print("Response" + dataResponse.toString());
    return dataResponse;
  }
}
