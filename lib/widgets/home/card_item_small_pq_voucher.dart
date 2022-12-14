import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/utils/utility.dart';

import '../../pages/product/product_detail_screen_voucher.dart';

class CardItemPqVoucher extends StatelessWidget {
  final Voucher? voucher;

  final int? i, itemCount;

  CardItemPqVoucher({this.voucher, this.i, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // if (product!.type == "Voucher") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailVoucher(
                      isCombo: voucher!.isCombo.toString(),
                      productId: voucher!.id.toString(),
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
        margin: EdgeInsets.only(
            left: i == 0 ? 15 : 0, right: i == itemCount! - 1 ? 15 : 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: 130.w,
        height: double.infinity,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5)),
                      ),
                      child: voucher!.bannerImg == null
                          ? Icon(
                              Icons.image_not_supported,
                              size: 50,
                            )
                          : CachedNetworkImage(
                              imageUrl: voucher!.bannerImg!,
                              placeholder: (context, url) => customLoading(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image_not_supported_rounded,
                                size: 25,
                              ),
                            ),
                    ),
                  ),
                  ListTile(
                    title: Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      child: Text(
                        voucher!.voucherName!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: responsiveFont(10)),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    subtitle: Text(
                        voucher!.soldPrice != null
                            ? "T??? " + voucher!.soldPrice.toString() + " Vnd"
                            : "",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  )
                ],
              )),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Visibility(
                          //   visible: product!.discProduct != 0 &&
                          //       product!.discProduct != 0.0,
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(2),
                          //           color: HexColor("960000"),
                          //         ),
                          //         padding: EdgeInsets.symmetric(horizontal: 5),
                          //         child: Text(
                          //           "${product!.discProduct!.round()}%",
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: responsiveFont(9)),
                          //         ),
                          //       ),
                          //       Container(
                          //         width: 5,
                          //       ),
                          //       RichText(
                          //         text: TextSpan(
                          //           style: TextStyle(color: Colors.black),
                          //           children: <TextSpan>[
                          //             TextSpan(
                          //                 text: stringToCurrency(
                          //                     double.parse(
                          //                         product!.productRegPrice),
                          //                     context),
                          //                 style: TextStyle(
                          //                     decoration:
                          //                         TextDecoration.lineThrough,
                          //                     fontSize: responsiveFont(9),
                          //                     color: HexColor("C4C4C4"))),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // product!.type == 'simple'
                          //     ? RichText(
                          //         text: TextSpan(
                          //           style: TextStyle(color: Colors.black),
                          //           children: <TextSpan>[
                          //             TextSpan(
                          //                 text: stringToCurrency(
                          //                     double.parse(
                          //                         product!.productPrice),
                          //                     context),
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.w600,
                          //                     fontSize: responsiveFont(11),
                          //                     color: HexColor("960000"))),
                          //           ],
                          //         ),
                          //       )
                          //     : RichText(
                          //         text: TextSpan(
                          //           style: TextStyle(color: Colors.black),
                          //           children: <TextSpan>[
                          //             product!.variationPrices!.isEmpty
                          //                 ? TextSpan(
                          //                     text: '',
                          //                     style: TextStyle(
                          //                         fontWeight: FontWeight.w600,
                          //                         fontSize: responsiveFont(11),
                          //                         color: HexColor("960000")))
                          //                 : TextSpan(
                          //                     text: product!.variationPrices!
                          //                                 .first ==
                          //                             product!
                          //                                 .variationPrices!.last
                          //                         ? '${stringToCurrency(product!.variationPrices!.first!, context)}'
                          //                         : '${stringToCurrency(product!.variationPrices!.first!, context)} - ${stringToCurrency(product!.variationPrices!.last!, context)}',
                          //                     style: TextStyle(
                          //                         fontWeight: FontWeight.w600,
                          //                         fontSize: responsiveFont(11),
                          //                         color: HexColor("960000"))),
                          //           ],
                          //         ),
                          //       ),
                        ],
                      ),
                    ),
                    // buildButtonCart(context, product)
                  ],
                ),
              ),
              Container(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
