// To parse this JSON data, do
//
//     final voucher = voucherFromJson(jsonString);

import 'dart:convert';

List<Voucher> voucherFromJson(String str) =>
    List<Voucher>.from(json.decode(str).map((x) => Voucher.fromJson(x)));

String voucherToJson(List<Voucher> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Voucher {
  Voucher({
    this.id,
    this.voucherName,
    this.inventory,
    this.limitPerDay,
    this.isRequireProfileInfo,
    this.startDate,
    this.endDate,
    this.productId,
    this.serviceId,
    this.description,
    this.summary,
    this.bannerImg,
    this.content,
    this.isForKid,
    this.type,
  });

  int? id;
  String? voucherName;
  int? inventory;
  int? limitPerDay;
  bool? isRequireProfileInfo;
  String? startDate;
  String? endDate;
  int? productId;
  int? serviceId;
  String? description;
  String? summary;
  String? bannerImg;
  String? content;
  bool? isForKid;
  String? type;

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["id"],
        voucherName: json["voucherName"],
        inventory: json["inventory"],
        limitPerDay: json["limitPerDay"],
        isRequireProfileInfo: json["isRequireProfileInfo"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        productId: json["productId"],
        serviceId: json["serviceId"],
        description: json["description"],
        summary: json["summary"],
        bannerImg: json["bannerImg"],
        content: json["content"],
        isForKid: json["isForKid"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voucherName": voucherName,
        "inventory": inventory,
        "limitPerDay": limitPerDay,
        "isRequireProfileInfo": isRequireProfileInfo,
        "startDate": startDate,
        "endDate": endDate,
        "productId": productId,
        "serviceId": serviceId,
        "description": description,
        "summary": summary,
        "bannerImg": bannerImg,
        "content": content,
        "isForKid": isForKid,
        "type": type,
      };
}
