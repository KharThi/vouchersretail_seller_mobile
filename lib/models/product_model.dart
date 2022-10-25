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
  Price({
    this.id,
    this.priceLevelName,
    this.priceLevelId,
    this.productId,
    this.price,
  });

  int? id;
  String? priceLevelName;
  int? priceLevelId;
  int? productId;
  int? price;
  int? quantity;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        id: json["id"],
        priceLevelName: json["priceLevelName"],
        priceLevelId: json["priceLevelId"],
        productId: json["productId"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "priceLevelName": priceLevelName,
        "priceLevelId": priceLevelId,
        "productId": productId,
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
    this.prices,
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
  List<Price>? prices;

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
        description: json["description"] == null ? null : json["description"],
        summary: json["summary"],
        bannerImg: json["bannerImg"],
        content: json["content"],
        isForKid: json["isForKid"],
        type: json["type"],
        prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
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
        "description": description == null ? null : description,
        "summary": summary,
        "bannerImg": bannerImg,
        "content": content,
        "isForKid": isForKid,
        "type": type,
        "prices": List<dynamic>.from(prices!.map((x) => x.toJson())),
      };
}

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
  List<Price>? prices;
  int? productId;
  List<ComboVoucher>? vouchers;

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
        prices: json["prices"] != null
            ? List<Price>.from(json["prices"].map((x) => x))
            : List.empty(),
        productId: json["productId"],
        vouchers: List<ComboVoucher>.from(
            json["vouchers"].map((x) => ComboVoucher.fromJson(x))),
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
        "vouchers": List<dynamic>.from(vouchers!.map((x) => x.toJson())),
      };
}

List<ComboVoucher> comboVoucherFromJson(String str) => List<ComboVoucher>.from(
    json.decode(str).map((x) => ComboVoucher.fromJson(x)));

String comboVoucherToJson(List<ComboVoucher> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComboVoucher {
  ComboVoucher({
    this.id,
    this.voucherName,
    this.price,
    this.inventory,
    this.limitPerDay,
    this.isRequireProfileInfo,
    this.startDate,
    this.endDate,
    this.productId,
    this.serviceId,
  });

  int? id;
  String? voucherName;
  int? price;
  int? inventory;
  int? limitPerDay;
  bool? isRequireProfileInfo;
  String? startDate;
  String? endDate;
  int? productId;
  int? serviceId;

  factory ComboVoucher.fromJson(Map<String, dynamic> json) => ComboVoucher(
        id: json["id"],
        voucherName: json["voucherName"],
        price: json["price"],
        inventory: json["inventory"],
        limitPerDay: json["limitPerDay"],
        isRequireProfileInfo: json["isRequireProfileInfo"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        productId: json["productId"],
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
        "productId": productId,
        "serviceId": serviceId,
      };
}
