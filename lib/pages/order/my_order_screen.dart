import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:nyoba/models/order.dart';
import 'package:nyoba/pages/order/order_detail_screen.dart';
import 'package:nyoba/provider/home_provider.dart';
import 'package:nyoba/provider/order_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../utils/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOrder extends StatefulWidget {
  MyOrder({Key? key}) : super(key: key);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  String currentStatus = '';
  TextEditingController searchController = new TextEditingController();

  String search = '';
  int currType = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Order> orders = List.empty(growable: true);
  bool isLoading = true;
  final DateFormat serverFormater = DateFormat('dd-MM-yyyy');

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          context.read<OrderProvider>().tempOrder.length % 10 == 0) {
        debugPrint("Load Data From Scroll");
        loadListOrder();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<OrderProvider>().resetPage();
      debugPrint("Load Data From Init");
      loadListOrder();
    });
  }

  loadListOrder() {
    // isLoading = true;
    this.setState(() {});
    if (Session.data.getBool('isLogin')!) {
      // if (isNumeric(search)) {
      //   context
      //       .read<OrderProvider>()
      //       .fetchOrders(status: currentStatus, orderId: search)
      //       .then((value) => this.setState(() {}));
      // } else {
      context
          .read<OrderProvider>()
          .fetchOrdersV2(context, currentStatus)
          .then((value) => this.setState(() {
                orders = value.reversed.toList();
                isLoading = false;
                // for (var element in orders) {
                //   print(element.id);
                // }
              }));
      // }
      _refreshController.refreshCompleted();
    }
  }

  bool isNumeric(String s) {
    return int.tryParse(s) != null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final orders = context.select((OrderProvider n) => n);
    Widget buildOrders = SmartRefresher(
      controller: _refreshController,
      scrollController: _scrollController,
      onRefresh: loadListOrder,
      child: Container(
        child: Consumer<OrderProvider>(builder: (context, value, child) {
          // if (value.isLoading && value.orderPage == 1) {
          //   return OrderListShimmer();
          // }
          if (orders.length == 0) {
            return buildTransactionEmpty();
          }
          return ListView.builder(
              itemCount: orders.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                return orderItem(orders[i]);
              });
        }),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        // ),
        title: Text(
          "????n h??ng c???a t??i",
          style: TextStyle(color: Colors.black, fontSize: responsiveFont(16)),
        ),
      ),
      body: !Session.data.getBool('isLogin')!
          ? Center(
              child: buildNoAuth(context),
            )
          : isLoading
              ? customLoading()
              : Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      // Container(
                      //   height: 30.h,
                      //   child: TextField(
                      //     controller: searchController,
                      //     style: TextStyle(fontSize: 14),
                      //     textAlignVertical: TextAlignVertical.center,
                      //     onSubmitted: (value) {
                      //       setState(() {});
                      //       context.read<OrderProvider>().resetPage();
                      //       loadListOrder();
                      //     },
                      //     onChanged: (value) {
                      //       setState(() {
                      //         search = value;
                      //       });
                      //     },
                      //     textInputAction: TextInputAction.search,
                      //     decoration: InputDecoration(
                      //       isDense: true,
                      //       isCollapsed: true,
                      //       filled: true,
                      //       border: new OutlineInputBorder(
                      //         borderRadius: const BorderRadius.all(
                      //           const Radius.circular(5),
                      //         ),
                      //       ),
                      //       prefixIcon: Icon(Icons.search),
                      //       hintText: AppLocalizations.of(context)!
                      //           .translate('search_transaction'),
                      //       hintStyle: TextStyle(fontSize: responsiveFont(12)),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        height: 15,
                      ),
                      buildTabStatus(),
                      Container(
                        height: 10,
                      ),
                      Expanded(
                        child: buildOrders,
                      ),
                      // if (orders.length == 0)
                      //   Center(
                      //     child: customLoading(),
                      //   ),
                    ],
                  ),
                ),
    );
  }

  Widget orderItem(Order orderModel) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(5),
                //         color: HexColor("c4c4c4")),
                //     height: 50.h,
                //     width: 50.h,
                //     child:
                //         // orderModel.productItems![0].image == null &&
                //         //         orderModel.productItems![0].image == ''
                //         //     ?
                //         Icon(
                //       Icons.image_not_supported_outlined,
                //     )
                //     // : CachedNetworkImage(
                //     //     imageUrl: orderModel.productItems![0].image!,
                //     //     placeholder: (context, url) => Container(),
                //     //     errorWidget: (context, url, error) =>
                //     //         Icon(Icons.image_not_supported_outlined)),
                //     ),
                // Container(
                //   width: 0,
                // ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        convertHtmlUnescape(
                            "Order s??? " + orderModel.id.toString()),
                        style: TextStyle(
                            fontSize: responsiveFont(12),
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${orderModel.totalPrice} vnd",
                        style: TextStyle(fontSize: responsiveFont(10)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // Visibility(
          //   visible: orderModel.orderItems!.length > 1,
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 10),
          //     child: Text(
          //       "+${orderModel.orderItems!.length - 1} S???n ph???m kh??c}",
          //       style: TextStyle(fontSize: responsiveFont(10)),
          //     ),
          //   ),
          // ),
          Container(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "T???ng ti???n",
                      style: TextStyle(fontSize: responsiveFont(9)),
                    ),
                    Text(
                      orderModel.totalPrice.toString() + " vnd",
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [primaryColor, HexColor("960000")])),
                  height: 30.h,
                  child: TextButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetail(
                                    orderId: orderModel.id.toString(),
                                  ))).then((value) {
                        // this.loadListOrder();
                      });
                    },
                    child: Text(
                      "Xem th??m",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: responsiveFont(10),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID c???a order : ${orderModel.id}",
                      style: TextStyle(
                        fontSize: responsiveFont(10),
                      ),
                    ),
                    // Text(
                    //   orderModel.orderStatus.toString(),
                    //   style: TextStyle(
                    //       fontSize: responsiveFont(8),
                    //       fontWeight: FontWeight.w500),
                    // )
                  ],
                ),
                buildStatusOrder(orderModel.orderStatus)
              ],
            ),
          ),
          Container(
            color: HexColor("c4c4c4"),
            height: 1,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
        ],
      ),
    );
  }

  Widget buildStatusOrder(String? status) {
    var color = 'FFFFFF';
    var colorText = 'FFFFFF';
    var statusText = '';

    if (status == 'pending') {
      color = 'FFCDD2';
      colorText = 'B71C1C';
      statusText = 'Waiting For Payment';
    } else if (status == 'on-hold') {
      color = 'FFF9C4';
      colorText = 'F57F17';
      statusText = 'On Hold';
    } else if (status == 'processing') {
      color = 'FFF9C4';
      colorText = 'F57F17';
      statusText = 'Processing';
    } else if (status == 'completed') {
      color = 'C8E6C9';
      colorText = '1B5E20';
      statusText = 'Completed';
    } else if (status == 'cancelled') {
      color = 'CFD8DC';
      colorText = '333333';
      statusText = 'Canceled';
    } else if (status == 'refunded') {
      color = 'B2EBF2';
      colorText = '006064';
      statusText = 'Refunded';
    } else if (status == 'failed') {
      color = 'FFCCBC';
      colorText = 'BF360C';
      statusText = 'Failed';
    }

    return Container(
      color: HexColor(color),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(
        statusText,
        style:
            TextStyle(fontSize: responsiveFont(10), color: HexColor(colorText)),
      ),
    );
  }

  Widget buildTabStatus() {
    return Container(
      height: 65.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 0;
                currentStatus = '';
                isLoading = true;
              });
              context.read<OrderProvider>().resetPage();
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 0
                          ? Image.asset("images/order/all.png")
                          : Image.asset("images/order/all_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "T???t c??? ????n h??ng",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(8)),
                  )
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       currType = 1;
          //       currentStatus = 'Confirm';
          //       isLoading = true;
          //     });
          //     context.read<OrderProvider>().resetPage();
          //     loadListOrder();
          //   },
          //   child: Container(
          //     width: 70.w,
          //     height: 60.h,
          //     child: Column(
          //       children: [
          //         Container(
          //             width: 30.w,
          //             height: 30.h,
          //             child: currType == 1
          //                 ? Image.asset("images/order/pending.png")
          //                 : Image.asset("images/order/pending_dark.png")),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Text(
          //           "X??c nh???n",
          //           textAlign: TextAlign.center,
          //           style: TextStyle(fontSize: responsiveFont(8)),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       currType = 2;
          //       currentStatus = 'on-hold';
          //     });
          //     context.read<OrderProvider>().resetPage();
          //     loadListOrder();
          //   },
          //   child: Container(
          //     width: 70.w,
          //     height: 60.h,
          //     child: Column(
          //       children: [
          //         Container(
          //             width: 30.w,
          //             height: 30.h,
          //             child: currType == 2
          //                 ? Image.asset("images/order/hold.png")
          //                 : Image.asset("images/order/hold_dark.png")),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Text(
          //           AppLocalizations.of(context)!.translate('on_hold')!,
          //           textAlign: TextAlign.center,
          //           style: TextStyle(fontSize: responsiveFont(8)),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 3;
                isLoading = true;
                currentStatus = 'Processing';
              });
              context.read<OrderProvider>().resetPage();
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 3
                          ? Image.asset("images/order/processing.png")
                          : Image.asset("images/order/processing_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "??ang th???c hi???n",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(8)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 4;
                isLoading = true;
                currentStatus = 'Completed';
              });
              context.read<OrderProvider>().resetPage();
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 4
                          ? Image.asset("images/order/completed.png")
                          : Image.asset("images/order/completed_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Ho??n th??nh",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(8)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 5;
                isLoading = true;
                currentStatus = 'Canceled';
              });
              context.read<OrderProvider>().resetPage();
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 5
                          ? Image.asset("images/order/cancel.png")
                          : Image.asset("images/order/cancel_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "H???y",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(8)),
                  )
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       currType = 6;
          //       isLoading = true;
          //       currentStatus = 'Used';
          //     });
          //     context.read<OrderProvider>().resetPage();
          //     loadListOrder();
          //   },
          //   child: Container(
          //     width: 70.w,
          //     height: 60.h,
          //     child: Column(
          //       children: [
          //         Container(
          //             width: 30.w,
          //             height: 30.h,
          //             child: currType == 6
          //                 ? Image.asset("images/order/hold.png")
          //                 : Image.asset("images/order/hold_dark.png")),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Text(
          //           "???? s??? d???ng",
          //           textAlign: TextAlign.center,
          //           style: TextStyle(fontSize: responsiveFont(8)),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       currType = 7;
          //       isLoading = true;
          //       currentStatus = 'Failed';
          //     });
          //     context.read<OrderProvider>().resetPage();
          //     loadListOrder();
          //   },
          //   child: Container(
          //     width: 70.w,
          //     height: 60.h,
          //     child: Column(
          //       children: [
          //         Container(
          //             width: 30.w,
          //             height: 30.h,
          //             child: currType == 7
          //                 ? Image.asset("images/order/failed.png")
          //                 : Image.asset("images/order/failed_dark.png")),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Text(
          //           "Th???t b???i",
          //           textAlign: TextAlign.center,
          //           style: TextStyle(fontSize: responsiveFont(8)),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  buildTransactionEmpty() {
    final noTransaction =
        Provider.of<HomeProvider>(context, listen: false).imageNoTransaction;
    return Center(
      child: Column(
        children: [
          noTransaction.image == null
              ? Icon(
                  Icons.shopping_cart,
                  color: primaryColor,
                  size: 75,
                )
              : CachedNetworkImage(
                  imageUrl: noTransaction.image!,
                  height: MediaQuery.of(context).size.height * 0.4,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Icon(
                        Icons.shopping_cart,
                        color: primaryColor,
                        size: 75,
                      )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "Kh??ng c?? ????n h??ng n??o",
              style: TextStyle(
                  fontSize: responsiveFont(14), fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
