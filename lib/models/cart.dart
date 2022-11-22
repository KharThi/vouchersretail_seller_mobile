// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

List<Cart> cartFromJson(String str) =>
    List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
  Cart({
    this.id,
    this.customerId,
    this.cartItems,
  });

  int? id;
  int? customerId;
  List<CartItem>? cartItems;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        customerId: json["customerId"],
        cartItems: List<CartItem>.from(
            json["cartItems"].map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerId": customerId,
        "cartItems": List<dynamic>.from(cartItems!.map((x) => x.toJson())),
      };
}

class CartItem {
  CartItem({
    this.id,
    this.quantity,
    this.voucher,
    this.voucherId,
    this.price,
    this.priceId,
    this.useDate,
  });

  int? id;
  int? quantity;
  VoucherForCart? voucher;
  int? voucherId;
  int? price;
  int? priceId;
  DateTime? useDate;
  bool? isSelected;
  bool? isChange;
  int? oldQuantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        quantity: json["quantity"],
        voucher: VoucherForCart.fromJson(json["voucher"]),
        voucherId: json["voucherId"],
        price: json["price"],
        priceId: json["priceId"],
        useDate: DateTime.parse(json["useDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "voucher": voucher,
        "voucherId": voucherId,
        "price": price,
        "priceId": priceId,
        "useDate": useDate,
      };
}

class VoucherForCart {
  VoucherForCart({
    this.id,
    this.voucherName,
    this.price,
    this.inventory,
    this.limitPerDay,
    this.isRequireProfileInfo,
    this.startDate,
    this.endDate,
    this.serviceId,
  });

  int? id;
  String? voucherName;
  int? price;
  int? inventory;
  int? limitPerDay;
  bool? isRequireProfileInfo;
  DateTime? startDate;
  DateTime? endDate;
  int? serviceId;

  factory VoucherForCart.fromJson(Map<String, dynamic> json) => VoucherForCart(
        id: json["id"],
        voucherName: json["voucherName"],
        price: json["price"],
        inventory: json["inventory"],
        limitPerDay: json["limitPerDay"],
        isRequireProfileInfo: json["isRequireProfileInfo"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        serviceId: json["serviceId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voucherName": voucherName,
        "price": price,
        "inventory": inventory,
        "limitPerDay": limitPerDay,
        "isRequireProfileInfo": isRequireProfileInfo,
        "startDate": startDate,
        "endDate": endDate,
        "serviceId": serviceId,
      };
}
