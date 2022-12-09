import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/utility.dart';
//PQ voucher
import 'dart:convert';

class ProductModel {
  int? id, productStock, ratingCount, cartQuantity, variantId;
  double? discProduct, priceTotal;
  String? productName,
      productSlug,
      productDescription,
      productShortDesc,
      productSku,
      formattedPrice,
      formattedSalesPrice,
      avgRating,
      link,
      stockStatus,
      type;
  var productPrice, productRegPrice, productSalePrice, totalSales;
  bool? isSelected = false;
  bool isProductWholeSale = false;
  bool? manageStock = false;
  List<ProductImageModel>? images;
  List<ProductCategoryModel>? categories;
  List<ProductAttributeModel>? attributes;
  List<ProductMetaData>? metaData;
  List<ProductVideo>? videos;
  List<ProductVariation>? selectedVariation = [];
  String? variationName;
  List<double?>? variationPrices = [];

  ProductModel(
      {this.id,
      this.totalSales,
      this.productStock,
      this.productName,
      this.productSlug,
      this.productDescription,
      this.productShortDesc,
      this.productSku,
      this.productPrice,
      this.productRegPrice,
      this.productSalePrice,
      this.images,
      this.categories,
      this.ratingCount,
      this.avgRating,
      this.discProduct,
      this.attributes,
      this.cartQuantity,
      this.isSelected,
      this.priceTotal,
      this.variantId,
      this.link,
      this.metaData,
      this.videos,
      this.stockStatus,
      this.type,
      this.selectedVariation,
      this.variationName,
      this.variationPrices});

  Map toJson() => {
        'id': id,
        'total_sales': totalSales,
        'stock_quantity': productStock,
        'name': productName,
        'slug': productSlug,
        'description': productDescription,
        'short_description': productShortDesc,
        'formated_price': formattedPrice,
        'formated_sales_price': formattedSalesPrice,
        'sku': productSku,
        'price': productPrice,
        'regular_price': productRegPrice,
        'sale_price': productSalePrice,
        'images': images,
        'categories': categories,
        'average_rating': avgRating,
        'rating_count': ratingCount,
        'attributes': attributes,
        'disc': discProduct,
        'cart_quantity': cartQuantity,
        'is_selected': isSelected,
        'price_total': priceTotal,
        'variant_id': variantId,
        'permalink': link,
        'meta_data': metaData,
        'videos': videos,
        'manage_stock': manageStock,
        'stock_status': stockStatus,
        'type': type,
        'selected_variation': selectedVariation,
        'variation_name': variationName,
        'variation_prices': variationPrices
      };

