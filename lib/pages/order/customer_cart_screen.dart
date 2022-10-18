import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/provider/coupon_provider.dart';
import 'package:nyoba/provider/order_provider.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../models/cart.dart';
import '../../services/session.dart';
import '../../utils/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomerCartScreen extends StatefulWidget {
  int customerId;
  CustomerCartScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  _CustomerCartScreenState createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  // List<ProductModel> productCart = [];
  double totalPriceCart = 0;
  Cart? cart;

  int totalSelected = 0;
  bool isCouponUsed = false;
  bool isSelectedAll = false;
  bool test = false;

  // CustomerProvider? customerProvider;

  // loadData() async {
  //   if (Session.data.containsKey('cart')) {
  //     List? listCart = await json.decode(Session.data.getString('cart')!);

  //     setState(() {
  //       productCart = listCart!
  //           .map((product) => new ProductModel.fromJson(product))
  //           .toList();
  //     });
  //     print(productCart.length);
  //     selectedAll();
  //   }
  // }

  // saveData() async {
  //   await Session.data.setString('cart', json.encode(productCart));
  //   printLog(productCart.toString(), name: "Cart Product");
  //   Provider.of<OrderProvider>(context, listen: false)
  //       .loadCartCount()
  //       .then((value) => setState(() {}));
  // }

  /*Calculate Total If Item Selected*/
  calculateTotal(index) {
    if (cart!.cartItems![index].isSelected!) {
      setState(() {
        totalSelected++;
      });
    } else {
      setState(() {
        totalSelected--;
      });
    }
    cart!.cartItems!.forEach((element) {
      if (element.isSelected!) {
        setState(() {
          isSelectedAll = true;
        });
      }
    });
    cart!.cartItems!.forEach((element) {
      if (!element.isSelected!) {
        setState(() {
          isSelectedAll = false;
        });
      }
    });
    reCalculateTotalOrder();
    setState(() {
      Session.data.setDouble('totalPriceCart', totalPriceCart);
    });
  }

  /*Select All Item*/
  selectedAll() {
    setState(() {
      isSelectedAll = !isSelectedAll;
    });
    if (isSelectedAll) {
      setState(() {
        totalPriceCart = 0;
      });
      cart!.cartItems!.forEach((element) {
        setState(() {
          totalSelected++;
          element.isSelected = true;
          totalPriceCart += element.price! * element.quantity!;
        });
      });
    } else {
      cart!.cartItems!.forEach((element) {
        setState(() {
          totalSelected--;
          element.isSelected = false;
          totalPriceCart -= element.price! * element.quantity!;
        });
      });
    }
    reCalculateTotalOrder();
    setState(() {
      Session.data.setDouble('totalPriceCart', totalPriceCart);
    });
  }

  /*Increase Quantity Item*/
  increaseQuantity(index) {
    setState(() {
      // cart!.cartItems![index].quantity =
      //     (cart!.cartItems![index].quantity! + 1);
    });
    if (cart!.cartItems![index].isSelected!) {
      reCalculateTotalOrder();
    }
    // saveData();
  }

  /*Decrease Quantity Item*/
  decreaseQuantity(index) {
    setState(() {
      // cart!.cartItems![index].quantity =
      //     (cart!.cartItems![index].quantity! - 1);
    });
    if (cart!.cartItems![index].isSelected!) {
      reCalculateTotalOrder();
    }
    // saveData();
  }

  /*ReCalculate Total Order*/
  reCalculateTotalOrder() {
    setState(() {
      totalPriceCart = 0;
      totalSelected = 0;
    });
    cart!.cartItems!.forEach((element) {
      if (element.isSelected!) {
        setState(() {
          totalPriceCart += element.price! * element.quantity!;
          totalSelected++;
        });
      }
    });
    // calcDisc();
  }

  /*Remove Item & Save Cart To ShredPrefs*/
  // removeItem(index) {
  //   setState(() {
  //     productCart.removeAt(index);
  //   });
  //   reCalculateTotalOrder();
  //   saveData();
  //   snackBar(context,
  //       message:
  //           AppLocalizations.of(context)!.translate('delete_cart_message')!);
  // }

  /*Remove Selected Item*/
  // removeSelectedItem() {
  //   setState(() {
  //     productCart.removeWhere((element) => element.isSelected!);
  //   });
  //   reCalculateTotalOrder();
  //   saveData();
  //   Navigator.pop(context);
  //   snackBar(context,
  //       message:
  //           AppLocalizations.of(context)!.translate('delete_cart_message')!);
  // }

  /*Calculate Discount*/
  // calcDisc() {
  //   final coupons = Provider.of<CouponProvider>(context, listen: false);
  //   if (coupons.couponUsed != null) {
  //     setState(() {
  //       totalPriceCart -= double.parse(coupons.couponUsed!.amount!).toInt();
  //     });
  //   }
  //   if (totalPriceCart < 0) {
  //     setState(() {
  //       totalPriceCart = 0;
  //     });
  //   }
  // }

  /*Checkout*/
  checkOut() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .placeOrder(widget.customerId)
        .then((value) {
      this.setState(() {
        if (value == true) {
          snackBar(context, message: "Tạo đơn hàng thành công!");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CustomerCartScreen(customerId: widget.customerId)),
            (Route<dynamic> route) => false,
          ); // pop current page

        } else {
          snackBar(context, message: "Tạo đơn hàng thất bại!");
        }
      });
    });
  }

  /*Remove Ordered Items*/
  // Future removeOrderedItems() async {
  //   productCart.removeWhere((element) => element.isSelected!);
  //   saveData();
  //   await Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => OrderSuccess()));
  // }

  getCart() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .getCustomerCart(context, widget.customerId)
        .then((value) {
      this.setState(() {
        cart = value!;
        cart!.cartItems!.forEach((element) {
          setState(() {
            totalSelected++;
            element.isSelected = true;
            totalPriceCart += element.price! * element.quantity!;
          });
        });
        print("CustomerID" + cart!.customerId.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // customerProvider = Provider.of<CustomerProvider>(context, listen: false);

    getCart();
    // selectedAll();

    // loadData();
  }

  @override
  Widget build(BuildContext context) {
    // selectedAll();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Giỏ hàng",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          // InkWell(
          //   onTap: totalSelected == 0
          //       ? null
          //       : () {
          //           showDialog(
          //             context: context,
          //             builder: (BuildContext context) =>
          //                 _buildPopupDelete(context),
          //           );
          //         },
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 15),
          //     alignment: Alignment.center,
          //     child: Text(
          //       "Xóa lựa chọn",
          //       style: TextStyle(
          //           color: totalSelected != 0 ? Colors.black : Colors.grey),
          //     ),
          //   ),
          // )
        ],
      ),
      body: cart != null
          ? Column(
              children: [
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, i) {
                          return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                // removeItem(i);
                              },
                              child: itemList(i));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 15,
                          );
                        },
                        itemCount: cart!.cartItems!.length)),
                buildBottomBarCart()
              ],
            )
          : customLoading(),
    );
  }

  Widget itemList(int index) {
    return Material(
      elevation: 5,
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        color: Colors.white,
        padding: EdgeInsets.all(15),
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //   child: Container(
            //     height: double.infinity,
            //     alignment: Alignment.center,
            //     child: InkWell(
            //       onTap: () {
            //         setState(() {
            //           test = !test;
            //           cart!.cartItems![index].isSelected =
            //               !cart!.cartItems![index].isSelected!;
            //         });
            //         calculateTotal(index);
            //       },
            //       child: AnimatedContainer(
            //         duration: Duration(milliseconds: 300),
            //         decoration: BoxDecoration(
            //             border: Border.all(color: Colors.grey),
            //             shape: BoxShape.circle,
            //             color: cart!.cartItems![index].isSelected!
            //                 ? primaryColor
            //                 : Colors.white),
            //         child: Padding(
            //             padding: const EdgeInsets.all(3),
            //             child: Icon(
            //               Icons.check,
            //               color: Colors.white,
            //               size: 20,
            //             )),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 80.h,
              width: 80.w,
              child: CachedNetworkImage(
                imageUrl:
                    "https://jobsgo.vn/blog/wp-content/uploads/2021/11/du-lich-la-gi-1.jpg",
                placeholder: (context, url) => customLoading(),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported_rounded,
                  size: 25,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cart!.cartItems![index].product!.summary.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: responsiveFont(9)),
                    ),
                    // Visibility(
                    //     visible: productCart[index].variantId != null,
                    //     child: Row(
                    //       children: [
                    //         Wrap(
                    //           children: [
                    //             // for (var i = 0;
                    //             //     i < productCart[index].attributes!.length;
                    //             //     i++)
                    //             //   Text(
                    //             //       i == 0
                    //             //           ? '${productCart[index].attributes![i].selectedVariant}'
                    //             //           : ', ${productCart[index].attributes![i].selectedVariant}',
                    //             //       style: TextStyle(
                    //             //           fontSize: responsiveFont(9),
                    //             //           fontStyle: FontStyle.italic)),
                    //           ],
                    //         ),
                    //       ],
                    //     )),
                    // Visibility(
                    //   visible: productCart[index].discProduct != 0,
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(vertical: 5),
                    //     child: Row(
                    //       children: [
                    //         Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(5),
                    //             color: secondaryColor,
                    //           ),
                    //           padding: EdgeInsets.symmetric(
                    //               vertical: 3, horizontal: 7),
                    //           child: Text(
                    //             "${productCart[index].discProduct!.round()}%",
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: responsiveFont(9)),
                    //           ),
                    //         ),
                    //         Container(
                    //           width: 5,
                    //         ),
                    //         Text(
                    //           stringToCurrency(
                    //               double.parse(
                    //                   productCart[index].productRegPrice),
                    //               context),
                    //           style: TextStyle(
                    //               color: HexColor("C4C4C4"),
                    //               decoration: TextDecoration.lineThrough,
                    //               fontSize: responsiveFont(8)),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // stringToCurrency(
                            //     double.parse(cart!.cartItems![index].price),
                            //     context),
                            cart!.cartItems![index].price.toString() + " Vnd",
                            style: TextStyle(
                                fontSize: responsiveFont(10),
                                color: secondaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  // removeItem(index);
                                },
                                child: Container(
                                    width: 16.w,
                                    height: 16.h,
                                    child:
                                        Image.asset("images/cart/trash.png")),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                width: 16.w,
                                height: 16.h,
                                child: InkWell(
                                  onTap: () {
                                    if (cart!.cartItems![index].quantity! > 1) {
                                      setState(() {
                                        cart!.cartItems![index].quantity =
                                            cart!.cartItems![index].quantity! -
                                                1;
                                      });
                                      decreaseQuantity(index);
                                    }
                                  },
                                  child: cart!.cartItems![index].quantity! > 1
                                      ? Image.asset("images/cart/minusDark.png")
                                      : Image.asset("images/cart/minus.png"),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(cart!.cartItems![index].quantity.toString()),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 16.w,
                                height: 16.h,
                                child: InkWell(
                                    onTap: cart!.cartItems![index].product!
                                                    .inventory !=
                                                null &&
                                            cart!.cartItems![index].product!
                                                    .inventory! <=
                                                cart!
                                                    .cartItems![index].quantity!
                                        ? null
                                        : () {
                                            setState(() {
                                              cart!.cartItems![index].quantity =
                                                  cart!.cartItems![index]
                                                          .quantity! +
                                                      1;
                                            });
                                            increaseQuantity(index);
                                          },
                                    child: cart!.cartItems![index].product!
                                                    .inventory !=
                                                null &&
                                            cart!.cartItems![index].product!
                                                    .inventory! >
                                                cart!
                                                    .cartItems![index].quantity!
                                        ? Image.asset("images/cart/plus.png")
                                        : Image.asset(
                                            "images/cart/plusDark.png")),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildBottomBarCart() {
    final coupons = Provider.of<CouponProvider>(context, listen: false);
    // print(coupons.couponUsed);

    return Column(
      children: [
        // coupons.couponUsed != null
        //     ? Container(
        //         color: Colors.white,
        //         padding: EdgeInsets.all(15),
        //         width: double.infinity,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Row(
        //               children: [
        //                 // Container(
        //                 //     width: 20.w,
        //                 //     height: 20.h,
        //                 //     child: Image.asset("images/cart/coupon.png")),
        //                 // Column(
        //                 //   crossAxisAlignment: CrossAxisAlignment.start,
        //                 //   children: [
        //                 //     Container(
        //                 //       margin: EdgeInsets.symmetric(horizontal: 10),
        //                 //       child: Text(
        //                 //         "${AppLocalizations.of(context)!.translate('using_coupon')} :",
        //                 //         style: TextStyle(
        //                 //             fontSize: responsiveFont(10),
        //                 //             fontWeight: FontWeight.bold),
        //                 //       ),
        //                 //     ),
        //                 //     Container(
        //                 //       margin: EdgeInsets.symmetric(horizontal: 10),
        //                 //       child: Text(
        //                 //         "${coupons.couponUsed!.code}",
        //                 //         style: TextStyle(
        //                 //             fontSize: responsiveFont(10),
        //                 //             fontStyle: FontStyle.italic),
        //                 //       ),
        //                 //     ),
        //                 //   ],
        //                 // ),
        //               ],
        //             ),
        //             // InkWell(
        //             //   child: Icon(
        //             //     Icons.cancel,
        //             //     color: primaryColor,
        //             //   ),
        //             //   onTap: () {
        //             //     setState(() {
        //             //       coupons.couponUsed = null;
        //             //     });
        //             //     reCalculateTotalOrder();
        //             //   },
        //             // )
        //           ],
        //         ),
        //       )
        //     : GestureDetector(
        //         onTap: () async {
        //           await Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => CouponScreen())).then((value) {
        //             setState(() {});
        //             reCalculateTotalOrder();
        //           });
        //         },
        //         child: Container(
        //           padding: EdgeInsets.all(15),
        //           width: double.infinity,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.end,
        //             children: [
        //               Container(
        //                   width: 20.w,
        //                   height: 20.h,
        //                   child: Image.asset("images/cart/coupon.png")),
        //               Container(
        //                 margin: EdgeInsets.symmetric(horizontal: 10),
        //                 child: Text(
        //                   AppLocalizations.of(context)!
        //                       .translate('apply_coupon')!,
        //                   style: TextStyle(fontSize: responsiveFont(10)),
        //                 ),
        //               ),
        //               Icon(Icons.keyboard_arrow_right)
        //             ],
        //           ),
        //         ),
        //       ),
        Container(
          width: double.infinity,
          height: 1,
          color: HexColor("DDDDDD"),
        ),
        Material(
            elevation: 5,
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Container(
                      //   margin: EdgeInsets.only(left: 15, right: 10),
                      //   alignment: Alignment.center,
                      //   child: InkWell(
                      //     onTap: () {
                      //       selectedAll();
                      //     },
                      //     child: AnimatedContainer(
                      //       duration: Duration(milliseconds: 300),
                      //       decoration: BoxDecoration(
                      //           border: Border.all(color: Colors.grey),
                      //           shape: BoxShape.circle,
                      //           color: isSelectedAll
                      //               ? primaryColor
                      //               : Colors.white),
                      //       child: Padding(
                      //           padding: const EdgeInsets.all(3),
                      //           child: Icon(
                      //             Icons.check,
                      //             color: Colors.white,
                      //             size: 20,
                      //           )),
                      //     ),
                      //   ),
                      // ),
                      // Text(
                      //   "Chọn tất cả",
                      //   style: TextStyle(fontSize: responsiveFont(10)),
                      // )
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Tổng : ' + totalPriceCart.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: "vnd",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor)),
                              ],
                            ),
                          ),
                          coupons.couponUsed == null
                              ? Container()
                              : Visibility(
                                  visible: coupons.couponUsed != null,
                                  child: Text(
                                    "${AppLocalizations.of(context)!.translate('discount')} : ${stringToCurrency(double.parse(coupons.couponUsed!.amount!), context)}",
                                    style:
                                        TextStyle(fontSize: responsiveFont(8)),
                                  ))
                        ],
                      ),
                      Container(
                        width: 15,
                      ),
                      TextButton(
                        onPressed: () {
                          checkOut();
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            backgroundColor: totalSelected != 0
                                ? primaryColor
                                : Colors.grey),
                        child: Text(
                          "${"Thanh toán"}($totalSelected)",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
              color: Colors.white,
            ))
      ],
    );
  }

  Widget _buildPopupDelete(BuildContext context) {
    return new AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        insetPadding: EdgeInsets.all(0),
        content: Builder(
          builder: (context) {
            return Container(
              height: 150.h,
              width: 330.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.translate('delete')} $totalSelected item?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: responsiveFont(16),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('delete_cart_confirm')!,
                              style: TextStyle(
                                fontSize: responsiveFont(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // removeSelectedItem();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('delete')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
