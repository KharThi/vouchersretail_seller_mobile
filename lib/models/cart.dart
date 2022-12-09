// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  Cart({
    this.id,
    this.customerId,
    this.cartItems,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  int? customerId;
  List<CartItem>? cartItems;
  dynamic createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        customerId: json["customerId"],
        cartItems: List<CartItem>.from(
            json["cartItems"].map((x) => CartItem.fromJson(x))),
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerId": customerId,
        "cartItems": List<dynamic>.from(cartItems!.map((x) => x.toJson())),
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}

class CartItem {
  CartItem({
    this.id,
    this.quantity,
    this.voucher,
    this.voucherId,
    this.isCombo,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  int? quantity;
  VoucherForCart? voucher;
  int? voucherId;
  bool? isCombo;
  String? createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;
  bool? isSelected;
  bool? isChange;
  int? oldQuantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        quantity: json["quantity"],
        voucher: VoucherForCart.fromJson(json["voucher"]),
        voucherId: json["voucherId"],
        isCombo: json["isCombo"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "voucher": voucher!.toJson(),
        "voucherId": voucherId,
        "isCombo": isCombo,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}

class VoucherForCart {
  VoucherForCart({
    this.id,
    this.voucherName,
    this.startDate,
    this.endDate,
    this.serviceId,
    this.serviceTypeId,
    this.providerId,
    this.description,
    this.summary,
    this.socialPost,
    this.inventory,
    this.bannerImg,
    this.content,
    this.soldPrice,
    this.voucherValue,
    this.isCombo,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  String? voucherName;
  String? startDate;
  String? endDate;
  int? serviceId;
  int? serviceTypeId;
  int? providerId;
  String? description;
  String? summary;
  dynamic socialPost;
  int? inventory;
  String? bannerImg;
  String? content;
  int? soldPrice;
  int? voucherValue;
  bool? isCombo;
  String? createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory VoucherForCart.fromJson(Map<String, dynamic> json) => VoucherForCart(
        id: json["id"],
        voucherName: json["voucherName"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        serviceId: json["serviceId"],
        serviceTypeId: json["serviceTypeId"],
        providerId: json["providerId"],
        description: json["description"],
        summary: json["summary"],
        socialPost: json["socialPost"],
        inventory: json["inventory"],
        bannerImg: json["bannerImg"],
        content: json["content"],
        soldPrice: json["soldPrice"],
        voucherValue: json["voucherValue"],
        isCombo: json["isCombo"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voucherName": voucherName,
        "startDate": startDate,
        "endDate": endDate,
        "serviceId": serviceId,
        "serviceTypeId": serviceTypeId,
        "providerId": providerId,
        "description": description,
        "summary": summary,
        "socialPost": socialPost,
        "inventory": inventory,
        "bannerImg": bannerImg,
        "content": content,
        "soldPrice": soldPrice,
        "voucherValue": voucherValue,
        "isCombo": isCombo,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}
