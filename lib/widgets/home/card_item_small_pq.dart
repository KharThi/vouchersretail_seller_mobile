import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/pages/product/product_detail_screen_combo.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';

class CardItemPq extends StatelessWidget {
  final Combo? comboPq;

  final int? i, itemCount;

  CardItemPq({this.comboPq, this.i, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailCombo(
                      productId: comboPq!.id.toString(),
                    )));
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
                      child: comboPq!.bannerImg!.isEmpty
                          ? Icon(
                              Icons.image_not_supported,
                              size: 50,
                            )
                          : CachedNetworkImage(
                              imageUrl: comboPq!.bannerImg!,
                              placeholder: (context, url) => customLoading(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image_not_supported_rounded,
                                size: 25,
                              ),
                            ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Text(
                      comboPq!.content!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: responsiveFont(10)),
                      textScaleFactor: 1.0,
                    ),
                  ),
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
                          //           color: secondaryColor,
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
                          //                     color: secondaryColor)),
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
                          //                         color: secondaryColor))
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
                          //                         color: secondaryColor)),
                          //           ],
                          //         ),
                          //       ),
                          Visibility(
                            // visible: product!.discProduct != 0 &&
                            //     product!.discProduct != 0.0,
                            child: Row(
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(2),
                                //     color: secondaryColor,
                                //   ),
                                //   padding: EdgeInsets.symmetric(horizontal: 5),
                                //   child: Text(
                                //     "${product!.discProduct!.round()}%",
                                //     style: TextStyle(
                                //         color: Colors.white,
                                //         fontSize: responsiveFont(9)),
                                //   ),
                                // ),
                                // Container(
                                //   width: 5,
                                // ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "100.000đ",
                                          // text: stringToCurrency(
                                          //     double.parse(
                                          //         product!.productRegPrice),
                                          //     context),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: responsiveFont(9),
                                              color: HexColor("C4C4C4"))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "100.000vnđ",
                                    // text: stringToCurrency(
                                    //     double.parse(
                                    //         product!.productPrice),
                                    //     context),

                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: responsiveFont(11),
                                        color: secondaryColor)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // buildButtonCart(context, product)
                    // buildButtonCartPq(context, product)
                    buildButtonCartPq(context)
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
