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
    this.customer,
    this.sellerId,
    this.seller,
    this.paymentDetail,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  int? totalPrice;
  String? orderStatus;
  int? customerId;
  CustomerForOrder? customer;
  dynamic sellerId;
  dynamic seller;
  PaymentDetail? paymentDetail;
  DateTime? createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        totalPrice: json["totalPrice"],
        orderStatus: json["orderStatus"],
        customerId: json["customerId"],
        customer: CustomerForOrder.fromJson(json["customer"]),
        sellerId: json["sellerId"],
        seller: json["seller"],
        paymentDetail: json["paymentDetail"] == null
            ? null
            : PaymentDetail.fromJson(json["paymentDetail"]),
        createAt: DateTime.parse(json["createAt"]),
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalPrice": totalPrice,
        "orderStatus": orderStatus,
        "customerId": customerId,
        "customer": customer!.toJson(),
        "sellerId": sellerId,
        "seller": seller,
        "paymentDetail": paymentDetail == null ? null : paymentDetail!.toJson(),
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
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
            : AssignSeller.fromJson(json["assignSeller"]),
        cartId: json["cartId"] == null ? null : json["cartId"],
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
        "assignSellerId": assignSellerId == null ? null : assignSellerId,
        "assignSeller": assignSeller == null ? null : assignSeller!.toJson(),
        "cartId": cartId == null ? null : cartId,
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
  dynamic updateAt;
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
  String? updateAt;
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
        "createAt": createAt == null ? null : createAt,
        "updateAt": updateAt == null ? null : updateAt,
        "deleteAt": deleteAt,
        "status": status,
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

DetailOrder detailOrderFromJson(String str) =>
    DetailOrder.fromJson(json.decode(str));

String detailOrderToJson(DetailOrder data) => json.encode(data.toJson());

class DetailOrder {
  DetailOrder({
    this.createAt,
    this.id,
    this.totalPrice,
    this.orderStatus,
    this.customerId,
    this.sellerId,
    this.qrCodes,
    this.sellerName,
    this.paymentDetail,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  String? createAt;
  int? id;
  int? totalPrice;
  String? orderStatus;
  int? customerId;
  int? sellerId;
  List<QrCode>? qrCodes;
  String? sellerName;
  PaymentDetail? paymentDetail;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory DetailOrder.fromJson(Map<String, dynamic> json) => DetailOrder(
        createAt: json["createAt"],
        id: json["id"],
        totalPrice: json["totalPrice"],
        orderStatus: json["orderStatus"],
        customerId: json["customerId"],
        sellerId: json["sellerId"],
        qrCodes:
            List<QrCode>.from(json["qrCodes"].map((x) => QrCode.fromJson(x))),
        sellerName: json["sellerName"],
        paymentDetail: json["paymentDetail"] != null
            ? PaymentDetail.fromJson(json["paymentDetail"])
            : null,
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "id": id,
        "totalPrice": totalPrice,
        "orderStatus": orderStatus,
        "customerId": customerId,
        "sellerId": sellerId,
        "qrCodes": List<dynamic>.from(qrCodes!.map((x) => x.toJson())),
        "sellerName": sellerName,
        "paymentDetail": paymentDetail!.toJson(),
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}

List<QrCode> qrCodeFromJson(String str) =>
    List<QrCode>.from(json.decode(str).map((x) => QrCode.fromJson(x)));

String qrCodeToJson(List<QrCode> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QrCode {
  QrCode({
    this.id,
    this.hashCode2,
    this.voucherId,
    this.startDate,
    this.endDate,
    this.providerId,
    this.serviceId,
    this.qrCodeStatus,
    this.useDate,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  String? hashCode2;
  int? voucherId;
  String? startDate;
  String? endDate;
  int? providerId;
  int? serviceId;
  String? qrCodeStatus;
  String? useDate;
  String? createAt;
  String? updateAt;
  String? deleteAt;
  String? status;

  factory QrCode.fromJson(Map<String, dynamic> json) => QrCode(
        id: json["id"],
        hashCode2: json["hashCode"],
        voucherId: json["voucherId"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        providerId: json["providerId"],
        serviceId: json["serviceId"],
        qrCodeStatus: json["qrCodeStatus"],
        useDate: json["useDate"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hashCode": hashCode,
        "voucherId": voucherId,
        "startDate": startDate,
        "endDate": endDate,
        "providerId": providerId,
        "serviceId": serviceId,
        "qrCodeStatus": qrCodeStatus,
        "useDate": useDate,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}
