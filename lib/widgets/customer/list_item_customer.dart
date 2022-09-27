import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nyoba/models/customer.dart';
import 'package:nyoba/pages/product/product_detail_screen.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/pages/product/product_detail_screen_combo.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/product/product_detail_screen_voucher.dart';

class ListItemCustomer extends StatelessWidget {
  final Customer? customer;
  final int? i, itemCount;

  ListItemCustomer({this.customer, this.i, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // if (customer!.type == "Voucher") {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => ProductDetailVoucher(
        //                 productId: product!.id.toString(),
        //               )));
        // } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? musicsString = await prefs.getString('list_customer_order');
        if (musicsString != null) {
          List<Customer> cutomers = [];
          for (Map<String, dynamic> item in json.decode(musicsString)) {
            cutomers.add(Customer.fromJson(item));
          }
          cutomers.add(customer!);
          var s = json.encode(cutomers);
          prefs.setString('list_customer_order', s);
        } else {
          List<Customer> cutomers = [];
          cutomers.add(customer!);
          var s = json.encode(cutomers);
          prefs.setString('list_customer_order', s);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 60.h,
                  height: 60.h,
                  child: customer!.userInfo!.avatarLink.toString().isEmpty
                      ? Icon(
                          Icons.image_not_supported,
                          size: 50,
                        )
                      : CachedNetworkImage(
                          imageUrl: customer!.userInfo!.avatarLink.toString(),
                          placeholder: (context, url) => customLoading(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer!.userInfo!.userName.toString(),
                            style: TextStyle(
                                fontSize: responsiveFont(10),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          HtmlWidget(
                            // product!.description!.length > 100
                            //     ? '${product!.description!.substring(0, 100)} ...'
                            //     :
                            customer!.userInfo!.phoneNumber.toString(),
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: responsiveFont(9)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          // Visibility(
                          //   visible: product!.price != 0,
                          //   child: RichText(
                          //     text: TextSpan(
                          //       style: TextStyle(color: Colors.black),
                          //       children: <TextSpan>[
                          //         // TextSpan(
                          //         //     text: stringToCurrency(
                          //         //         double.parse(
                          //         //             product!.price.toString()),
                          //         //         context),
                          //         //     style: TextStyle(
                          //         //         decoration:
                          //         //             TextDecoration.lineThrough,
                          //         //         fontSize: responsiveFont(9),
                          //         //         color: HexColor("C4C4C4"))),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          // product!.type == 'simple'
                          //     ? RichText(
                          //         text: TextSpan(
                          //           style: TextStyle(color: Colors.black),
                          //           children: <TextSpan>[
                          //             TextSpan(
                          //                 text: stringToCurrency(
                          //                     double.parse(
                          //                         product!.price.toString()),
                          //                     context),
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.w600,
                          //                     fontSize: responsiveFont(11),
                          //                     color: secondaryColor)),
                          //           ],
                          //         ),
                          //       )
                          //     : RichText(
                          //         text: TextSpan(
                          //           style: TextStyle(color: Colors.black),
                          //           children: <TextSpan>[
                          //             product!.price!.toString().isEmpty
                          //                 ? TextSpan(
                          //                     text: '',
                          //                     style: TextStyle(
                          //                         fontWeight: FontWeight.w600,
                          //                         fontSize: responsiveFont(11),
                          //                         color: secondaryColor))
                          //                 : TextSpan(
                          //                     text: product!.price.toString() ==
                          //                             product!.price.toString()
                          //                         ?
                          //                         // '${stringToCurrency(100, context)}' +
                          //                         product!.price.toString() +
                          //                             " Vnd"
                          //                         : '${stringToCurrency(100, context)} - ${stringToCurrency(50, context)}',
                          //                     style: TextStyle(
                          //                         fontWeight: FontWeight.w600,
                          //                         fontSize: responsiveFont(11),
                          //                         color: secondaryColor)),
                          //           ],
                          //         ),
                          //       ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
