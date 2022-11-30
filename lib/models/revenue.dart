// To parse this JSON data, do
//
//     final revenue = revenueFromJson(jsonString);

import 'dart:convert';

List<Revenue> revenueFromJson(String str) =>
    List<Revenue>.from(json.decode(str).map((x) => Revenue.fromJson(x)));

String revenueToJson(List<Revenue> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Revenue {
  Revenue({
    this.month,
    this.revenues,
    this.order,
    this.customer,
  });

  int? month;
  var revenues;
  int? order;
  int? customer;

  factory Revenue.fromJson(Map<String, dynamic> json) => Revenue(
        month: json["month"],
        revenues: json["revenues"],
        order: json["order"],
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "revenues": revenues,
        "order": order,
        "customer": customer,
      };
}
