// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

List<Customer> customerFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  Customer({
    this.id,
    this.customerName,
    this.userInfo,
    this.userInfoId,
    this.assignSellerId,
    this.assignSeller,
    this.profiles,
    this.cartId,
  });

  int? id;
  String? customerName;
  UserInfo? userInfo;
  int? userInfoId;
  int? assignSellerId;
  AssignSeller? assignSeller;
  List<Profile>? profiles;
  int? cartId;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        customerName: json["customerName"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
        userInfoId: json["userInfoId"],
        assignSellerId: json["assignSellerId"],
        assignSeller: json["assignSeller"] != null
            ? AssignSeller.fromJson(json["assignSeller"])
            : null,
        profiles: List<Profile>.from(
            json["profiles"].map((x) => Profile.fromJson(x))),
        cartId: json["cartId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerName": customerName,
        "userInfo": userInfo,
        "userInfoId": userInfoId,
        "assignSellerId": assignSellerId,
        "assignSeller": assignSeller,
        "profiles": List<dynamic>.from(profiles!.map((x) => x.toJson())),
        "cartId": cartId,
      };
}

class AssignSeller {
  AssignSeller({
    this.id,
    this.sellerName,
    this.userInfoId,
    this.commissionRate,
    this.profit,
    this.busyLevel,
    this.status,
  });

  int? id;
  String? sellerName;
  int? userInfoId;
  double? commissionRate;
  int? profit;
  String? busyLevel;
  String? status;

  factory AssignSeller.fromJson(Map<String, dynamic> json) => AssignSeller(
        id: json["id"],
        sellerName: json["sellerName"],
        userInfoId: json["userInfoId"],
        commissionRate: json["commissionRate"].toDouble(),
        profit: json["profit"],
        busyLevel: json["busyLevel"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sellerName": sellerName,
        "userInfoId": userInfoId,
        "commissionRate": commissionRate,
        "profit": profit,
        "busyLevel": busyLevel,
        "status": status,
      };
}

class UserInfo {
  UserInfo({
    this.id,
    this.email,
    this.avatarLink,
    this.userName,
    this.role,
    this.phoneNumber,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  String? email;
  String? avatarLink;
  String? userName;
  String? role;
  String? phoneNumber;
  String? createAt;
  String? updateAt;
  String? deleteAt;
  String? status;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        email: json["email"],
        avatarLink: json["avatarLink"],
        userName: json["userName"],
        role: json["role"],
        phoneNumber: json["phoneNumber"] != null ? json["phoneNumber"] : "",
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "email": email,
        "avatarLink": avatarLink,
        "userName": userName,
        "role": role,
        "phoneNumber": phoneNumber,
        // "createAt": createAt,
        // "updateAt": updateAt,
        // "deleteAt": deleteAt,
        "status": status,
      };
}

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.id,
    this.sex,
    this.phoneNumber,
    this.dateOfBirth,
    this.name,
    this.civilIdentify,
    this.customerId,
  });

  int? id;
  int? sex;
  String? phoneNumber;
  String? dateOfBirth;
  String? name;
  String? civilIdentify;
  int? customerId;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        sex: json["sex"],
        phoneNumber: json["phoneNumber"],
        dateOfBirth: json["dateOfBirth"],
        name: json["name"],
        civilIdentify: json["civilIdentify"],
        customerId: json["customerId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sex": sex,
        "phoneNumber": phoneNumber,
        "dateOfBirth": dateOfBirth,
        "name": name,
        "civilIdentify": civilIdentify,
        "customerId": customerId,
      };
}
