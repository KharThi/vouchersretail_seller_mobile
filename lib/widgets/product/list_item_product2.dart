import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/utils/utility.dart';

import '../../pages/product/product_detail_screen_voucher.dart';

class ListItemProduct2 extends StatelessWidget {
  final Voucher? product;
  final int? i, itemCount;
  final String price;

  ListItemProduct2({this.product, this.i, this.itemCount, required this.price});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // if (product!.type == "Voucher") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailVoucher(
                      productId: product!.id.toString(),
                    )));
        // } else {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => ProductDetailCombo(
        //                 productId: product!.id.toString(),
        //               )));
        // }
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
                  child: product!.bannerImg == null
                      ? Icon(
                          Icons.image_not_supported,
                          size: 50,
                        )
                      : CachedNetworkImage(
                          imageUrl: product!.bannerImg.toString(),
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
                            product!.voucherName.toString(),
                            overflow: TextOverflow.ellipsis,
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
                            product!.summary.toString(),
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
                          //   visible: product!.prices!.first.price != 0,
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
                          // product!.prices?.length.toString() == "1"
                          //     ?
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: product!.prices!.isNotEmpty
                                        ? product!.prices!.first.price! <
                                                product!.prices!.last.price!
                                            ? "Từ " +
                                                product!.prices!.first.price
                                                    .toString() +
                                                " Vnd"
                                            : "Từ " +
                                                product!.prices!.last.price
                                                    .toString() +
                                                " Vnd"
                                        : "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: responsiveFont(11),
                                        color: HexColor("960000"))),
                              ],
                            ),
                          )
                          // : RichText(
                          //     text: TextSpan(
                          //       style: TextStyle(color: Colors.black),
                          //       children: <TextSpan>[
                          //         product!.prices?.length.toString() != "0"
                          //             ? TextSpan(
                          //                 text: '',
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.w600,
                          //                     fontSize: responsiveFont(11),
                          //                     color: HexColor("960000")))
                          //             : TextSpan(
                          //                 text:
                          //                     // product!.prices!.first.price
                          //                     //             .toString() ==
                          //                     //         product!
                          //                     //             .prices!.first.price
                          //                     //             .toString()
                          //                     //     ?
                          //                     // '${stringToCurrency(100, context)}' +
                          //                     price + " Vnd"
                          //                 // : '${stringToCurrency(100, context)} - ${stringToCurrency(50, context)}'
                          //                 ,
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.w600,
                          //                     fontSize: responsiveFont(11),
                          //                     color: HexColor("960000"))),
                          //       ],
                          //     ),
                          //   ),
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
