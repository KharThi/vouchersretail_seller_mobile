import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nyoba/models/order.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/provider/home_provider.dart';
import 'package:nyoba/provider/order_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/order/order_detail_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app_localizations.dart';
import '../../provider/login_provider.dart';
import '../../provider/product_provider.dart';

class OrderDetail extends StatefulWidget {
  final String? orderId;
  OrderDetail({Key? key, this.orderId}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> with WidgetsBindingObserver {
  String status = "";
  _launchWAURL(String? phoneNumber) async {
    String url = 'https://api.whatsapp.com/send?phone=$phoneNumber&text=Hi';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Voucher> listOrderItem = List.empty(growable: true);
  Order? orderDetail;
  DetailOrder? detailOrder;
  bool isLoading = true;
  final DateFormat serverFormater = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    loadOrder();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this.setState(() {
      loadOrder();
      loadOrder2();
    });
  }

  loadOrder() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .fetchDetailOrder(widget.orderId)
        .then((value) => {orderDetail = value, loadOrder2()});
  }

  loadOrder2() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .fetchDetailOrderById(widget.orderId)
        .then((value) => {detailOrder = value, loadOrderedItems()});
  }

  Future<void> share(String payUrl) async {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    // htmlText.replaceAll(exp, '');
    await FlutterShare.share(
        title: "Link thanh to??n",
        text: "Qu?? kh??ch vui l??ng b???m v??o ????y ????? thanh to??n h??a ????n c???a m??nh",
        linkUrl: payUrl,
        chooserTitle: '');
  }

  loadOrderedItems() async {
    // await Provider.of<OrderProvider>(context, listen: false)
    //     .loadItemOrder(context);
    // Session.data.remove('order_number');
    Future.delayed(new Duration(seconds: 3));
    if (orderDetail!.orderStatus == "Processing") {
      status = "??ang th???c hi???n";
    }
    if (orderDetail!.orderStatus == "Cofirm") {
      status = "X??c nh???n";
    }
    if (orderDetail!.orderStatus == "Failed") {
      status = "Th???t b???i";
    }
    if (orderDetail!.orderStatus == "Completed") {
      status = "Ho??n th??nh";
    }
    if (orderDetail!.orderStatus == "Canceled") {
      status = "???? h???y";
    }
    if (orderDetail!.orderStatus == "Used") {
      status = "???? s??? d???ng";
    }
    listOrderItem.clear();
    if (detailOrder!.qrCodes != null) {
      for (var element in detailOrder!.qrCodes!) {
        await Provider.of<ProductProvider>(context, listen: false)
            .fetchProductDetailVoucher(element.voucherId.toString())
            .then((value) {
          listOrderItem.add(value!);
        });
      }
      this.setState(() {
        isLoading = false;
      });
    } else {
      print("Null");
    }
  }

