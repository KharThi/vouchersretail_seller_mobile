// To parse this JSON data, do
//
//     final combo = comboFromJson(jsonString);

import 'dart:convert';

List<Combo> comboFromJson(String str) =>
    List<Combo>.from(json.decode(str).map((x) => Combo.fromJson(x)));

String comboToJson(List<Combo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Combo {
  Combo({
    this.id,
    this.name,
    this.startDate,
    this.endDate,
    this.description,
    this.summary,
    this.bannerImg,
    this.content,
    this.isForKid,
    this.type,
    this.prices,
    this.productId,
    this.vouchers,
  });

  int? id;
  String? name;
  String? startDate;
  String? endDate;
  String? description;
  String? summary;
  String? bannerImg;
  String? content;
  bool? isForKid;
  String? type;
  List<dynamic>? prices;
  int? productId;
  List<dynamic>? vouchers;

  factory Combo.fromJson(Map<String, dynamic> json) => Combo(
        id: json["id"],
        name: json["name"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        description: json["description"],
        summary: json["summary"],
        bannerImg: json["bannerImg"],
        content: json["content"],
        isForKid: json["isForKid"],
        type: json["type"],
        prices: List<dynamic>.from(json["prices"].map((x) => x)),
        productId: json["productId"],
        vouchers: List<dynamic>.from(json["vouchers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "startDate": startDate,
        "endDate": endDate,
        "description": description,
        "summary": summary,
        "bannerImg": bannerImg,
        "content": content,
        "isForKid": isForKid,
        "type": type,
        "prices": List<dynamic>.from(prices!.map((x) => x)),
        "productId": productId,
        "vouchers": List<dynamic>.from(vouchers!.map((x) => x)),
      };
}

// To parse this JSON data, do
//
//     final combo = comboFromJson(jsonString);

// To parse this JSON data, do
//
//     final comboPq = comboPqFromJson(jsonString);

Combo comboPqFromJson(String str) => Combo.fromJson(json.decode(str));

String comboPqToJson(Combo data) => json.encode(data.toJson());
