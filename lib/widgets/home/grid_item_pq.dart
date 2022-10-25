import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/utils/utility.dart';

import '../../pages/product/product_detail_screen.dart';

class GridItemPQ extends StatelessWidget {
  final int? i;
  final int? itemCount;
  final Product? product;

  GridItemPQ({this.i, this.itemCount, this.product});

  @override
  Widget build(BuildContext context) {
    print(product);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 1),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                            productId: product!.summary.toString(),
                          )));
            },
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: product!.bannerImg.toString(),
                            placeholder: (context, url) => customLoading(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported_rounded,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        child: Text(
                          product!.summary!.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: responsiveFont(10)),
                        ),
                      ),
                      Container(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product!.prices!.first.price.toString() +
                                    " Vnd"),
                                Text(
                                  product!.summary!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(fontSize: responsiveFont(10)),
                                )
                              ],
                            ),
                          ),
                          buildButtonCart(context, product)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
              ],
            ),
          )),
    );
  }
}
