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
    this.id,
    this.totalPrice,
    this.orderStatus,
    this.customerId,
    this.sellerId,
    this.paymentDetail,
    this.orderItems,
  });

  int? id;
  int? totalPrice;
  String? orderStatus;
  int? customerId;
  int? sellerId;
  dynamic paymentDetail;
  List<OrderItem>? orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        totalPrice: json["totalPrice"],
        orderStatus: json["orderStatus"],
        customerId: json["customerId"],
        sellerId: json["sellerId"],
        paymentDetail: json["paymentDetail"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalPrice": totalPrice,
        "orderStatus": orderStatus,
        "customerId": customerId,
        "sellerId": sellerId,
        "paymentDetail": paymentDetail,
        "orderItems": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      };
}

class OrderItem {
  OrderItem({
    this.id,
    this.orderId,
    this.orderProductId,
    this.priceId,
    this.profileId,
    this.useDate,
  });

  int? id;
  int? orderId;
  int? orderProductId;
  int? priceId;
  dynamic profileId;
  DateTime? useDate;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        orderId: json["orderId"],
        orderProductId: json["orderProductId"],
        priceId: json["priceId"],
        profileId: json["profileId"],
        useDate:
            json["useDate"] == null ? null : DateTime.parse(json["useDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "orderProductId": orderProductId,
        "priceId": priceId,
        "profileId": profileId,
        "useDate": useDate == null ? null : useDate!.toIso8601String(),
      };
}
