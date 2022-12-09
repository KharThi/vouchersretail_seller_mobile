// To parse this JSON data, do
//
//     final seller = sellerFromJson(jsonString);

import 'dart:convert';

Seller sellerFromJson(String str) => Seller.fromJson(json.decode(str));

String sellerToJson(Seller data) => json.encode(data.toJson());

class Seller {
  Seller({
    this.id,
    this.createAt,
    this.sellerName,
    this.userInfoId,
    this.userInfo,
    this.commissionRate,
    this.profit,
    this.orders,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  String? createAt;
  String? sellerName;
  int? userInfoId;
  UserInfo? userInfo;
  double? commissionRate;
  int? profit;
  dynamic orders;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        createAt: json["createAt"],
        sellerName: json["sellerName"],
        userInfoId: json["userInfoId"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
        commissionRate: json["commissionRate"].toDouble(),
        profit: json["profit"],
        orders: json["orders"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createAt": createAt,
        "sellerName": sellerName,
        "userInfoId": userInfoId,
        "userInfo": userInfo!.toJson(),
        "commissionRate": commissionRate,
        "profit": profit,
        "orders": orders,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
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
    this.providerId,
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
  int? providerId;
  dynamic createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        email: json["email"],
        avatarLink: json["avatarLink"],
        userName: json["userName"],
        role: json["role"],
        phoneNumber: json["phoneNumber"],
        providerId: json["providerId"],
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
        "providerId": providerId,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}