  @override
  Widget build(BuildContext context) {
    final contact = Provider.of<HomeProvider>(context, listen: false);
    final order = Provider.of<OrderProvider>(context, listen: false);

    Widget buildOrder = ListenableProvider.value(
      value: order,
      child: Consumer<OrderProvider>(builder: (context, value, child) {
        if (value.isLoading) {
          return OrderDetailShimmer();
        }
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Row(
                      children: [
                        Container(
                            width: 30.w,
                            height: 30.h,
                            child: Icon(Icons.shopping_bag_outlined)),
                        Container(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'ID c???a ????n h??ng : ',
                              style: TextStyle(
                                  fontSize: responsiveFont(12),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              orderDetail!.id.toString(),
                              style: TextStyle(
                                  fontSize: responsiveFont(12),
                                  fontWeight: FontWeight.w500,
                                  color: HexColor("960000")),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: HexColor("EEEEEE"),
                    margin: EdgeInsets.all(15),
                    height: 2,
                    width: double.infinity,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 30.w,
                            height: 30.h,
                            child: Icon(Icons.local_shipping_outlined)),
                        Container(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tr???ng th??i ????n h??ng",
                                style: TextStyle(
                                    fontSize: responsiveFont(12),
                                    fontWeight: FontWeight.w500),
                              ),
                              // orderDetail!.paymentDetail!.isEmpty
                              //     ? Text(
                              //         "-",
                              //         style: TextStyle(
                              //             fontSize: responsiveFont(10)),
                              //       )
                              //     :
                              Text(
                                status.toString(),
                                style: TextStyle(fontSize: responsiveFont(10)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: HexColor("EEEEEE"),
                    margin: EdgeInsets.all(15),
                    height: 2,
                    width: double.infinity,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 30.w,
                            height: 30.h,
                            child: Icon(Icons.location_on_outlined)),
                        Container(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Th??ng tin ch??? s??? h???u",
                                style: TextStyle(
                                    fontSize: responsiveFont(12),
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "T??n kh??ch h??ng: " +
                                    orderDetail!.customer!.customerName
                                        .toString(),
                                style: TextStyle(fontSize: responsiveFont(11)),
                              ),
                              Text(
                                "S??? ??i???n tho???i: " +
                                    orderDetail!.customer!.userInfo!.phoneNumber
                                        .toString(),
                                style: TextStyle(fontSize: responsiveFont(11)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: HexColor("EEEEEE"),
                    margin: EdgeInsets.all(15),
                    height: 2,
                    width: double.infinity,
                  ),
                  orderDetail!.paymentDetail != null
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 30.w,
                                  height: 30.h,
                                  child: Icon(Icons.credit_card_outlined)),
                              Container(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Th??ng tin thanh to??n",
                                          style: TextStyle(
                                              fontSize: responsiveFont(12),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        buildBtnPay()
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Ng??y thanh to??n",
                                      style: TextStyle(
                                          fontSize: responsiveFont(10),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      orderDetail!.paymentDetail!.paymentDate !=
                                              null
                                          ? serverFormater.format(
                                              DateTime.parse(orderDetail!
                                                  .paymentDetail!.paymentDate
                                                  .toString()))
                                          : "Ch??a ???????c thanh to??n",
                                      style: TextStyle(
                                          fontSize: responsiveFont(12),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "N???i dung thanhh to??n",
                                      style: TextStyle(
                                          fontSize: responsiveFont(10),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      orderDetail!.paymentDetail!.content !=
                                              null
                                          ? orderDetail!.paymentDetail!.content
                                              .toString()
                                          : "Kh??ng c?? n???i dung thanh to??n",
                                      style: TextStyle(
                                          fontSize: responsiveFont(12),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  // Visibility(
                  //   visible: orderDetail!.customerNote!.isNotEmpty,
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.symmetric(vertical: 10),
                  //         color: HexColor("EEEEEE"),
                  //         height: 2,
                  //         width: double.infinity,
                  //       ),
                  //       Container(
                  //         margin: EdgeInsets.symmetric(horizontal: 15),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //                 width: 30.w,
                  //                 height: 30.h,
                  //                 child: Icon(Icons.assignment_outlined)),
                  //             Container(
                  //               width: 10,
                  //             ),
                  //             Expanded(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     AppLocalizations.of(context)!
                  //                         .translate('order_notes')!,
                  //                     style: TextStyle(
                  //                         fontSize: responsiveFont(12),
                  //                         fontWeight: FontWeight.w500),
                  //                   ),
                  //                   SizedBox(
                  //                     height: 10,
                  //                   ),
                  //                   Text(
                  //                     "Order Note",
                  //                     style: TextStyle(
                  //                         fontSize: responsiveFont(12),
                  //                         fontWeight: FontWeight.w400),
                  //                   ),
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    color: HexColor("EEEEEE"),
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    height: 5,
                    width: double.infinity,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: listOrderItem.length,
                      itemBuilder: (context, i) {
                        return itemList(listOrderItem[i], i);
                      }),
                  Container(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   AppLocalizations.of(context)!
                            //       .translate('subtotal')!,
                            //   style: TextStyle(
                            //       fontSize: responsiveFont(11),
                            //       color: Colors.grey[600],
                            //       fontWeight: FontWeight.w500),
                            // ),
                            // Text(
                            //   stringToCurrency(
                            //       orderDetail!.subTotal!, context),
                            //   style: TextStyle(fontSize: responsiveFont(11)),
                            // )
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //         AppLocalizations.of(context)!
                        //             .translate('shipping_cost')!,
                        //         style: TextStyle(
                        //             fontSize: responsiveFont(11),
                        //             color: Colors.grey[600],
                        //             fontWeight: FontWeight.w500)),
                        //     Text(
                        //         stringToCurrency(double.parse("1009"), context),
                        //         style: TextStyle(fontSize: responsiveFont(11))),
                        //   ],
                        // ),
                        // Visibility(
                        //   visible: orderDetail!.paymentDetail != "0.0",
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //           AppLocalizations.of(context)!
                        //               .translate('discount')!,
                        //           style: TextStyle(
                        //               fontSize: responsiveFont(11),
                        //               color: Colors.grey[600],
                        //               fontWeight: FontWeight.w500)),
                        //       Text(
                        //           "-${stringToCurrency(double.parse(orderDetail!.discountTotal!), context)}",
                        //           style: TextStyle(
                        //               fontSize: responsiveFont(11),
                        //               color: primaryColor)),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          color: HexColor("EEEEEE"),
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          height: 1,
                          width: double.infinity,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("T???ng ti???n",
                                style: TextStyle(
                                    fontSize: responsiveFont(12),
                                    fontWeight: FontWeight.w600)),
                            orderDetail!.totalPrice != null
                                ? Text(
                                    orderDetail!.totalPrice.toString() + " Vnd",
                                    style: TextStyle(
                                      fontSize: responsiveFont(12),
                                      fontWeight: FontWeight.w600,
                                    ))
                                : Text("0",
                                    style: TextStyle(
                                      fontSize: responsiveFont(12),
                                      fontWeight: FontWeight.w600,
                                    )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                      )
                    ],
                  ),
                  height: 45.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      //buy again
                      buildBtnBuyAgain(),
                      Container(
                        width: 10,
                      ),
                      orderDetail!.orderStatus == "Completed" ||
                              orderDetail!.orderStatus == "Used"
                          ? Expanded(
                              child: Container(
                                height: 30.h,
                                margin: EdgeInsets.only(right: 15),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: HexColor(
                                              "960000"), //Color of the border
                                          //Style of the border
                                        ),
                                        alignment: Alignment.center,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5))),
                                    onPressed: () async {
                                      if (orderDetail!.orderStatus ==
                                              "Completed" ||
                                          orderDetail!.orderStatus == "Used") {
                                        await Provider.of<OrderProvider>(
                                                context,
                                                listen: false)
                                            .sendEmailToCustomer(
                                                orderDetail!.id!)
                                            .then((value) => this.setState(() {
                                                  if (value) {
                                                    snackBar(context,
                                                        message:
                                                            'G???i cho kh??ch h??ng th??nh c??ng!');
                                                  } else {
                                                    snackBar(context,
                                                        message:
                                                            'G???i cho kh??ch h??ng th???t b???i!');
                                                  }
                                                }));
                                      } else {
                                        snackBar(context,
                                            message:
                                                '????n h??ng n??y ch??a thanh to??n ho???c ???? b??? h??y!');
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "G???i mail cho kh??ch h??ng",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: responsiveFont(8),
                                              color: HexColor("960000")),
                                        )
                                      ],
                                    )),
                              ),
                            )
                          : Container(),
                      orderDetail!.orderStatus == "Processing"
                          ? Expanded(
                              child: Container(
                                height: 30.h,
                                margin: EdgeInsets.only(right: 15),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: HexColor(
                                              "960000"), //Color of the border
                                          //Style of the border
                                        ),
                                        alignment: Alignment.center,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5))),
                                    onPressed: () async {
                                      if (orderDetail!.orderStatus ==
                                          "Processing") {
                                        await Provider.of<OrderProvider>(
                                                context,
                                                listen: false)
                                            .getPayUrl(orderDetail!.id!)
                                            .then((value) => {
                                                  if (value != "")
                                                    {
                                                      snackBar(context,
                                                          message:
                                                              'L???y link thanh to??n th??nh c??ng!'),
                                                      share(value.toString()),
                                                    }
                                                  else
                                                    {
                                                      snackBar(context,
                                                          message:
                                                              'L???y link thanh to??n th???t b???i!'),
                                                    }
                                                });
                                      } else {
                                        snackBar(context,
                                            message:
                                                '????n h??ng n??y ch??a thanh to??n ho???c ???? b??? h??y!');
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "G???i link thanh to??n cho kh??ch h??ng",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: responsiveFont(8),
                                                color: HexColor("960000")),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            )
                          : Container(),
                    ],
                  )),
            ),
          ],
        );
      }),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Chi ti???t ????n h??ng",
            style: TextStyle(
                color: Colors.black,
                fontSize: responsiveFont(16),
                fontWeight: FontWeight.w500),
          ),
        ),
        body: isLoading ? customLoading() : buildOrder);
  }

  Widget item(Voucher productItems) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.only(left: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55.h,
                height: 55.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: HexColor("c4c4c4")),
                child: productItems.bannerImg == null &&
                        productItems.bannerImg == ''
                    ? Icon(
                        Icons.image_not_supported_outlined,
                      )
                    : CachedNetworkImage(
                        imageUrl: productItems.bannerImg!,
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.image_not_supported_outlined)),
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Container(
                  height: 55.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        convertHtmlUnescape(productItems.id.toString()),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: responsiveFont(12),
                            fontWeight: FontWeight.w600),
                      ),
                      // Text(
                      //   "${productItems.quantity} x ${stringToCurrency((double.parse(productItems.subTotal!)), context)}",
                      //   style: TextStyle(fontSize: responsiveFont(10)),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            width: double.infinity,
            height: 2,
            color: HexColor("EEEEEE"),
          )
        ],
      ),
    );
  }

  buildBtnBuyAgain() {
    final order = Provider.of<OrderProvider>(context, listen: false);

    return ListenableProvider.value(
      value: order,
      child: Consumer<OrderProvider>(builder: (context, value, child) {
        if (value.loadDataOrder) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.grey),
              height: 30.h,
              child: TextButton(
                onPressed: () async {
                  confirmCancelPopDialog(orderDetail!.id!);
                },
                child: Text(
                  "H???y ????n",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveFont(12),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }
        return !(orderDetail!.orderStatus == "Completed" ||
                orderDetail!.orderStatus == "Used")
            ? Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [primaryColor, HexColor("960000")])),
                  height: 30.h,
                  child: TextButton(
                    onPressed: () {
                      confirmCancelPopDialog(orderDetail!.id!);
                    },
                    child: Text(
                      "H???y ????n h??ng",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: responsiveFont(10),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            : Container();
      }),
    );
  }

  buildBtnPay() {
    final order = Provider.of<OrderProvider>(context, listen: false);

    if (order.isLoading) {
      return Container();
    }
    return Visibility(
      visible: true,
      child: orderDetail!.orderStatus == 'pending' ||
              orderDetail!.orderStatus == 'on-hold'
          ? Container(
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryColor, HexColor("960000")])),
              height: 30.h,
              width: 50.w,
              child: TextButton(
                onPressed: () async {
                  // print(orderDetail!.paymentUrl);
                  // await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => CheckoutWebView(
                  //               url: orderDetail!.paymentUrl,
                  //               fromOrder: true,
                  //             ))).then((value) {
                  //   this.setState(() {});
                  //   this.loadOrder();
                  // });
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('pay')!,
                  style: TextStyle(
                      color: Colors.white, fontSize: responsiveFont(10)),
                ),
              ),
            )
          : Container(),
    );
  }

  Widget itemList(Voucher voucher, int index) {
    String? price;
    String? priceName;
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
                imageUrl: voucher.bannerImg.toString(),
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
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: Text(
                          voucher.voucherName.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: responsiveFont(14.5)),
                        ),
                        // subtitle: Text(priceName.toString()),
                      ),
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
                    //             color: HexColor("960000"),
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
                          Spacer(),
                          Text(
                            // stringToCurrency(
                            //     double.parse(cart!.cartItems![index].price),
                            //     context),
                            voucher.soldPrice.toString() + " Vnd",
                            style: TextStyle(
                                fontSize: responsiveFont(10),
                                color: HexColor("960000"),
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     confirmDeletePopDialog(
                              //         cart!.cartItems![index].id!);
                              //   },
                              //   child: Container(
                              //       width: 16.w,
                              //       height: 16.h,
                              //       child:
                              //           Image.asset("images/cart/trash.png")),
                              // ),
                              SizedBox(
                                width: 15,
                              ),
                              // Container(
                              //   width: 16.w,
                              //   height: 16.h,
                              //   child: InkWell(
                              //     onTap: () {
                              //       if (cart!.cartItems![index].quantity! > 1) {
                              //         setState(() {
                              //           cart!.cartItems![index].quantity =
                              //               cart!.cartItems![index].quantity! -
                              //                   1;
                              //           if (cart!.cartItems![index].quantity ==
                              //               cart!.cartItems![index]
                              //                   .oldQuantity) {
                              //             cart!.cartItems![index].isChange =
                              //                 false;
                              //           } else {
                              //             cart!.cartItems![index].isChange =
                              //                 true;
                              //           }
                              //           updateCart = cart!.cartItems!.any(
                              //               (value) => value.isChange == true);
                              //         });
                              //         decreaseQuantity(index);
                              //       }
                              //     },
                              //     child: cart!.cartItems![index].quantity! > 1
                              //         ? Image.asset("images/cart/minusDark.png")
                              //         : Image.asset("images/cart/minus.png"),
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              Text("x" + "1"),
                              SizedBox(
                                width: 10,
                              ),
                              // Container(
                              //   width: 16.w,
                              //   height: 16.h,
                              //   child: InkWell(
                              //       onTap: cart!.cartItems![index].voucher!
                              //                       .inventory !=
                              //                   null &&
                              //               cart!.cartItems![index].voucher!
                              //                       .inventory! <=
                              //                   cart!
                              //                       .cartItems![index].quantity!
                              //           ? null
                              //           : () {
                              //               setState(() {
                              //                 cart!.cartItems![index].quantity =
                              //                     cart!.cartItems![index]
                              //                             .quantity! +
                              //                         1;
                              //                 if (cart!.cartItems![index]
                              //                         .quantity ==
                              //                     cart!.cartItems![index]
                              //                         .oldQuantity) {
                              //                   cart!.cartItems![index]
                              //                       .isChange = false;
                              //                 } else {
                              //                   cart!.cartItems![index]
                              //                       .isChange = true;
                              //                 }
                              //                 updateCart = cart!.cartItems!.any(
                              //                     (value) =>
                              //                         value.isChange == true);
                              //               });
                              //               increaseQuantity(index);
                              //             },
                              //       child: cart!.cartItems![index].voucher!
                              //                       .inventory !=
                              //                   null &&
                              //               cart!.cartItems![index].voucher!
                              //                       .inventory! >
                              //                   cart!
                              //                       .cartItems![index].quantity!
                              //           ? Image.asset("images/cart/plus.png")
                              //           : Image.asset(
                              //               "images/cart/plusDark.png")),
                              // )
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

  confirmCancelPopDialog(int orderId) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "?????ng ?? h???y ????n h??ng n??y?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // Text(
                        //   "B???n c?? mu???n ????ng xu???t kh???i t??i kho???n?",
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //       fontSize: responsiveFont(12),
                        //       fontWeight: FontWeight.w400),
                        // ),
                      ],
                    ),
                    Container(
                        child: Column(
                      children: [
                        Container(
                          color: Colors.black12,
                          height: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(false),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15)),
                                      color: primaryColor),
                                  child: Text(
                                    "Kh??ng",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async => {
                                  await Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .cancelOrder(orderDetail!.id!)
                                      .then((value) => this.setState(() {
                                            if (value) {
                                              snackBar(context,
                                                  message:
                                                      'H???y ????n h??ng th??nh c??ng!');
                                            } else {
                                              snackBar(context,
                                                  message:
                                                      'H???y ????n h??ng th???t b???i!');
                                            }
                                          })),
                                  Navigator.pop(context)
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15)),
                                      color: Colors.white),
                                  child: Text(
                                    "?????ng ??",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ))
                  ],
                ),
              );
            },
          )),
    );
  }
}
