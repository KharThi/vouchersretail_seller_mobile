import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nyoba/pages/product/product_detail_screen.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/pages/product/modal_sheet_cart/modal_sheet_cart.dart';
import 'package:nyoba/provider/wishlist_provider.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';

class ListItemWishlist extends StatelessWidget {
  final ProductModel? product;
  final int? i, itemCount;
  final Future<dynamic> Function()? loadCartCount;

  ListItemWishlist({this.i, this.itemCount, this.product, this.loadCartCount});

  @override
  Widget build(BuildContext context) {
    var setWishlist = () async {
      final wishlist = Provider.of<WishlistProvider>(context, listen: false);

      wishlist.listWishlistProduct.removeAt(i!);

      final Future<Map<String, dynamic>?> setWishlist = wishlist
          .setWishlistProduct(context, productId: product!.id.toString());

      setWishlist.then((value) {
        print("200");
      });
    };

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      productId: product!.id.toString(),
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 80.h,
                  height: 80.h,
                  child: Image.network(product!.images![0].src!),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product!.productName!,
                        style: TextStyle(fontSize: responsiveFont(12)),
                      ),
                      Visibility(
                        visible: product!.discProduct != 0,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: HexColor("960000"),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 7),
                              child: Text(
                                "${product!.discProduct!.round()}%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsiveFont(9)),
                              ),
                            ),
                            Container(
                              width: 5,
                            ),
                            Text(
                              stringToCurrency(
                                  double.parse(product!.productRegPrice),
                                  context),
                              style: TextStyle(
                                  fontSize: responsiveFont(8),
                                  color: HexColor("C4C4C4"),
                                  decoration: TextDecoration.lineThrough),
                            )
                          ],
                        ),
                      ),
                      Text(
                        stringToCurrency(
                            double.parse(product!.productPrice), context),
                        style: TextStyle(
                            fontSize: responsiveFont(10),
                            fontWeight: FontWeight.w600,
                            color: HexColor("960000")),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: setWishlist,
                            child: Container(
                              width: 25.h,
                              height: 25.h,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: HexColor("960000"),
                                ),
                              ),
                              child: Image.asset("images/account/trash.png"),
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: HexColor("960000"),
                              ),
                            ),
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) => ModalSheetCart(
                                  product: product,
                                  type: 'add',
                                  loadCount: loadCartCount,
                                ),
                              );
                            },
                            child: Text(
                              "+ ${AppLocalizations.of(context)!.translate('add_to_cart')}",
                              style: TextStyle(
                                  color: HexColor("960000"),
                                  fontSize: responsiveFont(9)),
                            ),
                          )
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
