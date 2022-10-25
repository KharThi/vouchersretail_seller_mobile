import 'dart:convert';

import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/models/cart.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
            "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/order"),
        body: order,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print(dataResponse.toString());
    return dataResponse["data"];
  }

  getCartByCustomerId(int customerId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.get(
        Uri.parse(
            "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers/" +
                customerId.toString() +
                "/cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print(
        "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers/" +
            customerId.toString() +
            "/cart");
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print(dataResponse.toString());
    Cart cart = Cart.fromJson(dataResponse);
    return cart;
  }

  addCartItem(int customerId, int quantity, int priceId, String date) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    Map customerData = {
      "status": "Active",
      "quantity": quantity,
      "priceId": priceId,
      "useDate": date
    };
    var body = json.encode(customerData);

    var response = await http.post(
        Uri.parse(
            "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers/" +
                customerId.toString() +
                "/cart/items"),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    print("addCartItem Link api " +
        "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers/" +
        customerId.toString() +
        "/cart/items");
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print("addCartItem in orderApi" + dataResponse.toString());
    return dataResponse;
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
            "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers/" +
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

  removeCartItem(int customerId, int cartItemId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.delete(
        Uri.parse(
            "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers/" +
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

  placeOrder(int customerId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");

    var response = await http.post(
        Uri.parse(
            "https://webapp-221010174451.azurewebsites.net/api/v1/sellers/customers/" +
                customerId.toString() +
                "/place-order"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt.toString()
        });
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print(dataResponse.toString());
    return dataResponse;
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

  detailOrder(String? orderId) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "order_id": orderId
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$listOrders',
      data,
      isCustom: true,
    );
    return response;
  }
}