  ProductModel.fromJson(Map json) {
    id = json['id'];
    totalSales = json['total_sales'];
    productStock =
        json['manage_stock'] == false ? 999 : json['stock_quantity'] ?? 0;
    stockStatus = json['stock_status'];
    productName = convertHtmlUnescape(json['name']);
    productSlug = json['slug'];
    productDescription = json['description'];
    productShortDesc = json['short_description'];
    productSku = json['sku'];
    link = json['permalink'];
    manageStock = json['manage_stock'];
    type = json['type'];
    productPrice = json['price'] != null && json['price'] != ''
        ? json['price'].toString()
        : '0';
    productRegPrice =
        json['regular_price'] != null && json['regular_price'] != ''
            ? json['regular_price'].toString()
            : '0';
    productSalePrice = json['sale_price'] != null && json['sale_price'] != ''
        ? json['sale_price'].toString()
        : '';
    avgRating = json['average_rating'];
    ratingCount = json['rating_count'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(new ProductImageModel.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(new ProductCategoryModel.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = [];
      json['attributes'].forEach((v) {
        attributes!.add(new ProductAttributeModel.fromJson(v));
      });
    }
    cartQuantity = json['cart_quantity'];
    discProduct = productSalePrice.isNotEmpty && productSalePrice != "0"
        ? discProduct =
            ((double.parse(productRegPrice) - double.parse(productSalePrice)) /
                    double.parse(productRegPrice)) *
                100
        : discProduct = 0;
    isSelected = json['is_selected'];
    priceTotal = json['price_total'];
    variantId = json['variant_id'];
    if (json['meta_data'] != null) {
      metaData = [];
      videos = [];
      json['meta_data'].forEach((v) {
        metaData!.add(new ProductMetaData.fromJson(v));
        if (v['key'] == 'wholesale_customer_have_wholesale_price' &&
            v['value'] == 'yes') {
          isProductWholeSale = true;
        }
        if (v['key'] == '_ywcfav_video') {
          v['value'].forEach((valVideo) {
            videos!.add(new ProductVideo.fromJson(valVideo));
          });
        }
      });
    }
    if (isProductWholeSale &&
        Session.data.getString('role') == 'wholesale_customer') {
      metaData!.forEach((element) {
        if (element.key == 'wholesale_customer_wholesale_price' &&
            element.value.toString().isNotEmpty) {
          discProduct = 0;
          productSalePrice = "0";
          productRegPrice = "0";
          productPrice = element.value;
        }
      });
    }
    if (json['selected_variation'] != null) {
      selectedVariation = [];
      json['selected_variation'].forEach((v) {
        selectedVariation!.add(new ProductVariation.fromJson(v));
      });
    }
    if (json['variation_name'] != null) {
      variationName = json['variation_name'];
    }
    if (json['availableVariations'] != null) {
      json['availableVariations'].forEach((v) {
        variationPrices!.add(v['display_price'].toDouble());
      });
      variationPrices!.sort((a, b) => a!.compareTo(b!));
    }
    if (isProductWholeSale &&
        Session.data.getString('role') == 'wholesale_customer') {
      if (json['wholesales'] != null) {
        if (type == 'simple') {
          variationPrices!.clear();
          json['wholesales'].forEach((v) {
            variationPrices!.add(double.parse(v['price']));
          });
          variationPrices!.sort((a, b) => a!.compareTo(b!));
        }
      }
    }
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, totalSales: $totalSales, productStock: $productStock, ratingCount: $ratingCount, cartQuantity: $cartQuantity, priceTotal: $priceTotal, variantId: $variantId, discProduct: $discProduct, productName: $productName, productSlug: $productSlug, productDescription: $productDescription, productShortDesc: $productShortDesc, productSku: $productSku, productPrice: $productPrice, productRegPrice: $productRegPrice, productSalePrice: $productSalePrice, avgRating: $avgRating, link: $link, isSelected: $isSelected, images: $images, categories: $categories, attributes: $attributes}';
  }
}

class ProductImageModel {
  int? id;
  String? dateCreated, dateModified, src, name, alt;

  ProductImageModel(
      {this.dateCreated,
      this.dateModified,
      this.src,
      this.name,
      this.alt,
      this.id});

  Map toJson() => {
        'id': id,
        'date_created': dateCreated,
        'date_modified': dateModified,
        'src': src,
        'name': name,
        'alt': alt,
      };

  ProductImageModel.fromJson(Map json)
      : id = json['id'],
        dateCreated = json['date_created'],
        dateModified = json['date_modified'],
        src = json['src'],
        name = json['name'],
        alt = json['alt'];
}

class ProductCategoryModel {
  int? id;
  String? name, slug;
  var image;

  ProductCategoryModel({this.slug, this.name, this.id, this.image});

  Map toJson() => {'id': id, 'name': name, 'slug': slug, 'image': image};

  ProductCategoryModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    if (json['image'] != null && json['image'] != '') {
      if (json['image'] != false && json['image']['src'] != false) {
        image = json['image']['src'];
      }
    }
  }
}

class ProductAttributeModel {
  int? id, position;
  String? name, selectedVariant;
  bool? visible, variation;
  List<dynamic>? options;

  ProductAttributeModel(
      {this.id,
      this.position,
      this.name,
      this.visible,
      this.variation,
      this.options,
      this.selectedVariant});

