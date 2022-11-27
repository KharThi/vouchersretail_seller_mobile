// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nyoba/models/customer.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/pages/order/order_success_screen.dart';
import 'package:nyoba/provider/order_provider.dart';
import 'package:nyoba/provider/product_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slugify/slugify.dart';

import '../../search/search_screen_customer.dart';

class ModalSheetCartCombo extends StatefulWidget {
  final Combo? product;
  final String? type;
  // final int? quantity;
  final Future<dynamic> Function()? loadCount;
  ModalSheetCartCombo({Key? key, this.product, this.type, this.loadCount})
      : super(key: key);

  @override
  _ModalSheetCartComboState createState() => _ModalSheetCartComboState();
}

class _ModalSheetCartComboState extends State<ModalSheetCartCombo> {
  int index = 0;
  int indexColor = 0;
  int counter = 1;
  int? quantity = 1;

  List<int> listQuantity = List.empty(growable: true);

  List<ProductAttributeModel> attributes = [];
  List<ProductVariation> variation = [];
  List<Customer> customers = [];

  bool load = false;
  bool isAvailable = false;
  bool isOutStock = false;

  double variationPrice = 0;
  double variationSalePrice = 0;

  int? variationStock = 0;
  Map<String, dynamic>? variationResult;
  String? variationName;

  String _selectedDate = 'Bấm vào để chọn ngày';
  String _forCallApiDate = "";

