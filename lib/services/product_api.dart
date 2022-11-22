import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/utility.dart';
//PQ voucher
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductAPI {
  fetchProduct(
      {String include = '',
      bool? featured,
      int page = 1,
      int perPage = 8,
      String parent = '',
      String search = '',
      String category = ''}) async {
    String url =
        '$product?include=$include&page=$page&per_page=$perPage&parent=$parent&category=$category&status=publish';
    if (featured != null) {
      url =
          '$product?include=$include&page=$page&per_page=$perPage&parent=$parent&featured=$featured&category=$category&status=publish';
    }
    var response = await baseAPI.getAsync(url);
    return response;
  }

  fetchExtendProduct(String type) async {
    var response =
        await baseAPI.getAsync('$extendProducts?type=$type', isCustom: true);
    return response;
  }

  fetchRecentViewProducts() async {
    Map data = {"cookie": Session.data.getString('cookie')};
    var response =
        await baseAPI.postAsync('$recentProducts', data, isCustom: true);
    printLog(Session.data.getString('cookie')!);
    return response;
  }

  // hitViewProductsAPI(productId) async {
  //   Map data = {
  //     "cookie": Session.data.getString('cookie'),
  //     "product_id": productId,
  //     "ip_address": Session.data.getString('ip')
  //   };
  //   var response =
  //       await baseAPI.postAsync('$hitViewedProducts', data, isCustom: true);
  //   printLog(Session.data.getString('cookie')!);
  //   return response;
  // }

  fetchDetailProduct(String? productId) async {
    var response = await baseAPI.getAsync('$product/$productId');
    return response;
  }

  fetchDetailProductVoucher(String? productId) async {
    // var response = await baseAPI.getAsync('$product/$productId');
    // return response;
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/vouchers?ProductId=" +
                productId.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response);
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    return dataResponse["data"];
  }

  fetchDetailProductCombo(String? productId) async {
    // var response = await baseAPI.getAsync('$product/$productId');
    // return response;
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/combos?ProductId=" +
                productId.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print("object" + productId.toString());
    return dataResponse["data"];
  }

  fetchDetailProductSlug(String? slug) async {
    var response = await baseAPI.getAsync('$product/?slug=$slug');
    return response;
  }

  searchProduct({String search = '', String category = '', int? page}) async {
    // var response = await baseAPI.getAsync(
    //     '$product?search=$search&category=$category&page=$page&status=publish');
    // return response;

    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/products?Summary=" +
                search),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response.body);
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    return dataResponse["data"];
  }

  searchCustomer({String search = '', String category = '', int? page}) async {
    // var response = await baseAPI.getAsync(
    //     '$product?search=$search&category=$category&page=$page&status=publish');
    // return response;

    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/customers?UserName=" +
                search),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response.body);
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    return dataResponse["data"];
  }

  checkVariationProduct(int? productId, List<ProductVariation>? list) async {
    Map data = {"product_id": productId, "variation": list};
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$checkVariations',
      data,
      isCustom: true,
    );
    return response;
  }

  fetchBrandProduct(
      {int? page = 1,
      int perPage = 8,
      String search = '',
      String? category = '',
      String? order = 'desc',
      String? orderBy = 'popularity'}) async {
    var response = await baseAPI.getAsync(
        '$product?page=$page&per_page=$perPage&category=$category&order=$order&orderby=$orderBy&status=publish');
    return response;
  }

  reviewProduct({String productId = ''}) async {
    var response =
        await baseAPI.getAsync('$reviewProductUrl?product=$productId');
    return response;
  }

  reviewProductLimit({String productId = ''}) async {
    var response = await baseAPI
        .getAsync('$reviewProductUrl?product=$productId&per_page=1&page=1');
    return response;
  }

  fetchMoreProduct(
      {int? page = 1,
      int perPage = 8,
      String search = '',
      String? include = '',
      String category = '',
      String order = 'desc',
      String? orderBy = 'popularity'}) async {
    var response;
    if (order.isEmpty && orderBy!.isEmpty) {
      response = await baseAPI.getAsync(
          '$product?include=$include&page=$page&per_page=$perPage&category=$category&status=publish');
    } else {
      response = await baseAPI.getAsync(
          '$product?include=$include&page=$page&per_page=$perPage&category=$category&order=$order&orderby=$orderBy&status=publish');
    }

    return response;
  }

  scanProductAPI(String? code) async {
    Map data = {"code": code};
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$getBarcodeUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  productVariations({String? productId = ''}) async {
    var response = await baseAPI.getAsync('$product/$productId/variations');
    return response;
  }

  //PQ voucher

  fetchProducts() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse("https://phuquocvoucher.azurewebsites.net/api/v1/products"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    var dataResponse = await json.decode(response.body);
    // List returnData = new List.empty(growable: true);
    // returnData = dataResponse["data"];

    Iterable list = dataResponse['data'];

    final data2 = list.cast<Map<String, dynamic>>();
    final listData = data2.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    // print(dataResponse);
    return listData;
  }
}
