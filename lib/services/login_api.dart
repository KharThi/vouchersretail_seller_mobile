import 'dart:convert';

import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginAPI {
  loginByDefault(String? username, String? password) async {
    SharedPreferences data2 = await SharedPreferences.getInstance();
    Map data = {'email': username, 'password': password};
    // var response = await baseAPI.postAsync(
    //   '$loginDefault',
    //   data,
    //   isCustom: true,
    // );
    var body = json.encode(data);
    var response2 = await http.post(
        Uri.parse("https://webapp-220831200534.azurewebsites.net/api/v1/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
    print("object");
    // return response;
    data2.setString("jwt", response2.body);
    // var dataResponse = await json.decode(response2.body);
    print("Bearer " + response2.body);
    // print("Response 1" + dataResponse.toString());
    var response = await http.get(
        Uri.parse(
            "https://webapp-220831200534.azurewebsites.net/api/v1/users/current"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + response2.body
        });
    print("Bearer " + response2.body);
    var dataResponse2 = await json.decode(response.body);
    print("Response 2" + dataResponse2.toString());
    return dataResponse2;
  }

  loginByOTP(phone) async {
    var response =
        await baseAPI.getAsync('$signInOTP?phone=$phone', isCustom: true);
    return response;
  }

  loginByGoogle(token) async {
    var response = await baseAPI.getAsync('$signInGoogle?access_token=$token',
        isCustom: true);
    return response;
  }

  loginByFacebook(token) async {
    var response = await baseAPI.getAsync('$signInFacebook?access_token=$token',
        isCustom: true);
    return response;
  }

  loginByApple(email, displayName, userName) async {
    Map data = {
      'email': email,
      'display_name': displayName,
      'user_name': userName
    };
    var response = await baseAPI.postAsync('$signInApple', data,
        isCustom: true, printedLog: true);
    return response;
  }

  inputTokenAPI() async {
    Map data = {
      'token': Session.data.getString('device_token'),
      'cookie': Session.data.getString('cookie')
    };
    printLog(data.toString(), name: 'Token Firebase');
    var response = await baseAPI.postAsync(
      '$inputTokenUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  forgotPasswordAPI(String? email) async {
    Map data = {'email': email};
    var response = await baseAPI.postAsync(
      '$forgotPasswordUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