  OrderProvider? orderProvider;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      locale: const Locale("vi", "VN"),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (d != null)
      setState(() {
        print("date" + d.toString());
        var formatter = new DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(d);
        _forCallApiDate = formattedDate;
        _selectedDate = new DateFormat.yMMMMd("vi_VN").format(d);
      });
  }

  /*add to cart*/
  void addCart(Combo product) async {
    // print('Add Cart');
    // await Provider.of<OrderProvider>(context, listen: false)
    //     .addCartCombo(context, widget.product, _forCallApiDate, customers.first)
    //     .then((value) {
    //   this.setState(() {
    //     print("add to cart return value: " + value.toString());
    //     if (value == true) {
    //       snackBar(context, message: "Thêm vào giỏ hàng thành công!");
    //     } else {
    //       snackBar(context, message: "Thêm vào giỏ hàng thất bại!");
    //     }
    //   });
    // });
    // Navigator.pop(context);
    // snackBar(context,
    //     message:
    //         AppLocalizations.of(context)!.translate('product_success_atc')!);
  }

  /*get variant id, if product have variant*/
  checkProductVariant(ProductModel productModel) async {
    setState(() {
      load = true;
    });
    var tempVar = [];
    variation.forEach((element) {
      setState(() {
        tempVar.add(element.value);
      });
    });
    variationName = tempVar.join();
    print(variationName);
    final product = Provider.of<ProductProvider>(context, listen: false);
    final Future<Map<String, dynamic>?> productResponse =
        product.checkVariation(productId: productModel.id, list: variation);

    productResponse.then((value) {
      printLog(value.toString(), name: "Response Variation");
      if (value!['variation_id'] != 0) {
        setState(() {
          productModel.variantId = value['variation_id'];
          load = false;
          variationResult = value;
          variationPrice = double.parse(value['data']['price'].toString());

          if (value['data']['wholesales'] != null &&
              value['data']['wholesales'].isNotEmpty) {
            if (value['data']['wholesales'][0]['price'].isNotEmpty &&
                Session.data.getString('role') == 'wholesale_customer') {
              variationPrice =
                  double.parse(value['data']['wholesales'][0]['price']);
            }
          }
          if (value['data']['stock_status'] == 'instock' &&
                  value['data']['stock_quantity'] == null ||
              value['data']['stock_quantity'] == 0) {
            variationStock = 999;
            isAvailable = true;
            isOutStock = false;
          } else if (value['data']['stock_status'] == 'outofstock') {
            print('outofstock');
            isAvailable = true;
            isOutStock = true;
            variationStock = 0;
          } else if (value['data']['price'] == 0) {
            print('price not set');
            isAvailable = false;
            isOutStock = false;
            variationStock = 0;
          } else {
            print('else');
            variationStock = value['data']['stock_quantity'];
            isAvailable = true;
            isOutStock = false;
          }
        });
      } else {
        if (mounted)
          setState(() {
            variationPrice = 0;
            isAvailable = false;
            load = false;
          });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getListCustomerOrder();
    // print("object " + widget.product!.prices!.length.toString());
    for (var i = 0; i < widget.product!.prices!.length; i++) {
      widget.product!.prices![i].quantity = 0;
    }
    // widget.quantity = 1;
    // initVariation();
  }

  /*init variation & check if variation true*/
  // initVariation() {
  //   if (widget.product!.attributes!.isNotEmpty &&
  //       widget.product!.type == 'variable') {
  //     widget.product!.attributes!.forEach((element) {
  //       if (element.variation == true) {
  //         print("Variation True");
  //         setState(() {
  //           attributes.add(element);
  //           element.selectedVariant = element.options!.first;
  //           if (element.id != 0 && element.id != null) {
  //             var _value =
  //                 element.options!.first.toString().replaceAll('.', '-');
  //             variation.add(new ProductVariation(
  //                 id: element.id,
  //                 value: slugify(_value).replaceAll('--', '-'),
  //                 columnName: 'pa_${slugify(element.name!)}'));
  //           } else {
  //             variation.add(new ProductVariation(
  //                 id: element.id,
  //                 value: element.options!.first,
  //                 columnName: element.name));
  //           }
  //         });
  //       }
  //     });
  //     checkProductVariant(widget.product!);
  //   }
  //   if (widget.product!.type == 'simple' && widget.product!.productStock != 0) {
  //     setState(() {
  //       isAvailable = true;
  //     });
  //   }
  // }

  Future onFinishBuyNow() async {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => OrderSuccess()));
  }

  buyNow() async {
    print("Buy Now");
    await Provider.of<OrderProvider>(context, listen: false).buyNowCombo(
        context,
        widget.product,
        listQuantity,
        _forCallApiDate,
        customers.first,
        onFinishBuyNow);
  }

  getListCustomerOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? musicsString = prefs.getString('list_customer_order');
    print("object" + musicsString.toString());

    if (musicsString != null) {
      for (Map<String, dynamic> item in json.decode(musicsString)) {
        customers.add(Customer.fromJson(item));
      }
      setState(() {});
      // customers = Customer.fromJson(musicsString);
      // customers = json.decode(musicsString);
    }
  }

  saveListCustomerOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var s = json.encode(customers);
    prefs.setString('list_customer_order', s);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8,
        runSpacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: attributes.isNotEmpty,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: attributes.length,
                      itemBuilder: (context, i) {
                        return buildVariations(i);
                      })),
              Container(
                height: 1,
                width: double.infinity,
                color: HexColor("c4c4c4"),
                margin: EdgeInsets.only(bottom: 15),
              ),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: load
                      ? Shimmer.fromColors(
                          child: Container(
                            height: 25.h,
                            color: Colors.white,
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!)
                      :
                      // false
                      //     ? Container(
                      //         alignment: Alignment.center,
                      //         child: Text(
                      //           AppLocalizations.of(context)!
                      //               .translate('select_var_not_avail')!,
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       )
                      //     :
                      SizedBox(
                          height: widget.product!.prices!.length * 60,
                          child: new ListView.builder(
                            itemCount: widget.product!.prices!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          // AppLocalizations.of(context)!
                                          //     .translate('qty')!
                                          widget.product!.prices![index]
                                              .priceLevelName
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: responsiveFont(12)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 16.w,
                                            height: 16.h,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (widget
                                                          .product!
                                                          .prices![index]
                                                          .quantity! >
                                                      0) {
                                                    widget
                                                        .product!
                                                        .prices![index]
                                                        .quantity = (widget
                                                            .product!
                                                            .prices![index]
                                                            .quantity! -
                                                        1);
                                                    print(widget
                                                        .product!
                                                        .prices![index]
                                                        .quantity);
                                                  }
                                                });
                                              },
                                              child: widget
                                                          .product!
                                                          .prices![index]
                                                          .quantity! >
                                                      0
                                                  ? Image.asset(
                                                      "images/cart/minusDark.png")
                                                  : Image.asset(
                                                      "images/cart/minus.png"),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text((widget.product!.prices![index]
                                                  .quantity)
                                              .toString()),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: 16.w,
                                            height: 16.h,
                                            child: InkWell(
                                                onTap:
                                                    // isOutStock
                                                    //     ? null
                                                    //     :
                                                    () {
                                                  setState(() {
                                                    // widget.product!
                                                    //     .cartQuantity = widget
                                                    //         .product!
                                                    //         .cartQuantity! +
                                                    //     1;
                                                    // if (quantity! > 1) {
                                                    widget
                                                        .product!
                                                        .prices![index]
                                                        .quantity = (widget
                                                            .product!
                                                            .prices![index]
                                                            .quantity! +
                                                        1);
                                                    print(widget
                                                        .product!
                                                        .prices![index]
                                                        .quantity);
                                                    // }
                                                  });
                                                },
                                                child: !isOutStock
                                                    ? Image.asset(
                                                        "images/cart/plus.png")
                                                    : Image.asset(
                                                        "images/cart/plusDark.png")),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // true
                                  //     ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        // stringToCurrency(
                                        //     double.parse(widget.product!.price
                                        //             .toString())
                                        //         .toDouble(),
                                        //     context),
                                        widget.product!.prices!.isNotEmpty
                                            ? (widget.product!.prices![index]
                                                            .price! *
                                                        widget
                                                            .product!
                                                            .prices![index]
                                                            .quantity!)
                                                    .toString() +
                                                " Vnd"
                                            : "null",
                                        style: TextStyle(
                                            color: HexColor("960000"),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      // Text(
                                      //   quantity == 999
                                      //       ? '${AppLocalizations.of(context)!.translate('stock')} : ${AppLocalizations.of(context)!.translate('available')}'
                                      //       : '${AppLocalizations.of(context)!.translate('stock')} : ${quantity}',
                                      // )
                                    ],
                                  )
                                  // : Visibility(
                                  //     visible: true,
                                  //     child: Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.end,
                                  //       children: [
                                  //         Text(
                                  //           stringToCurrency(
                                  //               variationPrice, context),
                                  //           style: TextStyle(
                                  //               color: HexColor("960000"),
                                  //               fontWeight: FontWeight.w500),
                                  //         ),
                                  //         Text(
                                  //           variationStock == 999
                                  //               ? '${AppLocalizations.of(context)!.translate('stock')} : ${AppLocalizations.of(context)!.translate('in_stock')}'
                                  //               : '${AppLocalizations.of(context)!.translate('stock')} : $variationStock',
                                  //         )
                                  //       ],
                                  //     ))
                                ],
                              );
                            },
                          ),
                        )),
              Visibility(
                visible: quantity == null || quantity == 0,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "Sản phẩm hiện tại đã hết hàng!",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              // widget.product!.isRequireProfileInfo != false
              //     ?
              Container(
                height: 1,
                width: double.infinity,
                color: HexColor("c4c4c4"),
                margin: EdgeInsets.only(bottom: 15),
              )
              // : Container()
              ,
              // widget.product!.isRequireProfileInfo != false
              //     ?
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    // AppLocalizations.of(context)!
                    //     .translate('qty')!
                    "   Chủ sở hữu",
                    style: TextStyle(fontSize: responsiveFont(12)),
                  ),
                ),
              ])
              // : Container()
              ,
              // widget.product!.isRequireProfileInfo != false
              //     ?
              Container(
                  // height: 25.h,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        children: customers.map((personone) {
                          return Container(
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    personone.userInfo!.userName.toString()),
                                subtitle: Text(""),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.redAccent),
                                  child: Icon(Icons.delete),
                                  onPressed: () {
                                    //delete action for this button
                                    customers.removeWhere((element) {
                                      return element.id == personone.id;
                                    }); //go through the loop and match content to delete from list
                                    setState(() {
                                      saveListCustomerOrder();
                                      customers = [];
                                      getListCustomerOrder();
                                      //refresh UI after deleting element from list
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      customers.length < 1
                          ? Container(
                              width: 400,
                              height: 40,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchScreenCustomer()))
                                      .then((result) => setState(() {
                                            customers = [];
                                            getListCustomerOrder();
                                          }));
                                },
                                icon: Icon(Icons.add),
                                label: Text("Bấm vào đây để thêm chủ sở hữu"),
                              ),
                            )
                          : Container(),
                    ],
                  ))
              // : Container()
              ,
              Container(
                height: 1,
                width: double.infinity,
                color: HexColor("c4c4c4"),
                margin: EdgeInsets.only(bottom: 15),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    // AppLocalizations.of(context)!
                    //     .translate('qty')!
                    "   Vui lòng chọn ngày",
                    style: TextStyle(fontSize: responsiveFont(12)),
                  ),
                ),
              ]),
              Container(
                  // height: 25.h,
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Container(
                      child: Card(
                        child: ListTile(
                          title: InkWell(
                            child: Text(_selectedDate),
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                          subtitle: Text(""),
                          trailing: IconButton(
                            icon: Icon(Icons.calendar_today),
                            tooltip: 'Tap to open date picker',
                            onPressed: () {
                              // showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime(2015, 8),
                              //   lastDate: DateTime(2101),
                              // );
                              _selectDate(context);
                            },
                          ),
                        ),
                      ),
                    )
                  ]
                      // }).toList(),
                      ))
            ],
          ),
          Visibility(
            visible: widget.type == 'add',
            child: Align(
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
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: 132.w,
                  height: 30.h,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: widget.product!.vouchers!.length == 0
                                ? Colors.grey
                                : HexColor("960000"), //Color of the border
                            //Style of the border
                          ),
                          alignment: Alignment.center,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5))),
                      onPressed:
                          // widget.product!.inventory == 0
                          //     ? null
                          //     :
                          () {
                        addCart(widget.product!);
                        // if (widget.product!.inventory == 0) {
                        //   addCart(widget.product!);
                        // } else {
                        //   Navigator.pop(context);
                        //   snackBar(context,
                        //       message: "Sản phẩm hết hàng!");
                        // }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: responsiveFont(9),
                            color: widget.product!.vouchers!.length == 0
                                ? Colors.grey
                                : HexColor("960000"),
                          ),
                          Text(
                            // AppLocalizations.of(context)!
                            //     .translate('add_to_cart')!
                            "Thêm vào giỏ hàng",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveFont(9),
                                color: widget.product!.vouchers!.length != 0 &&
                                        widget.product!.vouchers!.length >= 1
                                    ? HexColor("960000")
                                    : Colors.grey),
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.type == 'buy',
            child: Align(
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
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: !(widget.product!.vouchers!.length != 0 &&
                                  widget.product!.vouchers!.length >= 1)
                              ? [Colors.black12, Colors.grey]
                              : [primaryColor, HexColor("960000")])),
                  width: double.infinity,
                  height: 30.h,
                  child: TextButton(
                    onPressed: () {
                      bool check1 = false;
                      // ignore: unnecessary_null_comparison
                      bool check2 = customers != null;
                      bool check3 = _selectedDate != "Bấm vào để chọn ngày";
                      for (var element in widget.product!.prices!) {
                        if (element.quantity != null) {
                          check1 = true;
                        }
                      }
                      buyNow();
                      // if (check1) {
                      //   if (check2) {
                      //     if (check3) {
                      //       buyNow();
                      //     } else {
                      //       snackBar(context,
                      //           message:
                      //               'Vui lòng chon ngày sử dụng sản phẩm!');
                      //     }
                      //   } else {
                      //     snackBar(context,
                      //         message:
                      //             'Vui lòng chon chủ sở hữu cho đơn hàng!');
                      //   }
                      // } else {
                      //   // ignore: deprecated_member_use
                      //   // Scaffold.of(context).showSnackBar(SnackBar(
                      //   //     content: Text('Ticket Added Sucessfully')));
                      //   snackBar(context,
                      //       message: 'Bạn chưa chon số lượng cho sản phẩm!');
                      // }
                    },
                    // !isAvailable || load
                    //     ? null
                    //     : () {
                    //         buyNow();
                    //       },
                    child: Text(
                      "Mua ngay",
                      style: TextStyle(
                          color: Colors.white, fontSize: responsiveFont(10)),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildVariations(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
          child: Text(
            attributes[index].name!,
            style: TextStyle(fontSize: responsiveFont(12)),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: attributes[index].options!.length,
              itemBuilder: (context, i) {
                return Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            if (attributes[index].id != 0) {
                              attributes[index].selectedVariant =
                                  attributes[index]
                                      .options![i]
                                      .toString()
                                      .toLowerCase();
                            } else {
                              attributes[index].selectedVariant =
                                  attributes[index].options![i];
                            }
                          });
                          variation.forEach((element) {
                            if (element.id != 0) {
                              if (element.columnName ==
                                  'pa_${slugify(attributes[index].name!)}') {
                                print(attributes[index].options![i]);
                                setState(() {
                                  var _value = attributes[index]
                                      .options![i]
                                      .replaceAll('.', '-');
                                  element.value =
                                      slugify(_value).replaceAll('--', '-');
                                });
                              }
                            } else {
                              if (element.columnName ==
                                  attributes[index].name) {
                                setState(() {
                                  element.value = attributes[index].options![i];
                                });
                              }
                            }
                          });
                          // checkProductVariant(widget.product!);
                        },
                        child: attributes[index].id == 0
                            ? sizeButton(
                                attributes[index].options![i], index, i)
                            : sizeButtonPA(
                                attributes[index].options![i], index, i)),
                    Container(
                      width: 10,
                    ),
                  ],
                );
              }),
        )
      ],
    );
  }

  Widget colorButton(String color, int indexes) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: indexColor == indexes
                ? Colors.transparent
                : HexColor("960000")),
        borderRadius: BorderRadius.circular(5),
        color: indexColor == indexes ? primaryColor : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        color,
        style: TextStyle(
            color: indexColor == indexes ? Colors.white : primaryColor),
      ),
    );
  }

  Widget sizeButton(String variant, int groupVariant, int subVariant) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: attributes[groupVariant].selectedVariant ==
                    attributes[groupVariant].options![subVariant]
                ? Colors.transparent
                : HexColor("960000")),
        borderRadius: BorderRadius.circular(5),
        color: attributes[groupVariant].selectedVariant ==
                attributes[groupVariant].options![subVariant]
            ? primaryColor
            : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        variant,
        style: TextStyle(
            color: attributes[groupVariant].selectedVariant ==
                    attributes[groupVariant].options![subVariant]
                ? Colors.white
                : primaryColor),
      ),
    );
  }

  Widget sizeButtonPA(String variant, int groupVariant, int subVariant) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: attributes[groupVariant].selectedVariant!.toLowerCase() ==
                    attributes[groupVariant]
                        .options![subVariant]
                        .toString()
                        .toLowerCase()
                ? Colors.transparent
                : HexColor("960000")),
        borderRadius: BorderRadius.circular(5),
        color: attributes[groupVariant].selectedVariant!.toLowerCase() ==
                attributes[groupVariant]
                    .options![subVariant]
                    .toString()
                    .toLowerCase()
            ? primaryColor
            : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        variant,
        style: TextStyle(
            color: attributes[groupVariant].selectedVariant!.toLowerCase() ==
                    attributes[groupVariant]
                        .options![subVariant]
                        .toString()
                        .toLowerCase()
                ? Colors.white
                : primaryColor),
      ),
    );
  }
}
