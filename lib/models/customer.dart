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
    this.cartId,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  String? customerName;
  UserInfo? userInfo;
  int? userInfoId;
  int? assignSellerId;
  AssignSeller? assignSeller;
  int? cartId;
  String? createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        customerName: json["customerName"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
        userInfoId: json["userInfoId"],
        assignSellerId:
            json["assignSellerId"] == null ? null : json["assignSellerId"],
        assignSeller: json["assignSeller"] == null
            ? null
            : AssignSeller.fromJson(json["assignSeller"]),
        cartId: json["cartId"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerName": customerName,
        "userInfo": userInfo!.toJson(),
        "userInfoId": userInfoId,
        "assignSellerId": assignSellerId,
        "assignSeller": assignSeller!.toJson(),
        "cartId": cartId,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}

class AssignSeller {
  AssignSeller({
    this.id,
    this.sellerName,
    this.userInfoId,
    this.commissionRate,
    this.profit,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  String? sellerName;
  int? userInfoId;
  double? commissionRate;
  int? profit;
  String? createAt;
  String? updateAt;
  dynamic deleteAt;
  String? status;

  factory AssignSeller.fromJson(Map<String, dynamic> json) => AssignSeller(
        id: json["id"],
        sellerName: json["sellerName"],
        userInfoId: json["userInfoId"],
        commissionRate: json["commissionRate"].toDouble(),
        profit: json["profit"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sellerName": sellerName,
        "userInfoId": userInfoId,
        "commissionRate": commissionRate,
        "profit": profit,
        "createAt": createAt,
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
  String? createAt;
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
