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
    this.product,
    this.productId,
    this.price,
    this.priceId,
  });

  int? id;
  int? quantity;
  Product? product;
  int? productId;
  int? price;
  int? priceId;
  bool? isSelected;
  bool? isChange;
  int? oldQuantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        quantity: json["quantity"],
        product: Product.fromJson(json["product"]),
        productId: json["productId"],
        price: json["price"],
        priceId: json["priceId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "product": product!.toJson(),
        "productId": productId,
        "price": price,
        "priceId": priceId,
      };
}

class Product {
  Product({
    this.id,
    this.description,
    this.summary,
    this.bannerImg,
    this.content,
    this.inventory,
    this.type,
  });

  int? id;
  String? description;
  String? summary;
  String? bannerImg;
  String? content;
  int? inventory;
  String? type;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        description: json["description"],
        summary: json["summary"],
        bannerImg: json["bannerImg"],
        content: json["content"],
        inventory: json["inventory"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "summary": summary,
        "bannerImg": bannerImg,
        "content": content,
        "inventory": inventory,
        "type": type,
      };
}
