import 'dart:convert';

import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/models/cart.dart';
import 'package:nyoba/models/customer.dart';
import 'package:nyoba/models/order.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class OrderAPI {
  checkoutOrder(order) async {
    var response =
        await baseAPI.getAsync('$orderApi?order=$order', isOrder: true);
    return response;
  }

  checkoutOrderV2(order) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.post(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/order"),
        body: order,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(response.body);
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print(dataResponse.toString());
    return dataResponse["data"];
  }

  getCartByCustomerId(int customerId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
                customerId.toString() +
                "/cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print("https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
        customerId.toString() +
        "/cart");
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print(dataResponse.toString());
    Cart cart = Cart.fromJson(dataResponse);
    return cart;
  }

  addCartItem(Customer customer, String date, List<Price> listPrice) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    int? check;

    for (var element in listPrice) {
      Map customerData = {
        "status": "Active",
        "quantity": element.quantity,
        "priceId": element.id,
        "useDate": date,
        "profileId": customer.profiles!.first.id
      };
      // sendData.add(customerData);

      var body = json.encode(customerData);
      print("CustomerData" + body.toString());

      var response = await http.post(
          Uri.parse(
              "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
                  customer.id.toString() +
                  "/cart/items"),
          body: body,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + jwt.toString()
          });
      Map<String, dynamic> dataResponse = await json.decode(response.body);
      print("response" + response.body);
      print("CustomerId" + (dataResponse["customerId"] != 0).toString());
      if (dataResponse["customerId"] != 0) {
        check = dataResponse["customerId"];
        print(check.toString());
      } else {
        check = 0;
      }
    }
    return check;
  }

  addCartItemForBuyNow(
      Customer customer, String date, List<Price> listPrice) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    bool check = true;

    for (var element in listPrice) {
      Map customerData = {
        "status": "Active",
        "quantity": element.quantity,
        "priceId": element.id,
        "useDate": date,
        "profileId": customer.userInfoId
      };
      // sendData.add(customerData);

      var body = json.encode(customerData);
      print("CustomerData" + body.toString());

      var response = await http.post(
          Uri.parse(
              "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
                  customer.id.toString() +
                  "/cart/items"),
          body: body,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + jwt.toString()
          });
      Map<String, dynamic> dataResponse = await json.decode(response.body);
      print("response" + response.body);
      if (dataResponse["id"] == null) {
        check = false;
        return dataResponse["id"];
      }
    }
    // var body = json.encode(sendData);

    // var response = await http.post(
    //     Uri.parse(
    //         "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
    //             customerId.toString() +
    //             "/cart/items"),
    //     body: body,
    //     headers: {
    //       "Content-Type": "application/json",
    //       "Authorization": "Bearer " + jwt.toString()
    //     });
    // print("addCartItem Link api " +
    //     "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
    //     customerId.toString() +
    //     "/cart/items");

    // print("addCartItem in orderApi" + dataResponse.toString());
    return null;
  }

  updateCart(int customerId, Cart cart) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    List<Map<dynamic, dynamic>> customerData = List.empty(growable: true);

    for (var element in cart.cartItems!) {
      if (element.isChange!) {
        customerData
            .add({"quantity": element.quantity, "cartItemId": element.id});
      }
    }
    var body = json.encode(customerData);

    var response = await http.put(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
                customerId.toString() +
                "/cart/items"),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print("updateCart in orderApi" + dataResponse.toString());
    return dataResponse;
  }

  cancelOrder(int orderId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    List<Map<dynamic, dynamic>> customerData = List.empty(growable: true);

    var body = json.encode(customerData);

    var response = await http.put(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/orders/" +
                orderId.toString() +
                "/cancel"),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print("cancel order in orderApi" + dataResponse.toString());
    return dataResponse;
  }

  removeCartItem(int customerId, int cartItemId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.delete(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
                customerId.toString() +
                "/cart/items/" +
                cartItemId.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print("removeCartItem in orderApi" + dataResponse.toString());
    return dataResponse;
  }

  sendEmailToCustomer(int orderId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse("https://phuquocvoucher.azurewebsites.net/api/v1/orders/" +
            orderId.toString() +
            "/send-email"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    // Map<String, dynamic> dataResponse = await json.decode(response.body);
    bool check = response.statusCode == 200;
    // print("sendIdToCustomer in orderApi" + dataResponse.toString());
    return check;
  }

  placeOrder(int customerId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    List<String> result = List.empty(growable: true);
    var response = await http.post(
        Uri.parse(
            "https://phuquocvoucher.azurewebsites.net/api/v1/sellers/customers/" +
                customerId.toString() +
                "/place-order"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    // print(response.body);
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    if (dataResponse["id"].toString() != null ||
        dataResponse["id"].toString() != "") {
      result.add(dataResponse["id"].toString());
      print("https://phuquocvoucher.azurewebsites.net/api/v1/payment/momo/" +
          dataResponse["id"].toString());
      var response2 = await http.get(
          Uri.parse(
              "https://phuquocvoucher.azurewebsites.net/api/v1/payment/momo/" +
                  dataResponse["id"].toString()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + jwt.toString()
          });
      print(response2.body);
      Map<String, dynamic> dataResponse2 = await json.decode(response2.body);
      if (dataResponse2["payUrl"] != null || dataResponse2["payUrl"] != "") {
        result.add(dataResponse2["payUrl"].toString());
        return result;
      }
    }
    // Map<String, dynamic> dataResponse = await json.decode(response.body);
    // print(dataResponse.toString());
    // Map<String, dynamic> dataResponse2 = await json.decode(response.body);
    // print(dataResponse2.toString());
    return null;
  }

  listMyOrder(
      String? status, String? search, String? orderId, int? page) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "status": status,
      "search": search,
      "page": page,
      if (orderId != null) "order_id": orderId
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$listOrders',
      data,
      isCustom: true,
    );
    return response;
  }

  getListOrder(String orderStatus) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    int? sellerId = data.getInt("id");
    print("jwt " + jwt.toString());

    var response = await http.get(
        Uri.parse("https://phuquocvoucher.azurewebsites.net/api/v1/orders" +
            "?OrderStatus=" +
            orderStatus +
            "&SellerId=" +
            sellerId.toString() +
            "&PageSize=1000&orderBy=id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print("https://phuquocvoucher.azurewebsites.net/api/v1/orders" +
        "?OrderStatus=" +
        orderStatus +
        "&SellerId=" +
        sellerId.toString());
    // ignore: unused_local_variable
    // List<dynamic> dataResponse = await json.decode(response.body);
    Map dataResponse = await json.decode(response.body);
    Iterable l = dataResponse["data"];
    print(response.body);
    List<Order> customers =
        List<Order>.from(l.map((model) => Order.fromJson(model)));
    return customers;
  }

  detailOrder(String? orderId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    print("jwt " + jwt.toString());

    var response = await http.get(
        Uri.parse("https://phuquocvoucher.azurewebsites.net/api/v1/orders?Id=" +
            orderId.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print("https://phuquocvoucher.azurewebsites.net/api/v1/orders?Id=" +
        orderId.toString());
    // ignore: unused_local_variable
    // List<dynamic> dataResponse = await json.decode(response.body);
    print(response.body);
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    return dataResponse["data"];
    // Order order = Order.fromJson(dataResponse["data"]);
    // return dataResponse;
  }
}
