import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyoba/models/cart_model.dart';
import 'package:nyoba/models/customer.dart';
import 'package:nyoba/models/order.dart';
import 'package:nyoba/models/order_model.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/pages/auth/login_screen.dart';
import 'package:nyoba/provider/product_provider.dart';
import 'package:nyoba/services/order_api.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/webview/checkout_webview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_localizations.dart';
import '../models/cart.dart';
import '../pages/order/customer_cart_screen.dart';
import 'coupon_provider.dart';

class OrderProvider with ChangeNotifier {
  ProductModel? productDetail;
  String? status;
  String? search;

  bool isLoading = false;
  bool loadDataOrder = false;

  List<OrderModel> listOrder = [];
  List<OrderModel> tempOrder = [];

  List<OrderModel> listOrder2 = [];
  List<OrderModel> tempOrder2 = [];
  int orderPage = 1;

  List<Voucher?> listProductOrder = [];

  List<Customer?> listCustomerOrder = [];

  Order? detailOrder;
  DetailOrder? detailOrder2;
  int cartCount = 0;
  String? payUrl;

  Future checkout(order) async {
    var result;
    await OrderAPI().checkoutOrder(order).then((data) {
      printLog(data, name: 'Link Order From API');
      result = data;
    });
    return result;
  }

  Future checkoutV2(order) async {
    var result;
    await OrderAPI().checkoutOrderV2(order).then((data) {
      // printLog(data, name: 'Link Order From API');
      print("Return data" + data.toString());
      result = data;
    });
    return result;
  }

  Future<String?> placeOrder(customerId) async {
    String? check;
    await OrderAPI().placeOrder(customerId).then((data) {
      // printLog(data, name: 'Link Order From API');
      check = data;
      print("Return data" + data.toString());
    });
    return check;
    // return result;
  }

  Future<bool> updateCart(int customerId, Cart cart) async {
    bool check = false;
    for (var element in cart.cartItems!) {
      print(element.id.toString() + " " + element.isChange.toString());
    }
    await OrderAPI().updateCart(customerId, cart).then((data) {
      // printLog(data, name: 'Link Order From API');
      check = data["id"].toString() != "";
      print("Return data" + check.toString());
      // if (data["id"] != null) {
      //   check = true;
      // }
    });
    return check;
    // return result;
  }

  Future<String?> getPayUrl(int orderId) async {
    bool check = false;
    String result = "";
    await OrderAPI().getPayUrl(orderId).then((data) {
      // printLog(data, name: 'Link Order From API');
      result = data;
      // if (data["id"] != null) {
      //   check = true;
      // }
    });
    return result;
    // return result;
  }

  Future<bool> cancelOrder(int orderId) async {
    bool check = false;
    await OrderAPI().cancelOrder(orderId).then((data) {
      // printLog(data, name: 'Link Order From API');
      check = data["id"].toString() != "";
      print("Return data" + check.toString());
      // if (data["id"] != null) {
      //   check = true;
      // }
    });
    return check;
    // return result;
  }

  Future<bool> removeCart(int customerId, int cartItemId) async {
    bool check = false;
    await OrderAPI().removeCartItem(customerId, cartItemId).then((data) {
      // printLog(data, name: 'Link Order From API');
      check = data["id"].toString() != "";
      print("Return data" + data.toString());
    });
    return check;
    // return result;
  }

  Future<bool> sendEmailToCustomer(int orderId) async {
    bool check = false;
    await OrderAPI().sendEmailToCustomer(orderId).then((data) {
      // printLog(data, name: 'Link Order From API');
      check = data;
      print("Return data" + data.toString());
    });
    return check;
    // return result;
  }