  Map toJson() => {
        'id': id,
        'position': position,
        'name': name,
        'visible': visible,
        'variation': variation,
        'options': options,
        'selected_variant': selectedVariant
      };

  ProductAttributeModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        position = json['position'],
        visible = json['visible'],
        variation = json['variation'],
        options = json['options'],
        selectedVariant = json['selected_variant'];
}

class ProductVariation {
  int? id;
  String? columnName;
  String? value;

  ProductVariation({this.id, this.value, this.columnName});

  Map toJson() => {
        'id': id,
        'column_name': columnName,
        'value': value,
      };

  ProductVariation.fromJson(Map json)
      : id = json['id'],
        columnName = json['column_name'],
        value = json['value'];

  @override
  String toString() {
    return 'ProductVariation{columnName: $columnName, value: $value}';
  }
}

class ProductMetaData {
  int? id;
  String? key;
  var value;

  ProductMetaData({this.id, this.key, this.value});

  Map toJson() => {
        'id': id,
        'key': key,
        'value': value,
      };

  ProductMetaData.fromJson(Map json)
      : id = json['id'],
        key = json['key'],
        value = json['value'];
}

class ProductVideo {
  String? thumbnail, id, type, featured, name, host, content;

  ProductVideo(
      {this.thumbnail,
      this.id,
      this.type,
      this.featured,
      this.name,
      this.host,
      this.content});

  Map toJson() => {
        'thumbnail': thumbnail,
        'id': id,
        'type': type,
        'featured': featured,
        'name': name,
        'host': host,
        'content': content,
      };

  ProductVideo.fromJson(Map json)
      : thumbnail = json['thumbn'],
        id = json['id'],
        type = json['type'],
        featured = json['featured'],
        name = json['name'],
        host = json['host'],
        content = json['content'];
}

//PQ vouvher

// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.id,
    this.description,
    this.summary,
    this.bannerImg,
    this.content,
    this.isForKid,
    this.type,
    this.prices,
  });

  int? id;
  String? description;
  String? summary;
  String? bannerImg;
  String? content;
  bool? isForKid;
  String? type;
  List<Price>? prices;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        description: json["description"],
        summary: json["summary"],
        bannerImg: json["bannerImg"],
        content: json["content"],
        isForKid: json["isForKid"],
        type: json["type"],
        prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "summary": summary,
        "bannerImg": bannerImg,
        "content": content,
        "isForKid": isForKid,
        "type": type,
        "prices": List<dynamic>.from(prices!.map((x) => x.toJson())),
      };
}

class Price {
  Price({this.id, this.priceLevelName, this.price, this.isDefault});

  int? id;
  String? priceLevelName;
  var price;
  int? quantity;
  bool? isDefault;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        id: json["id"],
        priceLevelName: json["priceLevelName"],
        isDefault: json["isDefault"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "priceLevelName": priceLevelName,
        "isDefault": isDefault,
        "price": price,
      };
}

List<Voucher> voucherFromJson(String str) =>
    List<Voucher>.from(json.decode(str).map((x) => Voucher.fromJson(x)));

