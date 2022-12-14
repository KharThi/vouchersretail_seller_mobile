// ignore_for_file: unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:nyoba/pages/category/brand_product_screen.dart';
import 'package:nyoba/pages/category/brand_product_screen_voucher.dart';
import 'package:nyoba/pages/product/modal_sheet_cart/modal_sheet_cart_voucher.dart';
import 'package:nyoba/pages/product/product_more_screen.dart';
import 'package:nyoba/pages/wishlist/wishlist_screen.dart';
import 'package:nyoba/provider/flash_sale_provider.dart';
import 'package:nyoba/provider/order_provider.dart';
import 'package:nyoba/provider/product_provider.dart';
import 'package:nyoba/provider/review_provider.dart';
import 'package:nyoba/provider/wishlist_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/widgets/contact/contact_fab.dart';
import 'package:nyoba/widgets/home/card_item_shimmer.dart';
import 'package:nyoba/widgets/home/card_item_small.dart';
import 'package:nyoba/widgets/home/card_item_small_pq_voucher.dart';
import 'package:nyoba/widgets/product/product_photoview.dart';
import 'package:nyoba/widgets/product/product_detail_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_localizations.dart';
import '../../models/product_model.dart';
import '../../provider/voucher_provider.dart';
import '../../utils/utility.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_review_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailVoucher extends StatefulWidget {
  final String? productId;
  final String? slug;
  final String? payUrl;
  final String? isCombo;
  ProductDetailVoucher(
      {Key? key, this.productId, this.slug, this.payUrl, this.isCombo})
      : super(key: key);

  @override
  _ProductDetailStateVoucher createState() => _ProductDetailStateVoucher();
}

