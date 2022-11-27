// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    this.createAt,
    this.id,
    this.totalPrice,
    this.orderStatus,
    this.customerId,
    this.customer,
    this.sellerId,
    this.seller,
    this.paymentDetail,
    this.orderItems,
  });

  String? createAt;
  int? id;
  int? totalPrice;
  String? orderStatus;
  int? customerId;
  CustomerForOrder? customer;
  int? sellerId;
  Seller? seller;
  PaymentDetail? paymentDetail;
  List<OrderItemForOrder>? orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        createAt: json["createAt"],
        id: json["id"],
        totalPrice: json["totalPrice"],
        orderStatus: json["orderStatus"],
        customerId: json["customerId"],
        customer: CustomerForOrder.fromJson(json["customer"]),
        sellerId: json["sellerId"] == null ? null : json["sellerId"],
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
        paymentDetail: json["paymentDetail"] == null
            ? null
            : PaymentDetail.fromJson(json["paymentDetail"]),
        orderItems: List<OrderItemForOrder>.from(
            json["orderItems"].map((x) => OrderItemForOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "id": id,
        "totalPrice": totalPrice,
        "orderStatus": orderStatus,
        "customerId": customerId,
        "customer": customer!.toJson(),
        "sellerId": sellerId == null ? null : sellerId,
        "seller": seller == null ? null : seller!.toJson(),
        "paymentDetail": paymentDetail == null ? null : paymentDetail!.toJson(),
        "orderItems": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      };
}

class CustomerForOrder {
  CustomerForOrder({
    this.id,
    this.customerName,
    this.userInfo,
    this.userInfoId,
    this.assignSellerId,
    this.assignSeller,
    this.cartId,
  });

  int? id;
  String? customerName;
  UserInfo? userInfo;
  int? userInfoId;
  int? assignSellerId;
  Seller? assignSeller;
  int? cartId;

  factory CustomerForOrder.fromJson(Map<String, dynamic> json) =>
      CustomerForOrder(
        id: json["id"],
        customerName: json["customerName"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
        userInfoId: json["userInfoId"],
        assignSellerId:
            json["assignSellerId"] == null ? null : json["assignSellerId"],
        assignSeller: json["assignSeller"] == null
            ? null
            : Seller.fromJson(json["assignSeller"]),
        cartId: json["cartId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerName": customerName,
        "userInfo": userInfo!.toJson(),
        "userInfoId": userInfoId,
        "assignSellerId": assignSellerId == null ? null : assignSellerId,
        "assignSeller": assignSeller == null ? null : assignSeller!.toJson(),
        "cartId": cartId,
      };
}

class Seller {
  Seller({
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

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
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
        avatarLink: json["avatarLink"] == null ? null : json["avatarLink"],
        userName: json["userName"],
        role: json["role"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "avatarLink": avatarLink == null ? null : avatarLink,
        "userName": userName,
        "role": role,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "createAt": createAt == null ? null : createAt,
        "updateAt": updateAt == null ? null : updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}

class OrderItemForOrder {
  OrderItemForOrder({
    this.id,
    this.orderId,
    this.voucherId,
    this.priceId,
    this.priceLevel,
    this.profileId,
    this.useDate,
  });

  int? id;
  int? orderId;
  int? voucherId;
  int? priceId;
  String? priceLevel;
  int? profileId;
  String? useDate;

  factory OrderItemForOrder.fromJson(Map<String, dynamic> json) =>
      OrderItemForOrder(
        id: json["id"],
        orderId: json["orderId"],
        voucherId: json["voucherId"],
        priceId: json["priceId"],
        priceLevel: json["priceLevel"],
        profileId: json["profileId"] == null ? null : json["profileId"],
        useDate: json["useDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "voucherId": voucherId,
        "priceId": priceId,
        "priceLevel": priceLevel,
        "profileId": profileId == null ? null : profileId,
        "useDate": useDate,
      };
}

class PaymentDetail {
  PaymentDetail({
    this.id,
    this.amount,
    this.paymentDate,
    this.content,
    this.orderId,
  });

  int? id;
  int? amount;
  String? paymentDate;
  String? content;
  int? orderId;

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        id: json["id"],
        amount: json["amount"],
        paymentDate: json["paymentDate"],
        content: json["content"],
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "paymentDate": paymentDate,
        "content": content,
        "orderId": orderId,
      };
}
