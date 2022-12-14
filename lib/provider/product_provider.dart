import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nyoba/models/product_extend_model.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/models/review_model.dart';
import 'package:nyoba/models/variation_model.dart';
import 'package:nyoba/services/product_api.dart';
import 'package:nyoba/services/review_api.dart';
import 'package:nyoba/services/voucher_api.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  bool loadingFeatured = false;
  bool loadingNew = false;

  bool loadingExtends = true;
  bool loadingSpecial = true;
  bool loadingBest = true;
  bool loadingRecommendation = true;
  bool loadingDetail = true;
  bool loadingCategory = false;
  bool loadingBrand = false;
  bool loadingMore = true;

  bool loadingReview = false;
  bool loadAddReview = false;
  bool loadingRecent = false;

  String? message;

  List<Voucher> listFeaturedProduct = [];
  List<ProductModel> listMoreFeaturedProduct = [];

  List<ProductModel> listNewProduct = [];
  List<ProductModel> listMoreNewProduct = [];

  List<ProductModel> listSpecialProduct = [];
  List<ProductModel> listMoreSpecialProduct = [];

  List<ProductModel> listBestProduct = [];
  List<ProductModel> listRecentProduct = [];
  List<ProductModel> listRecommendationProduct = [];
  List<ProductModel> listCategoryProduct = [];
  List<ProductModel> listBrandProduct = [];

  List<ProductModel> listMoreExtendProduct = [];
  List<ProductModel> listTempProduct = [];

  List<ReviewHistoryModel> listReviewLimit = [];

  late ProductExtendModel productSpecial;
  late ProductExtendModel productBest;
  late ProductExtendModel productRecommendation;

  String? productRecent;

  ProductModel? productDetail;

  Voucher? voucherDetail;
  Combo? comboDetail;

  // Combo? comboDetail;

  ProductProvider() {
    fetchFeaturedProducts();
    fetchExtendProducts('our_best_seller');
    fetchExtendProducts('special');
    fetchExtendProducts('recomendation');
  }

  Future<bool> fetchFeaturedProducts({int page = 1}) async {
    loadingFeatured = true;

    await VoucherAPI().fetchVoucher("", "3", "").then((data) {
      listFeaturedProduct = data;
      loadingFeatured = false;
      notifyListeners();
      // if (data.statusCode == 200) {
      //   final responseJson = json.decode(data.body);

      //   listTempProduct.clear();
      //   if (page == 1) {
      //     listFeaturedProduct.clear();
      //     listMoreFeaturedProduct.clear();
      //   }
      //   for (Map item in responseJson) {
      //     if (page == 1) {
      //       listTempProduct.add(ProductModel.fromJson(item));
      //     } else {
      //       listTempProduct.add(ProductModel.fromJson(item));
      //     }
      //   }

      //   loadVariationData(listProduct: listTempProduct, load: loadingFeatured)
      //       .then((value) {
      //     listTempProduct.forEach((element) {
      //       listFeaturedProduct.add(element);
      //       listMoreFeaturedProduct.add(element);
      //     });
      //     loadingFeatured = false;
      //     notifyListeners();
      //   });
      // } else {
      //   loadingFeatured = false;
      //   notifyListeners();
      // }
    });
    return true;
  }

  Future<bool> fetchNewProducts(String category, {int page = 1}) async {
    loadingNew = true;
    await ProductAPI()
        .fetchProduct(category: category, page: page)
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        if (page == 1) {
          listNewProduct.clear();
          listMoreNewProduct.clear();
        }
        for (Map item in responseJson) {
          if (page == 1) {
            listNewProduct.add(ProductModel.fromJson(item));
            listMoreNewProduct.add(ProductModel.fromJson(item));
          } else {
            listMoreNewProduct.add(ProductModel.fromJson(item));
          }
        }
        loadVariationData(listProduct: listNewProduct, load: loadingNew)
            .then((value) {
          loadingNew = false;
          notifyListeners();
        });
      } else {
        loadingNew = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchExtendProducts(type) async {
    await ProductAPI().fetchExtendProduct(type).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          if (type == 'our_best_seller') {
            productBest = ProductExtendModel.fromJson(item);
          } else if (type == 'special') {
            productSpecial = ProductExtendModel.fromJson(item);
          } else if (type == 'recomendation') {
            productRecommendation = ProductExtendModel.fromJson(item);
          }
        }
        notifyListeners();
      } else {
        notifyListeners();
        print("Load Extend Failed");
      }
    });
    return true;
  }

  Future<bool> fetchSpecialProducts(String productId) async {
    await ProductAPI().fetchProduct(include: productId).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);
        // printLog(responseJson.toString(), name: 'Special Product');

        listSpecialProduct.clear();
        for (Map item in responseJson) {
          listSpecialProduct.add(ProductModel.fromJson(item));
        }
        loadingSpecial = false;
        notifyListeners();
      } else {
        print("Load Special Failed");
        loadingSpecial = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchBestProducts(String productId) async {
    await ProductAPI().fetchProduct(include: productId).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        // printLog(responseJson.toString(), name: 'Best Product');
        listBestProduct.clear();
        for (Map item in responseJson) {
          listBestProduct.add(ProductModel.fromJson(item));
        }
        loadingBest = false;
        notifyListeners();
      } else {
        print("Load Best Failed");
        loadingBest = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchRecentProducts() async {
    await ProductAPI().fetchRecentViewProducts().then((data) {
      if (data["products"].toString().isNotEmpty) {
        productRecent = data["products"];
        this.fetchListRecentProducts(productRecent);
      }
      notifyListeners();
    });
    return true;
  }

  Future<bool> fetchListRecentProducts(productId) async {
    await ProductAPI()
        .fetchMoreProduct(
            include: productId, order: 'desc', orderBy: 'popularity')
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        listRecentProduct.clear();
        for (Map item in responseJson) {
          listRecentProduct.add(ProductModel.fromJson(item));
        }

        loadVariationData(listProduct: listRecentProduct, load: loadingRecent)
            .then((value) {
          loadingRecent = false;
          notifyListeners();
        });
      } else {
        print("Load Recent Failed");
        loadingRecent = false;
        notifyListeners();
      }
    });
    return true;
  }

  // Future<bool> hitViewProducts(productId) async {
  //   await ProductAPI().hitViewProductsAPI(productId).then((data) {
  //     notifyListeners();
  //   });
  //   return true;
  // }

  Future<bool> fetchRecommendationProducts(String productId) async {
    await ProductAPI().fetchProduct(include: productId).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        listRecommendationProduct.clear();
        for (Map item in responseJson) {
          listRecommendationProduct.add(ProductModel.fromJson(item));
        }
        loadingRecommendation = false;
        notifyListeners();
      } else {
        print("Load Failed");
        loadingRecommendation = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<Voucher?> fetchProductDetail(String? productId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/vouchers?Id=" +
                productId.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response.body);
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    return dataResponse["data"];
  }

  Future<Voucher?> fetchProductDetailVoucher(String? productId) async {
    loadingDetail = true;
    await ProductAPI().fetchDetailProductVoucher(productId).then((data) {
      // if (data.statusCode == 200) {
      print(data);
      // final responseJson = json.decode(data);

      voucherDetail = Voucher.fromJson(data[0]);

      loadingDetail = false;
      notifyListeners();
      // } else {
      //   print("Load Failed");
      //   loadingDetail = false;
      //   notifyListeners();
      // }
    });
    return voucherDetail;
  }

  Future<Combo?> fetchProductDetailCombo(String? productId) async {
    loadingDetail = true;
    await ProductAPI().fetchDetailProductCombo(productId).then((data) {
      // if (data.statusCode == 200) {
      print(data);
      // final responseJson = json.decode(data);

      comboDetail = Combo.fromJson(data);

      loadingDetail = false;
      notifyListeners();
      // } else {
      //   print("Load Failed");
      //   loadingDetail = false;
      //   notifyListeners();
      // }
    });
    return comboDetail;
  }

  // Future<Combo?> fetchProductDetailCombo(String? productId) async {
  //   loadingDetail = true;
  //   await ProductAPI().fetchDetailProductCombo(productId).then((data) {
  //     // if (data.statusCode == 200) {
  //     print("Responsedata:" + data.toString());
  //     // final responseJson = json.decode(data);

  //     comboDetail = Combo.fromJson(data[0]);

  //     loadingDetail = false;
  //     notifyListeners();
  //     // } else {
  //     //   print("Load Failed");
  //     //   loadingDetail = false;
  //     //   notifyListeners();
  //     // }
  //   });
  //   return comboDetail;
  // }

  Future<ProductModel?> fetchProductDetailSlug(String? slug) async {
    loadingDetail = true;
    await ProductAPI().fetchDetailProductSlug(slug).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          productDetail = ProductModel.fromJson(item);
        }

        notifyListeners();
      } else {
        print("Load Failed");
        notifyListeners();
      }
    });
    return productDetail;
  }

  Future<Map<String, dynamic>?> checkVariation({productId, list}) async {
    var result;
    await ProductAPI().checkVariationProduct(productId, list).then((data) {
      result = data;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<bool> fetchCategoryProduct(String category) async {
    loadingCategory = true;
    await ProductAPI().fetchProduct(category: category).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        listCategoryProduct.clear();
        for (Map item in responseJson) {
          listCategoryProduct.add(ProductModel.fromJson(item));
        }

        loadVariationData(
                listProduct: listCategoryProduct, load: loadingCategory)
            .then((value) {
          loadingCategory = false;
          notifyListeners();
        });
      } else {
        loadingCategory = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchBrandProduct(
      {String? category, int? page, String? order, String? orderBy}) async {
    loadingBrand = true;
    await ProductAPI()
        .fetchBrandProduct(
            category: category, order: order, orderBy: orderBy, page: page)
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        listTempProduct.clear();
        if (page == 1) {
          listBrandProduct.clear();
        }
        for (Map item in responseJson) {
          listTempProduct.add(ProductModel.fromJson(item));
        }

        loadVariationData(listProduct: listTempProduct, load: loadingBrand)
            .then((value) {
          listTempProduct.forEach((element) {
            listBrandProduct.add(element);
          });
          loadingBrand = false;
          notifyListeners();
        });
      } else {
        loadingBrand = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<Map<String, dynamic>?> addReview(context,
      {productId, review, rating}) async {
    loadAddReview = !loadAddReview;
    var result;

    await ReviewAPI().inputReview(productId, review, rating).then((data) {
      result = data;
      printLog(result.toString());

      if (result['status'] == 'success') {
        var _ratingCountTemp = (productDetail!.ratingCount! + 1);
        var _avgTemp = ((double.parse(productDetail!.avgRating!) *
                    productDetail!.ratingCount!) +
                rating) /
            _ratingCountTemp;

        productDetail!.ratingCount = _ratingCountTemp;
        productDetail!.avgRating = _avgTemp.toStringAsFixed(2);

        loadAddReview = !loadAddReview;

        snackBar(context, message: 'Successfully add your product review');
      } else {
        loadAddReview = !loadAddReview;

        snackBar(context, message: 'Error, ${result['message']}');
      }

      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<bool> fetchMoreExtendProduct(String? productId,
      {int? page, required String order, String? orderBy}) async {
    loadingMore = true;
    await ProductAPI()
        .fetchMoreProduct(
            include: productId, page: page, order: order, orderBy: orderBy)
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        listTempProduct.clear();
        if (page == 1) {
          listMoreExtendProduct.clear();
        }
        for (Map item in responseJson) {
          listTempProduct.add(ProductModel.fromJson(item));
        }

        loadVariationData(load: loadingMore, listProduct: listTempProduct)
            .then((value) {
          listTempProduct.forEach((element) {
            listMoreExtendProduct.add(element);
          });
          loadingMore = false;
          notifyListeners();
        });
      } else {
        print("Load Failed");
        loadingMore = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<VariationModel?> fetchProductVariations(String productId) async {
    loadingDetail = true;
    VariationModel? variations;
    try {
      await ProductAPI().productVariations(productId: productId).then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);

          for (Map item in responseJson) {
            variations = VariationModel.fromJson(item);
          }

          notifyListeners();
        } else {
          print("Load Failed");
          notifyListeners();
        }
      });
      return variations;
    } catch (e) {
      print("Load Failed");
      notifyListeners();
      return variations;
    }
  }

  Future<bool?> loadVariationData(
      {required List<ProductModel> listProduct, bool? load}) async {
    listProduct.forEach((element) async {
      if (element.type == 'variable') {
        List<VariationModel> variations = [];
        await ProductAPI()
            .productVariations(productId: element.id.toString())
            .then((value) {
          if (value.statusCode == 200) {
            final variation = json.decode(value.body);

            for (Map item in variation) {
              if (item['price'].isNotEmpty) {
                variations.add(VariationModel.fromJson(item));
              }
            }

            variations.forEach((v) {
              /*printLog('${element.productName} ${v.id} ${v.price}',
                  name: 'Price Variation 2');*/
              element.variationPrices!.add(double.parse(v.price!));
            });

            element.variationPrices!.sort((a, b) => a!.compareTo(b!));
          }
          load = false;
          notifyListeners();
        });
      } else {
        load = false;
        notifyListeners();
      }
    });
    return load;
  }
}