class _ProductDetailStateVoucher extends State<ProductDetailVoucher>
    with TickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;

  int itemCount = 10;

  bool? isWishlist = false;
  bool isLoading = true;

  int cartCount = 0;
  TextEditingController reviewController = new TextEditingController();

  double rating = 0;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isFlashSale = false;

  Voucher? productModel;
  Combo? productModel2;
  List<Voucher> moreVoucher = List.empty(growable: true);
  List<Price> listPrice = List.empty(growable: true);
  final CarouselController _controller = CarouselController();
  int _current = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<double> variantPrices = [];

  final DateFormat serverFormater = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    loadDetail();
    loadVoucher();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);
      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 350) / 50);
      return true;
    } else {
      return false;
    }
  }

  Future<void> share() async {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    SharedPreferences data = await SharedPreferences.getInstance();
    String sellerId = data.getInt("id").toString();
    String link = "";
    if (widget.isCombo == "false") {
      link = "https://phuquoc-voucher.vercel.app/voucher-detail/" +
          productModel!.id.toString() +
          "?sellerId=" +
          sellerId;
    } else {
      link = "https://phuquoc-voucher.vercel.app/combo-detail/" +
          productModel!.id.toString() +
          "?sellerId=" +
          sellerId;
    }
    // htmlText.replaceAll(exp, '');
    await FlutterShare.share(
        title: productModel!.voucherName!,
        text: productModel!.content!.replaceAll(exp, ''),
        linkUrl: link,
        chooserTitle: '');
  }

  loadVoucher() async {
    await Provider.of<VoucherProvider>(context, listen: false)
        .fetchVouchers("", "3", "")
        .then((value) {
      this.setState(() {
        moreVoucher = value!;
        for (var element in moreVoucher) {
          print(element.voucherName);
        }
        // isLoading = false;
      });
      Future.delayed(Duration(milliseconds: 3500), () {
        print('Delayed Done');
        this.setState(() {});
      });
    });
  }

  Future loadDetail() async {
    isLoading = true;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    // loadCartCount();
    loadVoucher();
    print("isCombo " + widget.isCombo.toString());
    if (widget.isCombo == "true") {
      loadDetail2();
    }
    if (widget.slug == null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProductDetailVoucher(widget.productId)
          .then((value) async {
        setState(() {
          productModel = value;
          printLog(productModel.toString(), name: 'Product Model');
          isLoading = false;
          // productModel!.isSelected = false;
        });
        // loadVariationData().then((value) {
        //   printLog('Load Stop', name: 'Load Stop');
        //   productProvider.loadingDetail = false;
        // });
        // if (Session.data.getBool('isLogin')!)
        //   await productProvider.hitViewProducts(widget.productId).then(
        //       (value) async => await productProvider.fetchRecentProducts());
      });
    }
    Future.delayed(Duration(milliseconds: 3500), () {
      print('Delayed Done');
      this.setState(() {});
    });
    // else {
    //   await Provider.of<ProductProvider>(context, listen: false)
    //       .fetchProductDetailSlug(widget.slug)
    //       .then((value) {
    //     setState(() {
    //       productModel = value;
    //       productModel!.isSelected = false;
    //       productProvider.loadingDetail = false;
    //       printLog(productModel.toString(), name: 'Product Model');
    //     });
    //     loadVariationData().then((value) {
    //       printLog('Load Stop', name: 'Load Stop');
    //       productProvider.loadingDetail = false;
    //     });
    //   });
    // }
    // if (mounted) secondLoad();
  }

  Future loadDetail2() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    // loadCartCount();
    if (widget.slug == null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProductDetailCombo(widget.productId)
          .then((value) async {
        setState(() {
          productModel2 = value;
          printLog(productModel.toString(), name: 'Product Model');
          // productModel!.isSelected = false;
        });
        // loadVariationData().then((value) {
        //   printLog('Load Stop', name: 'Load Stop');
        //   productProvider.loadingDetail = false;
        // });
        // if (Session.data.getBool('isLogin')!)
        //   await productProvider.hitViewProducts(widget.productId).then(
        //       (value) async => await productProvider.fetchRecentProducts());
      });
    }
    Future.delayed(Duration(milliseconds: 3500), () {
      print('Delayed Done');
      this.setState(() {});
    });
    // else {
    //   await Provider.of<ProductProvider>(context, listen: false)
    //       .fetchProductDetailSlug(widget.slug)
    //       .then((value) {
    //     setState(() {
    //       productModel = value;
    //       productModel!.isSelected = false;
    //       productProvider.loadingDetail = false;
    //       printLog(productModel.toString(), name: 'Product Model');
    //     });
    //     loadVariationData().then((value) {
    //       printLog('Load Stop', name: 'Load Stop');
    //       productProvider.loadingDetail = false;
    //     });
    //   });
    // }
    // if (mounted) secondLoad();
  }

  secondLoad() {
    final wishlist = Provider.of<WishlistProvider>(context, listen: false);

    checkFlashSale();

    if (Session.data.getBool('isLogin')!) {
      final Future<Map<String, dynamic>?> checkWishlist =
          wishlist.checkWishlistProduct(productId: productModel!.id.toString());

      checkWishlist.then((value) {
        printLog('Cek Wishlist Success');
        setState(() {
          // isWishlist = value!['message'];
        });
      });
    }
    // loadReviewProduct();
  }

  Future<bool?> setWishlist(bool? isLiked) async {
    if (Session.data.getBool('isLogin')!) {
      setState(() {
        isWishlist = !isWishlist!;
        isLiked = isWishlist;
      });
      final wishlist = Provider.of<WishlistProvider>(context, listen: false);

      final Future<Map<String, dynamic>?> setWishlist = wishlist
          .setWishlistProduct(context, productId: productModel!.id.toString());

      setWishlist.then((value) {
        print("200");
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WishList()));
    }
    return isLiked;
  }

  Future<dynamic> loadCartCount() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .loadCartCount()
        .then((value) {
      setState(() {
        cartCount = value;
      });
    });
  }

  // Future<bool> loadVariationData() async {
  //   await ProductAPI()
  //       .productVariations(
  //           productId: widget.slug == null
  //               ? widget.productId
  //               : productModel!.id.toString())
  //       .then((value) {
  //     if (value.statusCode == 200) {
  //       final variation = json.decode(value.body);
  //       List<VariationModel> variations = [];

  //       for (Map item in variation) {
  //         if (item['price'].isNotEmpty) {
  //           variations.add(VariationModel.fromJson(item));
  //         }
  //       }

  //       variations.forEach((v) {
  //         variantPrices.add(double.parse(v.price!));
  //         if (widget.slug != null) {
  //           productModel!.variationPrices!.add(double.parse(v.price!));
  //         }
  //       });

  //       variantPrices.sort((a, b) => a.compareTo(b));
  //       if (widget.slug != null) {
  //         productModel!.variationPrices!.sort((a, b) => a!.compareTo(b!));
  //       }
  //     }
  //   });
  //   return true;
  // }

  // loadReviewProduct() async {
  //   await Provider.of<ReviewProvider>(context, listen: false)
  //       .fetchReviewProductLimit(productModel!.id.toString())
  //       .then((value) => loadLikeProduct());
  // }

  // loadLikeProduct() async {
  //   if (mounted) {
  //     await Provider.of<ProductProvider>(context, listen: false)
  //         .fetchCategoryProduct(productModel!.categories![0].id.toString());
  //   }
  // }

  checkFlashSale() {
    final flashsale = Provider.of<FlashSaleProvider>(context, listen: false);
    if (flashsale.flashSales.isNotEmpty) {
      setState(() {
        endTime = DateTime.parse(flashsale.flashSales[0].endDate!)
            .millisecondsSinceEpoch;
      });
    }

    if (flashsale.flashSaleProducts.isNotEmpty) {
      flashsale.flashSaleProducts.forEach((element) {
        if (productModel!.id.toString() == element.id.toString()) {
          setState(() {
            isFlashSale = true;
          });
        }
      });
    }
  }

  refresh() async {
    this.setState(() {});
    await loadDetail().then((value) {
      this.setState(() {});
      _refreshController.refreshCompleted();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);

    // Widget buildWishlistBtn = LikeButton(
    //   size: 25,
    //   onTap: setWishlist,
    //   circleColor: CircleColor(start: primaryColor, end: HexColor("960000")),
    //   bubblesColor: BubblesColor(
    //     dotPrimaryColor: primaryColor,
    //     dotSecondaryColor: HexColor("960000"),
    //   ),
    //   isLiked: isWishlist,
    //   likeBuilder: (bool isLiked) {
    //     if (!isLiked) {
    //       return Icon(
    //         Icons.favorite_border,
    //         color: Colors.grey,
    //         size: 25,
    //       );
    //     }
    //     return Icon(
    //       Icons.favorite,
    //       color: Colors.red,
    //       size: 25,
    //     );
    //   },
    // );

    return ListenableProvider.value(
      value: product,
      child: Consumer<ProductProvider>(builder: (context, value, child) {
        if (isLoading) {
          return ProductDetailShimmer();
        }
        List<Widget> itemSlider = [
          Icon(
            Icons.broken_image_outlined,
            size: 80,
          )
        ];
        if (productModel!.bannerImg != null
            //|| productModel!.videos!.isNotEmpty
            ) {
          itemSlider = [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductPhotoView(
                              image: productModel!.bannerImg.toString(),
                            )));
              },
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: CachedNetworkImage(
                  imageUrl: productModel!.bannerImg.toString(),
                  placeholder: (context, url) => customLoading(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported_rounded,
                    size: 25,
                  ),
                ),
              ),
            ),
            // for (var i = 0; i < productModel!.videos!.length; i++)
            //   Container(
            //     child: YoutubePlayerWidget(
            //       url: productModel!.videos![i].content,
            //     ),
            //   ),
            for (var i = 1; i < 1; i++)
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductPhotoView(
                                  image: productModel!.bannerImg,
                                )));
                  },
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: CachedNetworkImage(
                      imageUrl: productModel!.bannerImg.toString(),
                      placeholder: (context, url) => customLoading(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported_rounded,
                        size: 25,
                      ),
                    ),
                  ))
          ];
        }
        return ColorfulSafeArea(
          color: Colors.white,
          child: Scaffold(
            // floatingActionButton: ContactFAB(),
            appBar: appBar(productModel!) as PreferredSizeWidget?,
            body: Stack(
              children: [
                SmartRefresher(
                  controller: _refreshController,
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1,
                                  aspectRatio: 1 / 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                              carouselController: _controller,
                              items: itemSlider,
                            ),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    itemSlider.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _controller.animateToPage(entry.key),
                                    child: Container(
                                        width: 10.0,
                                        height: 10.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _current == entry.key
                                              ? primaryColor
                                              : primaryColor.withOpacity(0.5),
                                        )),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: isFlashSale,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "images/product_detail/bg_flashsale.png"))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "FLASH SALE ENDS IN :",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                      // Text(
                                      //     "${productModel!.totalSales} Item Sold",
                                      //     style: TextStyle(
                                      //         color: Colors.white,
                                      //         fontSize: 10)),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    alignment: Alignment.center,
                                    child: CountdownTimer(
                                      endTime: endTime,
                                      widgetBuilder:
                                          (_, CurrentRemainingTime? time) {
                                        int? hours = time!.hours;
                                        if (time.days != null &&
                                            time.days != 0) {
                                          hours =
                                              (time.days! * 24) + time.hours!;
                                        } else {
                                          return Text('Flash Sale END');
                                        }
                                        return Container(
                                          height: 30.h,
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4, vertical: 3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                width: 35.w,
                                                height: 30.h,
                                                child: Text(
                                                  hours < 10
                                                      ? "0$hours"
                                                      : "$hours",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                width: 30.w,
                                                height: 30.h,
                                                child: Text(
                                                  time.min! < 10
                                                      ? "0${time.min}"
                                                      : "${time.min}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                width: 30.w,
                                                height: 30.h,
                                                child: Text(
                                                  time.sec! < 10
                                                      ? "0${time.sec}"
                                                      : "${time.sec}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ))
                              ],
                            ),
                          ),
                        ),
                        firstPart(productModel!),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          height: 5,
                          color: HexColor("EEEEEE"),
                        ),
                        secondPart(productModel!),
                        // Container(
                        //   margin: EdgeInsets.symmetric(vertical: 15),
                        //   width: double.infinity,
                        //   height: 5,
                        //   color: HexColor("EEEEEE"),
                        // ),
                        // thirdPart(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          height: 5,
                          color: HexColor("EEEEEE"),
                        ),
                        // commentPart(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          height: 5,
                          color: HexColor("EEEEEE"),
                        ),
                        sameCategoryProduct(),
                        SizedBox(
                          height: 15,
                        ),
                        featuredProduct(),
                        SizedBox(
                          height: 15,
                        ),
                        onSaleProduct(),
                        SizedBox(
                          height: 70.h,
                        ),
                      ],
                    ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150.w,
                          height: 30.h,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: widget.isCombo == "false"
                                        ? productModel!.inventory != 0 &&
                                                productModel!.inventory! >= 1
                                            ? HexColor("960000")
                                            : Colors.grey
                                        : HexColor(
                                            "960000"), //Color of the border
                                    //Style of the border
                                  ),
                                  alignment: Alignment.center,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5))),
                              onPressed: () {
                                if (Session.data.getBool('isLogin')!) {
                                  share();
                                } else {
                                  snackBar(context,
                                      message:
                                          "B???n c???n ????ng nh???p ????? th???c hi???n ch???c n??ng n??y!");
                                }

                                // if (productModel!.inventory != 0 &&
                                //     productModel!.inventory! >= 1) {
                                //   showMaterialModalBottomSheet(
                                //     context: context,
                                //     builder: (context) => ModalSheetCartVoucher(
                                //       product: productModel,
                                //       type: 'add',
                                //       loadCount: loadCartCount,
                                //     ),
                                //   ).whenComplete(() async {
                                //     // SharedPreferences prefrences =
                                //     //     await SharedPreferences.getInstance();
                                //     // await prefrences
                                //     //     .remove("list_customer_order");
                                //   });
                                // } else {
                                //   snackBar(context,
                                //       message: "S???n ph???m ???? h???t h??ng!");
                                // }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share,
                                    size: responsiveFont(9),
                                    color: widget.isCombo == "false"
                                        ? productModel!.inventory != 0 &&
                                                productModel!.inventory! >= 1
                                            ? HexColor("960000")
                                            : Colors.grey
                                        : HexColor("960000"),
                                  ),
                                  Text(
                                    "????ng b??n",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: responsiveFont(9),
                                      color: widget.isCombo == "false"
                                          ? productModel!.inventory != 0 &&
                                                  productModel!.inventory! >= 1
                                              ? HexColor("960000")
                                              : Colors.grey
                                          : HexColor("960000"),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        Container(
                          width: 150.w,
                          height: 30.h,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: widget.isCombo == "false"
                                        ? productModel!.inventory != 0 &&
                                                productModel!.inventory! >= 1
                                            ? HexColor("960000")
                                            : Colors.grey
                                        : HexColor(
                                            "960000"), //Color of the border
                                    //Style of the border
                                  ),
                                  alignment: Alignment.center,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5))),
                              onPressed: () {
                                if (Session.data.getBool('isLogin')!) {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) => ModalSheetCartVoucher(
                                      product: productModel,
                                      type: 'add',
                                      loadCount: loadCartCount,
                                    ),
                                  ).whenComplete(() async {
                                    SharedPreferences prefrences =
                                        await SharedPreferences.getInstance();
                                    await prefrences
                                        .remove("list_customer_order");
                                  });
                                } else {
                                  snackBar(context,
                                      message:
                                          "B???n c???n ????ng nh???p ????? th???c hi???n ch???c n??ng n??y!");
                                }

                                // if (productModel!.inventory != 0 &&
                                //     productModel!.inventory! >= 1) {
                                //   showMaterialModalBottomSheet(
                                //     context: context,
                                //     builder: (context) => ModalSheetCartVoucher(
                                //       product: productModel,
                                //       type: 'add',
                                //       loadCount: loadCartCount,
                                //     ),
                                //   ).whenComplete(() async {
                                //     // SharedPreferences prefrences =
                                //     //     await SharedPreferences.getInstance();
                                //     // await prefrences
                                //     //     .remove("list_customer_order");
                                //   });
                                // } else {
                                //   snackBar(context,
                                //       message: "S???n ph???m ???? h???t h??ng!");
                                // }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: responsiveFont(9),
                                    color: widget.isCombo == "false"
                                        ? productModel!.inventory != 0 &&
                                                productModel!.inventory! >= 1
                                            ? HexColor("960000")
                                            : Colors.grey
                                        : HexColor("960000"),
                                  ),
                                  Text(
                                    "Th??m v??o gi??? h??ng",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: responsiveFont(9),
                                      color: widget.isCombo == "false"
                                          ? productModel!.inventory != 0 &&
                                                  productModel!.inventory! >= 1
                                              ? HexColor("960000")
                                              : Colors.grey
                                          : HexColor("960000"),
                                    ),
                                  )
                                ],
                              )),
                        ),

                        // Container(
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(5),
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           end: Alignment.bottomCenter,
                        //           colors: productModel!.inventory != 0 &&
                        //                   productModel!.inventory! >= 1
                        //               ? [primaryColor, HexColor("960000")]
                        //               : [Colors.grey, Colors.grey])),
                        //   width: 132.w,
                        //   height: 30.h,
                        //   child: TextButton(
                        //     onPressed: () {
                        //       final order = Provider.of<OrderProvider>(context,
                        //           listen: false);
                        //       //for testing
                        //       if (productModel!.inventory != -1) {
                        //         showMaterialModalBottomSheet(
                        //           context: context,
                        //           builder: (context) => ModalSheetCartVoucher(
                        //             order: order,
                        //             product: productModel,
                        //             type: 'buy',
                        //           ),
                        //         ).whenComplete(() async {
                        //           SharedPreferences prefrences =
                        //               await SharedPreferences.getInstance();
                        //           await prefrences
                        //               .remove("list_customer_order");
                        //           if (order.payUrl != "" &&
                        //               order.payUrl != null) {
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (context) => MoMoWebView(
                        //                           url: order.payUrl,
                        //                           orderId: "",
                        //                         ))).then(
                        //                 (value) => this.setState(() {}));
                        //           }
                        //         });
                        //       } else {
                        //         snackBar(context,
                        //             message: "S???n ph???m ???? h???t h??ng");
                        //       }
                        //     },
                        //     child: Text(
                        //       "?????t ngay",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: responsiveFont(9)),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget sameCategoryProduct() {
    final product = Provider.of<ProductProvider>(context, listen: false);

    return ListenableProvider.value(
        value: product,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.loadingCategory) {
            return AspectRatio(
              aspectRatio: 3 / 1.9,
              child: ListView.separated(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return CardItemShimmer(
                    i: i,
                    itemCount: 4,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 5,
                  );
                },
              ),
            );
          }
          return Visibility(
              visible: value.listCategoryProduct.isNotEmpty,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .translate('you_might_also')!,
                          style: TextStyle(
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => BrandProducts(
                        //                   categoryId: product
                        //                       .productDetail!.categories![0].id
                        //                       .toString(),
                        //                   brandName:
                        //                       AppLocalizations.of(context)!
                        //                           .translate('you_might_also'),
                        //                 )));
                        //   },
                        //   child: Text(
                        //     AppLocalizations.of(context)!.translate('more')!,
                        //     style: TextStyle(
                        //         fontSize: responsiveFont(12),
                        //         fontWeight: FontWeight.w600,
                        //         color: HexColor("960000")),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: ListView.separated(
                      itemCount: value.listCategoryProduct.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return CardItem(
                          product: value.listCategoryProduct[i],
                          i: i,
                          itemCount: value.listCategoryProduct.length,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                    ),
                  )
                ],
              ));
        }));
  }

  Widget featuredProduct() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      if (isLoading) {
        return customLoading();
      }
      return Visibility(
          visible: moreVoucher.isNotEmpty,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "C??c s???n ph???m kh??c",
                      style: TextStyle(
                          fontSize: responsiveFont(14),
                          fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BrandProductsVoucher(
                                      categoryId: "",
                                      brandName: "Voucher",
                                      sortIndex: 1,
                                    ))).then((value) => setState(() {
                              isLoading = true;
                              loadDetail();
                              loadVoucher();
                            }));
                      },
                      child: Text(
                        "Xem th??m",
                        style: TextStyle(
                            fontSize: responsiveFont(12),
                            fontWeight: FontWeight.w600,
                            color: HexColor("960000")),
                      ),
                    )
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 3 / 2,
                child: ListView.separated(
                  itemCount: moreVoucher.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return CardItemPqVoucher(
                      voucher: moreVoucher[i],
                      i: i,
                      itemCount: moreVoucher.length,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 5,
                    );
                  },
                ),
              )
            ],
          ));
    });
  }

  Widget onSaleProduct() {
    return Consumer<FlashSaleProvider>(builder: (context, value, child) {
      return Visibility(
          visible: value.flashSaleProducts.isNotEmpty,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('flashsale')!,
                      style: TextStyle(
                          fontSize: responsiveFont(14),
                          fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductMoreScreen(
                                      include: value.flashSales[0].products,
                                      name: AppLocalizations.of(context)!
                                          .translate('flashsale')!,
                                    )));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate('more')!,
                        style: TextStyle(
                            fontSize: responsiveFont(12),
                            fontWeight: FontWeight.w600,
                            color: HexColor("960000")),
                      ),
                    )
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 3 / 1.9,
                child: ListView.separated(
                  itemCount: value.flashSaleProducts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return CardItem(
                      product: value.flashSaleProducts[i],
                      i: i,
                      itemCount: value.flashSaleProducts.length,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 5,
                    );
                  },
                ),
              )
            ],
          ));
    });
  }

  Widget thirdPart() {
    final review = Provider.of<ReviewProvider>(context, listen: false);
    // final product = Provider.of<ProductProvider>(context, listen: false);

    Widget buildReview = Container(
      child: ListenableProvider.value(
        value: review,
        child: Consumer<ReviewProvider>(builder: (context, value, child) {
          if (value.isLoadingReview) {
            return Container();
          }
          if (value.listReviewLimit.isEmpty) {
            return Text(
              AppLocalizations.of(context)!.translate('empty_review_product')!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RatingBarIndicator(
                    rating: double.parse(value.listReviewLimit[0].star!),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 15,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "by ",
                    style: TextStyle(
                        color: HexColor("929292"), fontSize: responsiveFont(9)),
                  ),
                  Text(
                    value.listReviewLimit[0].author!,
                    style: TextStyle(fontSize: responsiveFont(9)),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                value.listReviewLimit[0].content!,
                style: TextStyle(
                    color: HexColor("464646"),
                    fontWeight: FontWeight.w400,
                    fontSize: 10),
              ),
            ],
          );
        }),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('review')!,
                    style: TextStyle(
                        fontSize: responsiveFont(10),
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Container(
                          width: 15.w,
                          height: 15.h,
                          child: Image.asset(
                              "images/product_detail/starGold.png")),
                      // Text(
                      //   " ${product.productDetail!.avgRating} (${product.productDetail!.ratingCount} ${AppLocalizations.of(context)!.translate('review')})",
                      //   style: TextStyle(fontSize: responsiveFont(10)),
                      // ),
                    ],
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductReview(
                                productId: productModel!.id.toString(),
                              )));
                },
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('see_all')!,
                      style: TextStyle(fontSize: responsiveFont(11)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: responsiveFont(20),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          buildReview
        ],
      ),
    );
  }

  Widget commentPart() {
    final product = Provider.of<ProductProvider>(context, listen: false);

    Widget buildBtnReview = Container(
      child: ListenableProvider.value(
        value: product,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.loadAddReview) {
            return InkWell(
              onTap: null,
              child: Container(
                width: 80,
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3), color: Colors.grey),
                alignment: Alignment.center,
                child: customLoading(),
              ),
            );
          }
          return InkWell(
            onTap: () async {
              if (rating != 0 && reviewController.text.isNotEmpty) {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                await Provider.of<ProductProvider>(context, listen: false)
                    .addReview(context,
                        productId: productModel!.id,
                        rating: rating,
                        review: reviewController.text)
                    .then((value) {
                  setState(() {
                    reviewController.clear();
                    rating = 0;
                  });
                  // loadReviewProduct();
                });
              } else {
                snackBar(context,
                    message: 'You must set the rating and review first');
              }
            },
            child: Container(
              width: 80,
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: rating != 0 && reviewController.text.isNotEmpty
                      ? HexColor("960000")
                      : Colors.grey),
              alignment: Alignment.center,
              child: Text(
                "Submit",
                style: TextStyle(
                    fontSize: responsiveFont(10),
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          );
        }),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('add_review')!,
            style: TextStyle(
                fontSize: responsiveFont(12), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context)!.translate('comment')!,
            style: TextStyle(
                fontSize: responsiveFont(10), fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: reviewController,
            maxLines: 2,
            style: TextStyle(
              fontSize: 10,
            ),
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              hintText: AppLocalizations.of(context)!.translate('hint_review'),
              hintStyle: TextStyle(fontSize: 10, color: HexColor('9e9e9e')),
            ),
            textInputAction: TextInputAction.done,
          ),
          SizedBox(
            height: 10,
          ),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 25,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              print(value);
              setState(() {
                rating = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          buildBtnReview
        ],
      ),
    );
  }

  Widget secondPart(Voucher model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Th??ng tin",
              style: TextStyle(
                  fontSize: responsiveFont(12), fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          HtmlWidget(
            model.description.toString(),
            textStyle: TextStyle(color: HexColor("929292")),
          ),
          widget.isCombo == "true"
              ? productModel2!.vouchers!.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Danh s??ch voucher:",
                        style: TextStyle(
                            fontSize: responsiveFont(12),
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : Container()
              : Container(),
          widget.isCombo == "true"
              ? productModel2!.vouchers!.isNotEmpty
                  ? SizedBox(
                      height: 5,
                    )
                  : Container()
              : Container(),
          widget.isCombo == "true"
              ? productModel2!.vouchers!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: productModel2!.vouchers!.length,
                      itemBuilder: (context, i) {
                        return itemListVoucher(productModel2!.vouchers![i], i);
                      })
                  : Container()
              : Container(),
          Container(
            height: 5,
          )
        ],
      ),
    );
  }

  Widget firstPart(Voucher model) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'simple' == 'simple'
                  ? RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              // text: stringToCurrency(
                              //     double.parse(productModel!.price.toString()),
                              //     context),
                              text: productModel!.soldPrice != null
                                  ? "T??? " +
                                      productModel!.soldPrice.toString() +
                                      " Vnd"
                                  : "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsiveFont(15),
                                  color: Colors.black)),
                        ],
                      ),
                    )
                  : RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          variantPrices.isEmpty
                              ? TextSpan(
                                  text: '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: responsiveFont(11),
                                      color: HexColor("960000")))
                              : TextSpan(
                                  text: variantPrices.first ==
                                          variantPrices.last
                                      ? '${stringToCurrency(variantPrices.first, context)}'
                                      : '${stringToCurrency(variantPrices.first, context)} - ${stringToCurrency(variantPrices.last, context)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: responsiveFont(15),
                                      color: Colors.black)),
                        ],
                      ),
                    ),
              // btnFav
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Visibility(
            // visible: model.discProduct != 0,
            visible: false,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: HexColor("960000")),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .translate('save_product')!,
                        style: TextStyle(
                            fontSize: responsiveFont(8),
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      // Text(
                      //   "${model.discProduct!.round()}%",
                      //   style: TextStyle(
                      //       fontSize: responsiveFont(8), color: Colors.white),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          // text: stringToCurrency(
                          //     double.parse(productModel!.price.toString()),
                          //     context),
                          text: productModel!.soldPrice != null
                              ? "T??? " +
                                  productModel!.soldPrice.toString() +
                                  " Vnd"
                              : "",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: responsiveFont(12),
                              color: HexColor("C4C4C4"))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            model.voucherName!,
            style: TextStyle(fontSize: responsiveFont(11)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              // Row(
              //   children: [
              //     Text(
              //       "???? b??n ",
              //       style: TextStyle(
              //           fontSize: responsiveFont(10),
              //           fontWeight: FontWeight.w500),
              //     ),
              //     Text(
              //       "0",
              //       style: TextStyle(fontSize: responsiveFont(10)),
              //     )
              //   ],
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   height: 11,
              //   width: 1,
              //   color: Colors.black,
              // ),
              // Container(
              //     width: 15.w,
              //     height: 15.h,
              //     child: Image.asset("images/product_detail/starGold.png")),
              // Text(
              //   " 5",
              //   style: TextStyle(fontSize: responsiveFont(10)),
              // ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          widget.isCombo == "false"
              ? Text(
                  // model.stockStatus == 'instock'
                  model.inventory != 0 ? 'C??n h??ng' : 'H???t h??ng',
                  style: TextStyle(
                      fontSize: responsiveFont(11),
                      fontWeight: FontWeight.bold,
                      color: model.inventory != 0 ? Colors.green : Colors.red),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Text(
            // model.stockStatus == 'instock'
            "T??? ng??y " +
                serverFormater
                    .format(DateTime.parse(model.startDate.toString())) +
                " ?????n ng??y " +
                serverFormater.format(DateTime.parse(model.endDate.toString())),
            style: TextStyle(
              fontSize: responsiveFont(11),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          widget.isCombo == "false"
              ? Text(
                  // model.stockStatus == 'instock'
                  "Nh?? cung c???p " + model.provider!.providerName.toString(),
                  style: TextStyle(
                    fontSize: responsiveFont(11),
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  // model.stockStatus == 'instock'
                  "Nhi???u nh?? cung c???p",
                  style: TextStyle(
                      fontSize: responsiveFont(11),
                      fontWeight: FontWeight.bold),
                ),
          SizedBox(
            height: 10,
          ),
          model.serviceType != null
              ? HtmlWidget(
                  "Lo???i d???ch v??? " + model.serviceType!.name.toString(),
                  textStyle: TextStyle(
                      fontSize: responsiveFont(11),
                      fontWeight: FontWeight.bold),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget appBar(Voucher model) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: Text(
        model.summary ?? "",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: responsiveFont(14)),
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
        //             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
        // InkWell(
        //   onTap: () {
        //     shareLinks('product', model.content);
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(right: 15),
        //     child: Icon(
        //       Icons.share,
        //       color: Colors.black,
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget itemList(
      String title, String discount, String price, String crossedPrice, int i) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductDetailVoucher()));
      },
      child: Container(
        margin: EdgeInsets.only(
            left: i == 0 ? 15 : 0, right: i == itemCount - 1 ? 15 : 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width / 3,
        height: double.infinity,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    color: primaryColor,
                  ),
                  child: Image.asset("images/lobby/laptop.png"),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
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
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: Text(
                              price,
                              style: TextStyle(
                                  fontSize: responsiveFont(10),
                                  color: HexColor("960000"),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemListVoucher(Voucher voucher, int index) {
    String? price;
    String? priceName;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new ProductDetailVoucher(
                      productId: voucher.id.toString(),
                      isCombo: voucher.isCombo.toString(),
                    )));
      },
      child: Material(
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
      ),
    );
  }
}
