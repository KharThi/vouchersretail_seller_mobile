// To parse this JSON data, do
//
//     final seller = sellerFromJson(jsonString);

import 'dart:convert';

List<Seller> sellerFromJson(String str) =>
    List<Seller>.from(json.decode(str).map((x) => Seller.fromJson(x)));

String sellerToJson(List<Seller> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Seller {
  Seller({
    this.id,
    this.sellerName,
    this.userInfoId,
    this.userInfo,
    this.commissionRate,
    this.profit,
    this.orders,
    this.busyLevel,
  });

  int? id;
  String? sellerName;
  int? userInfoId;
  UserInfo? userInfo;
  int? commissionRate;
  int? profit;
  String? orders;
  String? busyLevel;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        sellerName: json["sellerName"],
        userInfoId: json["userInfoId"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
        commissionRate: json["commissionRate"],
        profit: json["profit"],
        orders: json["orders"],
        busyLevel: json["busyLevel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sellerName": sellerName,
        "userInfoId": userInfoId,
        "userInfo": userInfo!.toJson(),
        "commissionRate": commissionRate,
        "profit": profit,
        "orders": orders,
        "busyLevel": busyLevel,
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
        "id": id,
        "email": email,
        "avatarLink": avatarLink,
        "userName": userName,
        "role": role,
        "phoneNumber": phoneNumber,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}
