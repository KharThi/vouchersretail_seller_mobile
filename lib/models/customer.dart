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
    required this.id,
    this.customerName,
    this.userInfo,
    this.userInfoId,
    this.cartId,
  });

  int id;
  String? customerName;
  UserInfo? userInfo;
  int? userInfoId;
  int? cartId;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        customerName: json["customerName"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
        userInfoId: json["userInfoId"],
        cartId: json["cartId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerName": customerName,
        "userInfo": userInfo!.toJson(),
        "userInfoId": userInfoId,
        "cartId": cartId,
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
        phoneNumber: json["phoneNumber"],
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
