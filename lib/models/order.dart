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
  PaymentDetail? paymentDetail;
  List<OrderItem>? orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        totalPrice: json["totalPrice"],
        orderStatus: json["orderStatus"],
        customerId: json["customerId"],
        sellerId: json["sellerId"] == null ? null : json["sellerId"],
        paymentDetail: json["paymentDetail"] == null
            ? null
            : PaymentDetail.fromJson(json["paymentDetail"]),
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalPrice": totalPrice,
        "orderStatus": orderStatus,
        "customerId": customerId,
        "sellerId": sellerId == null ? null : sellerId,
        "paymentDetail": paymentDetail == null ? null : paymentDetail!.toJson(),
        "orderItems": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      };
}

class OrderItem {
  OrderItem({
    this.id,
    this.orderId,
    this.voucherId,
    this.priceId,
    this.profileId,
    this.useDate,
  });

  int? id;
  int? orderId;
  int? voucherId;
  int? priceId;
  int? profileId;
  DateTime? useDate;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        orderId: json["orderId"],
        voucherId: json["voucherId"],
        priceId: json["priceId"],
        profileId: json["profileId"] == null ? null : json["profileId"],
        useDate: DateTime.parse(json["useDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "voucherId": voucherId,
        "priceId": priceId,
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
  DateTime? paymentDate;
  String? content;
  int? orderId;

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        id: json["id"],
        amount: json["amount"],
        paymentDate: DateTime.parse(json["paymentDate"]),
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
