import 'package:flutter/foundation.dart';
import 'package:nyoba/models/point_model.dart';
import 'package:nyoba/models/seller_model.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/services/user_api.dart';
import 'package:nyoba/utils/utility.dart';

class UserProvider with ChangeNotifier {
  Seller _user = new Seller();

  Seller get user => _user;

  bool loading = false;

  PointModel? point;

  void setUser(Seller user) {
    _user = user;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchUserDetail() async {
    loading = true;
    var result;
    await UserAPI().fetchDetail().then((data) {
      result = data;
      print(result);
      // printLog(result.toString());

      Seller userModel = Seller.fromJson(result);
      // if (result['poin'] != null) {
      //   point = PointModel.fromJson(result['poin']);
      // }
      Session().saveUser(userModel);

      this.setUser(userModel);

      print(point.toString());
      loading = false;
      notifyListeners();
    });
    loading = false;
    notifyListeners();
    return result;
  }

  Future<Seller?> fetchUserDetail2() async {
    loading = true;
    var result;
    Seller? userModel;
    await UserAPI().fetchDetail().then((data) {
      result = data;
      print(result);
      // printLog(result.toString());

      userModel = Seller.fromJson(result);
      // if (result['poin'] != null) {
      //   point = PointModel.fromJson(result['poin']);
      // }
      Session().saveUser(userModel!);

      this.setUser(userModel!);

      print(point.toString());
      loading = false;
      notifyListeners();
    });
    loading = false;
    notifyListeners();
    return userModel;
  }

  Future<Map<String, dynamic>?> updateUser(
      {String? firstName,
      String? lastName,
      String? username,
      required String password,
      String? oldPassword}) async {
    loading = true;
    var result;
    await UserAPI()
        .updateUserInfo(
            firstName: firstName,
            lastName: lastName,
            password: password,
            oldPassword: oldPassword)
        .then((data) {
      result = data;
      printLog(result.toString());

      if (result['is_success'] == true) {
        Session.data.setString('cookie', result['cookie']);
      }

      loading = false;
      notifyListeners();
    });
    return result;
  }
}
