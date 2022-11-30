import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/pages/product/modal_sheet_cart/modal_sheet_cart_voucher.dart';
import 'package:nyoba/pages/product/product_detail_screen.dart';
import 'package:nyoba/provider/combo_provider.dart';
import 'package:nyoba/provider/product_provider.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/product/grid_item_shimmer.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../provider/voucher_provider.dart';

class BrandProductsVoucher extends StatefulWidget {
  final String? categoryId;
  final String? brandName;
  final int? sortIndex;
  BrandProductsVoucher(
      {Key? key, this.categoryId, this.brandName, this.sortIndex})
      : super(key: key);

  @override
  _BrandProductsVoucherState createState() => _BrandProductsVoucherState();
}

class _BrandProductsVoucherState extends State<BrandProductsVoucher>
    with SingleTickerProviderStateMixin {
  int? currentIndex = 0;
  TabController? _tabController;

  List<Voucher> listVoucher = List.empty(growable: true);

  int page = 1;
  String order = 'desc';
  String orderBy = 'popularity';
  int cartCount = 0;
  int? price;
  bool isLoading = true;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // final product = Provider.of<ProductProvider>(context, listen: false);
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (listVoucher.length % 8 == 0) {
          setState(() {
            page++;
          });
          loadProductByBrand();
        }
      }
    });
    if (widget.sortIndex != null) {
      currentIndex = widget.sortIndex;
      _tabController!.animateTo(currentIndex!);
      _onSortChange(currentIndex);
      loadProductByBrand();
    } else {
      loadProductByBrand();
    }
  }

  loadProductByBrand() async {
    await Provider.of<VoucherProvider>(context, listen: false)
        .fetchVouchers("", "")
        .then((value) {
      this.setState(() {
        listVoucher = value!;
        isLoading = false;
      });
      Future.delayed(Duration(milliseconds: 3500), () {
        print('Delayed Done');
        this.setState(() {});
      });
    });
  }

  // Future loadCartCount() async {
  //   await Provider.of<OrderProvider>(context, listen: false)
  //       .loadCartCount()
  //       .then((value) => setState(() {
  //             cartCount = value;
  //           }));
  // }

  _onSortChange(i) {
    if (i == 0) {
      setState(() {
        order = 'desc';
        orderBy = 'popularity';
      });
    } else if (i == 1) {
      setState(() {
        order = 'desc';
        orderBy = 'date';
      });
    } else if (i == 2) {
      setState(() {
        order = 'desc';
        orderBy = 'price';
      });
    } else if (i == 3) {
      setState(() {
        order = 'asc';
        orderBy = 'price';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);
    Widget buildItems = ListenableProvider.value(
      value: product,
      child: Consumer<ComboProvider>(builder: (context, value, child) {
        if (value.loading && page == 1) {
          return Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 2,
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                itemBuilder: (context, i) {
                  return GridItemShimmer();
                }),
          );
        }
        if (isLoading) {
          return Center(
            // padding: const EdgeInsets.all(20.0),
            child: customLoading(),
          );
        } else {
          if (listVoucher.isEmpty) {
            return buildSearchEmpty(context, "Không tìm thấy sản phẩm nào");
          }
          return Expanded(
            child: GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: listVoucher.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 2,
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                itemBuilder: (context, i) {
                  return itemGridList(listVoucher[i].voucherName!, i,
                      listVoucher[i].bannerImg, listVoucher[i]);
                }),
          );
        }
      }),
    );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: Container(
            height: 38,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  convertHtmlUnescape(widget.brandName!),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: responsiveFont(16),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          actions: [
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => CartScreen(
            //                   isFromHome: false,
            //                 )));
            //   },
            //   child: Container(
            //     width: 65,
            //     padding: EdgeInsets.symmetric(horizontal: 8),
            //     child: Stack(
            //       alignment: Alignment.center,
            //       children: [
            //         Icon(
            //           Icons.shopping_cart,
            //           color: Colors.black,
            //         ),
            //         Positioned(
            //           right: 0,
            //           top: 7,
            //           child: Container(
            //             padding:
            //                 EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //             decoration: BoxDecoration(
            //                 shape: BoxShape.circle, color: primaryColor),
            //             alignment: Alignment.center,
            //             child: Text(
            //               cartCount.toString(),
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: responsiveFont(9),
            //               ),
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
        body: isLoading
            ? customLoading()
            : Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    // Text(AppLocalizations.of(context)!.translate('sort')!,
                    //     style: TextStyle(
                    //         fontSize: responsiveFont(12),
                    //         fontWeight: FontWeight.w500)),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 15),
                    //   child: TabBar(
                    //     controller: _tabController,
                    //     labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    //     onTap: (i) {
                    //       setState(() {
                    //         currentIndex = i;
                    //         page = 1;
                    //       });
                    //       _onSortChange(i);
                    //       loadProductByBrand();
                    //     },
                    //     isScrollable: true,
                    //     indicatorSize: TabBarIndicatorSize.label,
                    //     indicator: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(5),
                    //       color: primaryColor,
                    //     ),
                    //     tabs: [
                    //       tabStyle(0,
                    //           AppLocalizations.of(context)!.translate('popularity')!),
                    //       tabStyle(
                    //           1, AppLocalizations.of(context)!.translate('latest')!),
                    //       tabStyle(
                    //           2,
                    //           AppLocalizations.of(context)!
                    //               .translate('highest_price')!),
                    //       tabStyle(
                    //           3,
                    //           AppLocalizations.of(context)!
                    //               .translate('lowest_price')!),
                    //     ],
                    //   ),
                    // ),
                    buildItems,
                    if (product.loadingBrand && page != 1) customLoading()
                  ],
                ),
              ),
      ),
    );
  }

  Widget tabStyle(int index, String total) {
    return Container(
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: currentIndex == index
                  ? Colors.transparent
                  : HexColor("c4c4c4"))),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(total,
              style: TextStyle(
                  fontSize: responsiveFont(10),
                  color: currentIndex == index
                      ? Colors.white
                      : HexColor("c4c4c4")))
        ],
      ),
    );
  }

  Widget itemGridList(
      String title,
      // String discount,
      // String? crossedPrice,
      int i,
      // int? stock,
      String? image,
      Voucher productDetail) {
    bool isOutOfStock = productDetail.inventory == 0;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetail(
                        productId: productDetail.id.toString(),
                      )));
        },
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: image == null
                      ? Icon(
                          Icons.image_not_supported,
                          size: 50,
                        )
                      : CachedNetworkImage(
                          imageUrl: image,
                          placeholder: (context, url) => customLoading(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.image_not_supported_rounded,
                            size: 25,
                          ),
                        ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: responsiveFont(10)),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        // Visibility(
                        //   visible: discount != "0",
                        //   child: Flexible(
                        //     flex: 1,
                        //     child: Row(
                        //       children: [
                        //         Container(
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(2),
                        //             color: HexColor("960000"),
                        //           ),
                        //           padding: EdgeInsets.symmetric(
                        //               vertical: 3, horizontal: 7),
                        //           child: Text(
                        //             '$discount%',
                        //             style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: responsiveFont(9)),
                        //           ),
                        //         ),
                        //         Container(
                        //           width: 5,
                        //         ),
                        //         RichText(
                        //           text: TextSpan(
                        //             style: TextStyle(color: Colors.black),
                        //             children: <TextSpan>[
                        //               TextSpan(
                        //                   text: stringToCurrency(
                        //                       double.parse(productDetail
                        //                           .productRegPrice),
                        //                       context),
                        //                   style: TextStyle(
                        //                       decoration:
                        //                           TextDecoration.lineThrough,
                        //                       fontSize: responsiveFont(9),
                        //                       color: HexColor("C4C4C4"))),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: productDetail.prices!.isNotEmpty
                                      ? productDetail.prices!.first.price! <
                                              productDetail.prices!.last.price!
                                          ? "Từ " +
                                              productDetail.prices!.first.price
                                                  .toString() +
                                              " Vnd"
                                          : "Từ " +
                                              productDetail.prices!.last.price
                                                  .toString() +
                                              " Vnd"
                                      : "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: responsiveFont(11),
                                      color: HexColor("960000"))),
                            ],
                          ),
                        ),

                        Container(
                          height: 5,
                        ),
                        // buildStock(productDetail, stock)
                      ],
                    ),
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isOutOfStock
                              ? Colors.grey
                              : HexColor("960000"), //Color of the border
                          //Style of the border
                        ),
                        alignment: Alignment.center,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5))),
                    onPressed: () {
                      if (!isOutOfStock && productDetail.inventory! >= 1) {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => ModalSheetCartVoucher(
                            product: productDetail,
                            type: 'add',
                            // loadCount: loadCartCount,
                          ),
                        );
                      } else {
                        snackBar(context, message: "Sản phẩm đã hết hàng");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: responsiveFont(9),
                          color:
                              isOutOfStock ? Colors.grey : HexColor("960000"),
                        ),
                        Text(
                          "Thêm vào giỏ hàng",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveFont(9),
                              color: isOutOfStock
                                  ? Colors.grey
                                  : HexColor("960000")),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildStock(ProductModel productDetail, stock) {
    if (productDetail.stockStatus == 'outofstock') {
      return Text(
        "${AppLocalizations.of(context)!.translate('out_stock')}",
        style: TextStyle(fontSize: responsiveFont(8)),
      );
    }
    return Text(
      !productDetail.manageStock!
          ? "${AppLocalizations.of(context)!.translate('available')}"
          : "${AppLocalizations.of(context)!.translate('available')} : $stock ${AppLocalizations.of(context)!.translate('in_stock')}",
      style: TextStyle(fontSize: responsiveFont(8)),
    );
  }
}
