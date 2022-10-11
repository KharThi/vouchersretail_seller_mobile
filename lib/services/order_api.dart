import 'dart:convert';

import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
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
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print(dataResponse.toString());
    return dataResponse;
  }

  addCartItem(int customerId, int quantity, int priceId) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? jwt = data.getString("jwt");
    Map customerData = {
      "status": "Active",
      "quantity": quantity,
      "priceId": priceId,
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
    Map<String, dynamic> dataResponse = await json.decode(response.body);
    print(dataResponse.toString());
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
