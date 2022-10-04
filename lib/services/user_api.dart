import 'dart:convert';

import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/services/session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAPI {
  fetchDetail() async {
    // Map data = {"cookie": Session.data.get('cookie')};
    SharedPreferences data2 = await SharedPreferences.getInstance();
    String? jwt = data2.getString("jwt");
    print(jwt);
    var response = await http.get(
        Uri.parse(
            "https://webapp-220831200534.azurewebsites.net/api/v1/sellers/current"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    var dataResponse2 = await json.decode(response.body);
    // var response = await baseAPI.postAsync('$userDetail', data, isCustom: true);
    return dataResponse2;
  }

  updateUserInfo(
      {String? firstName,
      String? lastName,
      required String password,
      String? oldPassword}) async {
    Map data = {
      "cookie": Session.data.get('cookie'),
      "first_name": firstName,
      "last_name": lastName,
      if (password.isNotEmpty) "user_pass": password,
      if (password.isNotEmpty) "old_pass": oldPassword
    };
    var response = await baseAPI.postAsync('$updateUser', data, isCustom: true);
    return response;
  }
}