String voucherToJson(List<Voucher> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Voucher {
  Voucher({
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
    this.soldNumber,
    this.voucherValue,
    this.revenue,
    this.bannerImg,
    this.content,
    this.soldPrice,
    this.isCombo,
    this.service,
    this.serviceType,
    this.provider,
    this.tags,
    this.reviews,
    this.status,
    this.createAt,
    this.updateAt,
    this.deleteAt,
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
  String? socialPost;
  int? inventory;
  int? soldNumber;
  int? voucherValue;
  int? revenue;
  String? bannerImg;
  String? content;
  int? soldPrice;
  bool? isCombo;
  Service? service;
  ServiceType? serviceType;
  ProviderForVoucher? provider;
  List<ServiceType>? tags;
  List<dynamic>? reviews;
  String? status;
  String? createAt;
  String? updateAt;
  dynamic deleteAt;

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["id"],
        voucherName: json["voucherName"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        serviceId: json["serviceId"] == null ? null : json["serviceId"],
        serviceTypeId: json["serviceTypeId"],
        providerId: json["providerId"] == null ? null : json["providerId"],
        description: json["description"],
        summary: json["summary"],
        socialPost: json["socialPost"] == null ? null : json["socialPost"],
        inventory: json["inventory"],
        soldNumber: json["soldNumber"],
        voucherValue: json["voucherValue"],
        revenue: json["revenue"],
        bannerImg: json["bannerImg"],
        content: json["content"],
        soldPrice: json["soldPrice"],
        isCombo: json["isCombo"],
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        serviceType: json["serviceType"] == null
            ? null
            : ServiceType.fromJson(json["serviceType"]),
        provider: json["provider"] == null
            ? null
            : ProviderForVoucher.fromJson(json["provider"]),
        tags: json["tags"] != null
            ? List<ServiceType>.from(
                json["tags"].map((x) => ServiceType.fromJson(x)))
            : null,
        reviews: json["reviews"] != null
            ? List<dynamic>.from(json["reviews"].map((x) => x))
            : null,
        status: json["status"],
        createAt: json["createAt"],
        updateAt: json["updateAt"] == null ? null : json["updateAt"],
        deleteAt: json["deleteAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voucherName": voucherName,
        "startDate": startDate,
        "endDate": endDate,
        "serviceId": serviceId == null ? null : serviceId,
        "serviceTypeId": serviceTypeId,
        "providerId": providerId == null ? null : providerId,
        "description": description,
        "summary": summary,
        "socialPost": socialPost == null ? null : socialPost,
        "inventory": inventory,
        "soldNumber": soldNumber,
        "voucherValue": voucherValue,
        "revenue": revenue,
        "bannerImg": bannerImg,
        "content": content,
        "soldPrice": soldPrice,
        "isCombo": isCombo,
        "service": service == null ? null : service!.toJson(),
        "serviceType": serviceType == null ? null : serviceType!.toJson(),
        "provider": provider == null ? null : provider!.toJson(),
        "tags": List<dynamic>.from(tags!.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews!.map((x) => x)),
        "status": status,
        "createAt": createAt,
        "updateAt": updateAt == null ? null : updateAt,
        "deleteAt": deleteAt,
      };
}

class ProviderForVoucher {
  ProviderForVoucher({
    this.id,
    this.providerName,
    this.address,
    this.taxCode,
    this.userInfo,
    this.status,
  });

  int? id;
  String? providerName;
  dynamic address;
  dynamic taxCode;
  UserInfo? userInfo;
  String? status;

  factory ProviderForVoucher.fromJson(Map<String, dynamic> json) =>
      ProviderForVoucher(
        id: json["id"],
        providerName: json["providerName"],
        address: json["address"],
        taxCode: json["taxCode"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "providerName": providerName,
        "address": address,
        "taxCode": taxCode,
        "userInfo": userInfo!.toJson(),
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
  dynamic createAt;
  dynamic updateAt;
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
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}

class Service {
  Service({
    this.id,
    this.name,
    this.description,
    this.typeId,
    this.type,
    this.locationName,
    this.serviceLocationId,
    this.commissionRate,
    this.providerName,
    this.providerId,
    this.status,
    this.createAt,
    this.updateAt,
    this.deleteAt,
  });

  int? id;
  String? name;
  String? description;
  dynamic typeId;
  dynamic type;
  dynamic locationName;
  int? serviceLocationId;
  int? commissionRate;
  dynamic providerName;
  int? providerId;
  String? status;
  String? createAt;
  dynamic updateAt;
  dynamic deleteAt;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        typeId: json["typeId"],
        type: json["type"],
        locationName: json["locationName"],
        serviceLocationId: json["serviceLocationId"],
        commissionRate: json["commissionRate"],
        providerName: json["providerName"],
        providerId: json["providerId"],
        status: json["status"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "typeId": typeId,
        "type": type,
        "locationName": locationName,
        "serviceLocationId": serviceLocationId,
        "commissionRate": commissionRate,
        "providerName": providerName,
        "providerId": providerId,
        "status": status,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
      };
}

class ServiceType {
  ServiceType({
    this.id,
    this.name,
    this.defaultCommissionRate,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  String? name;
  double? defaultCommissionRate;
  String? createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
        id: json["id"],
        name: json["name"],
        defaultCommissionRate: json["defaultCommissionRate"] == null
            ? null
            : json["defaultCommissionRate"].toDouble(),
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "defaultCommissionRate":
            defaultCommissionRate == null ? null : defaultCommissionRate,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}

List<Combo> comboFromJson(String str) =>
    List<Combo>.from(json.decode(str).map((x) => Combo.fromJson(x)));

String comboToJson(List<Combo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Combo {
  Combo({
    this.id,
    this.voucherName,
    this.startDate,
    this.endDate,
    this.serviceId,
    this.serviceTypeId,
    this.providerId,
    this.description,
    this.summary,
    this.inventory,
    this.bannerImg,
    this.content,
    this.socialPost,
    this.soldPrice,
    this.isCombo,
    this.tags,
    this.reviews,
    this.vouchers,
    this.status,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.voucherValue,
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
  int? inventory;
  String? bannerImg;
  String? content;
  String? socialPost;
  int? soldPrice;
  bool? isCombo;
  List<Tag>? tags;
  List<dynamic>? reviews;
  List<Voucher>? vouchers;
  String? status;
  String? createAt;
  String? updateAt;
  dynamic deleteAt;
  int? voucherValue;

  factory Combo.fromJson(Map<String, dynamic> json) => Combo(
        id: json["id"],
        voucherName: json["voucherName"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        serviceId: json["serviceId"] == null ? null : json["serviceId"],
        serviceTypeId: json["serviceTypeId"],
        providerId: json["providerId"] == null ? null : json["providerId"],
        description: json["description"],
        summary: json["summary"],
        inventory: json["inventory"],
        bannerImg: json["bannerImg"],
        content: json["content"],
        socialPost: json["socialPost"] == null ? null : json["socialPost"],
        soldPrice: json["soldPrice"],
        isCombo: json["isCombo"],
        tags: json["tags"] == null
            ? null
            : List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
        vouchers: json["vouchers"] == null
            ? null
            : List<Voucher>.from(
                json["vouchers"].map((x) => Voucher.fromJson(x))),
        status: json["status"],
        createAt: json["createAt"],
        updateAt: json["updateAt"] == null ? null : json["updateAt"],
        deleteAt: json["deleteAt"],
        voucherValue:
            json["voucherValue"] == null ? null : json["voucherValue"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voucherName": voucherName,
        "startDate": startDate,
        "endDate": endDate,
        "serviceId": serviceId == null ? null : serviceId,
        "serviceTypeId": serviceTypeId,
        "providerId": providerId == null ? null : providerId,
        "description": description,
        "summary": summary,
        "inventory": inventory,
        "bannerImg": bannerImg,
        "content": content,
        "socialPost": socialPost == null ? null : socialPost,
        "soldPrice": soldPrice,
        "isCombo": isCombo,
        "tags": tags == null
            ? null
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "reviews":
            reviews == null ? null : List<dynamic>.from(reviews!.map((x) => x)),
        "vouchers": vouchers == null
            ? null
            : List<dynamic>.from(vouchers!.map((x) => x.toJson())),
        "status": status,
        "createAt": createAt,
        "updateAt": updateAt == null ? null : updateAt,
        "deleteAt": deleteAt,
        "voucherValue": voucherValue == null ? null : voucherValue,
      };
}

class Tag {
  Tag({
    this.id,
    this.name,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.status,
  });

  int? id;
  String? name;
  String? createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String? status;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        deleteAt: json["deleteAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createAt": createAt,
        "updateAt": updateAt,
        "deleteAt": deleteAt,
        "status": status,
      };
}
