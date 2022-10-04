// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.status,
    this.id,
    this.createDate,
    this.orderStatus,
    this.customerId,
    this.sellerId,
    this.orderItems,
  });

  String? status;
  int? id;
  String? createDate;
  String? orderStatus;
  int? customerId;
  int? sellerId;
  List<OrderItem>? orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        status: json["status"],
        id: json["id"],
        createDate: json["createDate"],
        orderStatus: json["orderStatus"],
        customerId: json["customerId"],
        sellerId: json["sellerId"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "createDate": createDate,
        "orderStatus": orderStatus,
        "customerId": customerId,
        "sellerId": sellerId,
        "orderItems": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      };
}

class OrderItem {
  OrderItem({
    this.status,
    this.orderId,
    this.orderProductId,
    this.priceId,
    this.profileId,
    this.useDate,
  });

  String? status;
  int? orderId;
  int? orderProductId;
  int? priceId;
  int? profileId;
  String? useDate;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        status: json["status"],
        orderId: json["orderId"],
        orderProductId: json["orderProductId"],
        priceId: json["priceId"],
        profileId: json["profileId"],
        useDate: json["useDate"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "orderId": orderId,
        "orderProductId": orderProductId,
        "priceId": priceId,
        "profileId": profileId,
        "useDate": useDate,
      };
}