  Future<List?> fetchOrders({status, search, orderId}) async {
    isLoading = true;
    var result;
    await OrderAPI()
        .listMyOrder(status, search, orderId, orderPage)
        .then((data) {
      result = data;
      List _order = result;
      tempOrder = [];
      tempOrder
          .addAll(_order.map((order) => OrderModel.fromJson(order)).toList());
      List<OrderModel> list = List.from(listOrder);
      list.addAll(tempOrder);
      listOrder = list;
      if (tempOrder.length % 10 == 0) {
        orderPage++;
      }

      listOrder.forEach((element) {
        element.productItems!.sort((a, b) => b.image!.compareTo(a.image!));
      });

      isLoading = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<List<Order>> fetchOrdersV2(context, String orderStatus) async {
    isLoading = true;
    List<Order> orders = List.empty(growable: true);
    await OrderAPI().getListOrder(orderStatus).then((data) {
      if (data.length != 0 || data != "") {
        // Iterable l = data;
        // customers =
        //     List<Customer>.from(l.map((model) => Customer.fromJson(model)));
        orders = data;

        // for (var element in customers) {
        //   print(element.customerName);
        // }
        isLoading = false;
        notifyListeners();
        return orders;
      }
    });
    return orders;
  }

  Future<Order?> fetchDetailOrder(orderId) async {
    isLoading = true;
    var result;
    await OrderAPI().detailOrder(orderId).then((data) {
      // Order order = Order.fromJson(data);
      // print(data.toString());
      detailOrder = Order.fromJson(data[0]);
      result = detailOrder;
      printLog(result.toString());

      isLoading = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<DetailOrder?> fetchDetailOrderById(orderId) async {
    isLoading = true;
    var result;
    await OrderAPI().detailOrder2(orderId).then((data) {
      // Order order = Order.fromJson(data);
      // print("Hello" + data.toString());
      detailOrder2 = DetailOrder.fromJson(data);
      result = detailOrder2;
      // printLog(result.toString());

      isLoading = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<dynamic> loadCartCount() async {
    print('Load Count');
    List<ProductModel> productCart = [];
    int _count = 0;

    if (Session.data.containsKey('cart')) {
      List listCart = await json.decode(Session.data.getString('cart')!);

      productCart = listCart
          .map((product) => new ProductModel.fromJson(product))
          .toList();

      productCart.forEach((element) {
        _count += element.cartQuantity!;
      });
      cartCount = _count;
      notifyListeners();
    }
    return _count;
  }

  Future checkOutOrder(context,
      {int? totalSelected,
      List<ProductModel>? productCart,
      Future<dynamic> Function()? removeOrderedItems}) async {
    final coupons = Provider.of<CouponProvider>(context, listen: false);
    if (totalSelected == 0) {
      snackBar(context, message: "Please select the product first.");
    } else {
      if (Session.data.getBool('isLogin')!) {
        CartModel cart = new CartModel();
        cart.listItem = [];
        productCart!.forEach((element) {
          if (element.isSelected!) {
            var variation = {};
            if (element.selectedVariation!.isNotEmpty) {
              element.selectedVariation!.forEach((elementVar) {
                String columnName = elementVar.columnName!.toLowerCase();
                String? value = elementVar.value;

                variation['attribute_$columnName'] = "$value";
              });
            }
            cart.listItem!.add(new CartProductItem(
                productId: element.id,
                quantity: element.cartQuantity,
                variationId: element.variantId,
                variation: [variation]));
          }
        });

        //init list coupon
        cart.listCoupon = [];
        //check coupon
        if (coupons.couponUsed != null) {
          cart.listCoupon!.add(new CartCoupon(code: coupons.couponUsed!.code));
        }

        //add to cart model
        cart.paymentMethod = "xendit_bniva";
        cart.paymentMethodTitle = "Bank Transfer - BNI";
        cart.setPaid = true;
        cart.customerId = Session.data.getInt('id');
        cart.status = 'completed';
        cart.token = Session.data.getString('cookie');

        //Encode Json
        final jsonOrder = json.encode(cart);
        printLog(jsonOrder, name: 'Json Order');

        //Convert Json to bytes
        var bytes = utf8.encode(jsonOrder);

        //Convert bytes to base64
        var order = base64.encode(bytes);

        //Generate link WebView checkout
        await Provider.of<OrderProvider>(context, listen: false)
            .checkout(order)
            .then((value) async {
          printLog(value, name: 'Link Order');
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutWebView(
                        url: value,
                        onFinish: removeOrderedItems,
                      )));
        });
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Login(
                      isFromNavBar: false,
                    )));
      }
    }
  }

  Future buyNow(context, ProductModel? product,
      Future<dynamic> Function() onFinishBuyNow) async {
    if (Session.data.getBool('isLogin')!) {
      CartModel cart = new CartModel();
      cart.listItem = [];
      cart.listItem!.add(new CartProductItem(
          productId: product!.id,
          quantity: product.cartQuantity,
          variationId: product.variantId));

      //init list coupon
      cart.listCoupon = [];

      //add to cart model
      cart.paymentMethod = "xendit_bniva";
      cart.paymentMethodTitle = "Bank Transfer - BNI";
      cart.setPaid = true;
      cart.customerId = Session.data.getInt('id');
      cart.status = 'completed';
      cart.token = Session.data.getString('cookie');

      //Encode Json
      final jsonOrder = json.encode(cart);
      printLog(jsonOrder, name: 'Json Order');

      //Convert Json to bytes
      var bytes = utf8.encode(jsonOrder);

      //Convert bytes to base64
      var order = base64.encode(bytes);

      //Generate link WebView checkout
      await Provider.of<OrderProvider>(context, listen: false)
          .checkout(order)
          .then((value) async {
        printLog(value, name: 'Link Order');
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckoutWebView(
                      url: value,
                      onFinish: onFinishBuyNow,
                    )));
      });
    } else {
      Navigator.pop(context);
      snackBar(context,
          message: AppLocalizations.of(context)!.translate('you_login_first')!);
    }
  }

  Future buyNowV2(
      context, Order? order, Future<dynamic> Function() onFinishBuyNow) async {
    if (Session.data.getBool('isLogin')!) {
      // CartModel cart = new CartModel();
      // cart.listItem = [];
      // cart.listItem!.add(new CartProductItem(
      //     productId: product!.id,
      //     quantity: product.cartQuantity,
      //     variationId: product.variantId));

      // //init list coupon
      // cart.listCoupon = [];

      // //add to cart model
      // cart.paymentMethod = "xendit_bniva";
      // cart.paymentMethodTitle = "Bank Transfer - BNI";
      // cart.setPaid = true;
      // cart.customerId = Session.data.getInt('id');
      // cart.status = 'completed';
      // cart.token = Session.data.getString('cookie');

      //Encode Json
      var jsonOrder = json.encode(order);
      printLog(jsonOrder, name: 'Json Order');

      //Convert Json to bytes
      // var bytes = utf8.encode(jsonOrder);

      //Convert bytes to base64
      // var order = base64.encode(bytes);

      //Generate link WebView checkout
      await Provider.of<OrderProvider>(context, listen: false)
          .checkoutV2(order)
          .then((value) async {
        printLog(value, name: 'Link Order');
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckoutWebView(
                      url: value,
                      onFinish: onFinishBuyNow,
                    )));
      });
    } else {
      Navigator.pop(context);
      snackBar(context,
          message: "B???n c???n ????ng nh???p ????? th???c hi???n ch???c n??ng n??y!");
    }
  }

  Future<List<String>> buyNowVoucher(context, Voucher? product, String date,
      Customer customer, List<Price> listPrice, int quantity) async {
    // bool check = false;
    List<String> check = List.empty(growable: true);
    if (Session.data.getBool('isLogin')!) {
      print("List Price length" + listPrice.length.toString());
      await OrderAPI()
          .addCartItem(customer, date, product!, quantity)
          .then((data) async {
        if (data != null) {
          await OrderAPI().placeOrder(customer.id!).then((data) {
            // printLog(data, name: 'Link Order From API');
            check = data;
            print("Return data" + data.toString());
            return check;
          });
          return check;
        }
      });
    } else {
      Navigator.pop(context);
      snackBar(context,
          message: "B???n c???n ????ng nh???p tr?????c khi th???c hi???n ch???c n??ng n??y!");
    }
    return check;
  }

  // Future buyNowCombo(context, Combo? product, List<int>? quantity, String date,
  //     Customer customer, Future<dynamic> Function() onFinishBuyNow) async {
  //   if (Session.data.getBool('isLogin')!) {
  //     // CartModel cart = new CartModel();
  //     // cart.listItem = [];
  //     // cart.listItem!.add(new CartProductItem(
  //     //     productId: product!.id, quantity: quantity, variationId: 1));

  //     // //init list coupon
  //     // cart.listCoupon = [];

  //     // //add to cart model
  //     // cart.paymentMethod = "xendit_bniva";
  //     // cart.paymentMethodTitle = "Bank Transfer - BNI";
  //     // cart.setPaid = true;
  //     // cart.customerId = Session.data.getInt('id');
  //     // cart.status = 'completed';
  //     // cart.token = Session.data.getString('cookie');

  //     //Encode Json
  //     var now = new DateTime.now();
  //     var formatter = new DateFormat('yyyy-MM-dd');
  //     String formattedDate = formatter.format(now);
  //     SharedPreferences data = await SharedPreferences.getInstance();
  //     String? sellerId = data.getInt("id").toString();
  //     Map orderItems = {
  //       "status": "Active",
  //       "orderId": 0,
  //       "orderProductId": product!.productId,
  //       "priceId": product.prices!.length > 0 ? product.prices!.first.id : 0,
  //       "profileId": customer.userInfoId,
  //       "useDate": date
  //     };
  //     Map orderData = {
  //       "status": "Active",
  //       "createDate": formattedDate,
  //       "orderStatus": "Processing",
  //       "customerId": customer.id,
  //       "sellerId": sellerId,
  //       "orderItems": [orderItems],
  //     };
  //     final jsonOrder = json.encode(orderData);
  //     printLog(jsonOrder, name: 'Json Order');

  //     //Convert Json to bytes
  //     // var bytes = utf8.encode(jsonOrder);

  //     // //Convert bytes to base64
  //     // var order = base64.encode(bytes);

  //     //Generate link WebView checkout
  //     await Provider.of<OrderProvider>(context, listen: false)
  //         .checkoutV2(jsonOrder)
  //         .then((value) async {
  //       printLog(value, name: 'Link Order');
  //       snackBar(context, message: "Mua th??nh c??ng!");
  //       // await Navigator.push(
  //       //     context,
  //       //     MaterialPageRoute(
  //       //         builder: (context) => CheckoutWebView(
  //       //               url: value,
  //       //               onFinish: onFinishBuyNow,
  //       //             )));
  //     });
  //   } else {
  //     Navigator.pop(context);
  //     snackBar(context,
  //         message: "B???n c???n ????ng nh???p tr?????c khi th???c hi???n ch???c n??ng n??y!");
  //   }
  // }

  // Future testBuyNowVoucher(
  //     context,
  //     Voucher? product,
  //     List<int>? quantity,
  //     String date,
  //     Customer customer,
  //     Future<dynamic> Function() onFinishBuyNow) async {
  //   if (Session.data.getBool('isLogin')!) {
  //     // ignore: unused_local_variable
  //     Cart cart = await OrderAPI().getCartByCustomerId(customer.id);
  //     for (var i = 0; i < cart.cartItems!.length; i++) {
  //       if (cart.cartItems![i].productId != product!.productId) {
  //         OrderAPI().addCartItem(customer.id, product.prices![i].quantity!,
  //             product.prices![i].id!, date);
  //       }
  //     }

  //     var now = new DateTime.now();
  //     var formatter = new DateFormat('yyyy-MM-dd');
  //     String formattedDate = formatter.format(now);
  //     SharedPreferences data = await SharedPreferences.getInstance();
  //     String? sellerId = data.getInt("id").toString();
  //     Map orderItems = {
  //       "status": "Active",
  //       "orderId": 0,
  //       "orderProductId": product!.productId,
  //       "priceId": product.prices!.length > 0 ? product.prices!.first.id : 0,
  //       "profileId": customer.userInfoId,
  //       "useDate": date
  //     };
  //     Map orderData = {
  //       "status": "Active",
  //       "createDate": formattedDate,
  //       "orderStatus": "Processing",
  //       "customerId": customer.id,
  //       "sellerId": sellerId,
  //       "orderItems": [orderItems],
  //     };
  //     final jsonOrder = json.encode(orderData);
  //     printLog(jsonOrder, name: 'Json Order');

  //     //Convert Json to bytes
  //     // var bytes = utf8.encode(jsonOrder);

  //     // //Convert bytes to base64
  //     // var order = base64.encode(bytes);

  //     //Generate link WebView checkout
  //     await Provider.of<OrderProvider>(context, listen: false)
  //         .checkoutV2(jsonOrder)
  //         .then((value) async {
  //       printLog(value, name: 'Link Order');
  //       snackBar(context, message: "Mua th??nh c??ng!");
  //       // await Navigator.push(
  //       //     context,
  //       //     MaterialPageRoute(
  //       //         builder: (context) => CheckoutWebView(
  //       //               url: value,
  //       //               onFinish: onFinishBuyNow,
  //       //             )));
  //     });
  //   } else {
  //     Navigator.pop(context);
  //     snackBar(context,
  //         message: "B???n c???n ????ng nh???p tr?????c khi th???c hi???n ch???c n??ng n??y!");
  //   }
  // }

  Future<int?> addCartVoucher(context, Voucher? product, String date,
      Customer customer, int quantity) async {
    int? check = 0;
    if (Session.data.getBool('isLogin')!) {
      await OrderAPI()
          .addCartItem(customer, date, product!, quantity)
          .then((data) {
        if (data != 0) {
          check = data;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerCartScreen(
                        customerId: check!,
                      )));
          // return check;
        }
      });
    } else {
      Navigator.pop(context);
      snackBar(context,
          message: "B???n c???n ????ng nh???p tr?????c khi th???c hi???n ch???c n??ng n??y!");
    }
    return check;
  }

  // Future<bool> addCartCombo(
  //     context, Combo? product, String date, Customer customer) async {
  //   if (Session.data.getBool('isLogin')!) {
  //     bool check = false;
  //     for (var i = 0; i < product!.prices!.length; i++) {
  //       if (product.prices![i].quantity != null) {
  //         // await OrderAPI()
  //         //     .addCartItem(customer.id, product.prices![i].quantity!,
  //         //         product.prices![i].id!, date)
  //         //     .then((data) {
  //         //   if (data["id"] != null) {
  //         //     check = true;
  //         //   }
  //         // });
  //       }
  //     }
  //     return check;
  //   } else {
  //     Navigator.pop(context);
  //     snackBar(context,
  //         message: "B???n c???n ????ng nh???p tr?????c khi th???c hi???n ch???c n??ng n??y!");
  //   }
  //   return false;
  // }

  Future<Cart?> getCustomerCart(context, int? customerId) async {
    if (Session.data.getBool('isLogin')!) {
      Cart cart = await OrderAPI().getCartByCustomerId(customerId!);
      return cart;
    } else {
      Navigator.pop(context);
      snackBar(context,
          message: "B???n c???n ????ng nh???p tr?????c khi th???c hi???n ch???c n??ng n??y!");
    }
    return null;
  }

  Future loadItemOrder(context) async {
    loadDataOrder = true;
    if (detailOrder != null) {
      // listProductOrder.clear();
      // detailOrder!.orderItems!.forEach((element) async {
      //   await Provider.of<ProductProvider>(context, listen: false)
      //       .fetchProductDetailVoucher(element.voucherId.toString())
      //       .then((value) {
      //     listProductOrder.add(value);
      //   });
      // });
      // loadDataOrder = false;
    }
  }

  Future<void> actionBuyAgain(context) async {
    // detailOrder!.orderItems!.forEach((elementOrder) {
    //   listProductOrder.forEach((element) {
    //     // if (element!.id == elementOrder.priceId) {
    //     //   print('${element.id} == ${elementOrder.productId}');
    //     //   element.cartQuantity = elementOrder.quantity;
    //     //   element.variantId = elementOrder.variationId;
    //     //   element.priceTotal =
    //     //       double.parse(element.productPrice) * element.cartQuantity!;
    //     //   element.attributes!.forEach((elementAttr) {
    //     //     elementOrder.metaData!.forEach((elementMeta) {
    //     //       if (elementAttr.name!.toLowerCase().replaceAll(" ", "-") ==
    //     //           elementMeta.key) {
    //     //         elementAttr.selectedVariant = elementMeta.value;
    //     //       }
    //     //     });
    //     //   });
    //     // }
    //   });
    // });
    for (int i = 0; i < listProductOrder.length; i++) {
      // await addCart(listProductOrder[i], context);
    }
    snackBar(context,
        message: AppLocalizations.of(context)!.translate('add_cart_message')!);
  }

  /*add to cart*/
  Future addCart(ProductModel? product, context) async {
    /*check sharedprefs for cart*/
    if (!Session.data.containsKey('cart')) {
      List<ProductModel?> listCart = [];

      listCart.add(product);

      await Session.data.setString('cart', json.encode(listCart));
    } else {
      List products = await json.decode(Session.data.getString('cart')!);

      printLog(products.length.toString());
      printLog(products.toString(), name: 'Cart Product');

      List<ProductModel?> listCart =
          products.map((product) => ProductModel.fromJson(product)).toList();

      printLog(listCart.toString(), name: 'List Cart');

      int index = products.indexWhere((prod) =>
          prod["id"] == product!.id && prod["variant_id"] == product.variantId);

      if (index != -1) {
        product!.cartQuantity =
            listCart[index]!.cartQuantity! + product.cartQuantity!;

        listCart[index] = product;

        await Session.data.setString('cart', json.encode(listCart));
      } else {
        listCart.add(product);
        await Session.data.setString('cart', json.encode(listCart));
      }
    }
  }

  resetPage() {
    orderPage = 1;
    listOrder = [];
    tempOrder = [];
    isLoading = true;
    notifyListeners();
  }
}
