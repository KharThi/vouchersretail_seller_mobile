// ignore_for_file: unused_local_variable

/* Dart Package */
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

import 'package:nyoba/pages/auth/login_screen.dart';
import 'package:nyoba/pages/category/brand_product_screen_voucher.dart';
import 'package:nyoba/pages/notification/notification_screen.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/pages/search/search_screen.dart';
import 'package:nyoba/provider/combo_provider.dart';
import 'package:nyoba/provider/coupon_provider.dart';
import 'package:nyoba/provider/home_provider.dart';
import 'package:nyoba/provider/product_provider.dart';
import 'package:nyoba/provider/voucher_provider.dart';
import 'package:nyoba/provider/wallet_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/widgets/home/card_item_small_pq_voucher.dart';
import 'package:nyoba/widgets/home/flashsale/flash_sale_countdown.dart';
import 'package:provider/provider.dart';

/* Widget  */
import 'package:nyoba/widgets/home/banner/banner_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../app_localizations.dart';

/* Provider */

/* Helper */
import '../../utils/utility.dart';
import '../product/product_detail_screen_voucher.dart';

class LobbyScreen extends StatefulWidget {
  LobbyScreen({Key? key}) : super(key: key);

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen>
    with TickerProviderStateMixin {
  AnimationController? _colorAnimationController;
  AnimationController? _textAnimationController;
  Animation? _colorTween, _titleColorTween, _iconColorTween, _moveTween;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int itemCount = 10;
  int itemCategoryCount = 9;
  int? clickIndex = 0;
  int page = 1;
  String? selectedCategory;
  ScrollController _scrollController = new ScrollController();
  List<Product> listProduct = List.empty(growable: true);
  List<Combo> listCombo = List.empty(growable: true);
  List<Voucher> listVoucher = List.empty(growable: true);
  List<String> listImage = [
    './images/pq/pq1.png',
    './images/pq/pq2.png',
    './images/pq/pq3.png',
    './images/pq/pq4.png',
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // loadProduct();
    // loadCombo();
    loadVoucher();
    printLog('Init', name: 'Init Home');
    final products = Provider.of<ProductProvider>(context, listen: false);
    final home = Provider.of<HomeProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (home.recommendationProducts[0].products!.length % 10 == 0 &&
            !home.loadingMore &&
            home.recommendationProducts[0].products!.isNotEmpty) {
          setState(() {
            page++;
          });
          // loadRecommendationProduct(products.productRecommendation.products);
          // loadProduct();
          // loadCombo();
          loadVoucher();
        }
      }
    });
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(
      begin: primaryColor.withOpacity(0.0),
      end: primaryColor.withOpacity(1.0),
    ).animate(_colorAnimationController!);
    _titleColorTween = ColorTween(
      begin: Colors.white,
      end: HexColor("ED625E"),
    ).animate(_colorAnimationController!);
    _iconColorTween = ColorTween(begin: Colors.white, end: HexColor("#4A3F35"))
        .animate(_colorAnimationController!);
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _moveTween = Tween(
      begin: Offset(0, 0),
      end: Offset(-25, 0),
    ).animate(_colorAnimationController!);

    loadHome();

    if (home.isReload) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        refreshHome();
      });
    }

    // if (Session.data.getBool('isLogin')!) {
    //   loadRecentProduct();
    //   loadWallet();
    //   loadCoupon();
    // }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  int item = 6;

  loadNewProduct(bool loading) async {
    this.setState(() {});
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchNewProducts(clickIndex == 0 ? '' : clickIndex.toString());
  }

  loadRecentProduct() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchRecentProducts();
  }

  loadHome() async {
    await Provider.of<HomeProvider>(context, listen: false)
        .fetchHomeData(context);
  }

  loadWallet() async {
    if (Session.data.getBool('isLogin')!)
      await Provider.of<WalletProvider>(context, listen: false).fetchBalance();
  }

  refreshHome() async {
    if (mounted) {
      context.read<WalletProvider>().changeWalletStatus();
      // loadWallet();
      await Provider.of<HomeProvider>(context, listen: false)
          .fetchHome(context);
      // loadNewProduct(true);
      // loadCoupon();
      loadVoucher();
      _refreshController.refreshCompleted();
      await Provider.of<HomeProvider>(context, listen: false).changeIsReload();
    }
  }

  loadRecommendationProduct(include) async {
    await Provider.of<HomeProvider>(context, listen: false)
        .fetchMoreRecommendation(include, page: page)
        .then((value) {
      this.setState(() {});
      Future.delayed(Duration(milliseconds: 3500), () {
        print('Delayed Done');
        this.setState(() {});
      });
    });
  }

//voucher PQ
  loadProduct() async {
    await Provider.of<HomeProvider>(context, listen: false)
        .fetchProductsV2()
        .then((value) {
      this.setState(() {
        listProduct = value!;
        // for (var element in listProduct) {
        //   print(element.description);
        // }
      });
      Future.delayed(Duration(milliseconds: 3500), () {
        print('Delayed Done');
        this.setState(() {});
      });
    });
  }

  // loadCombo() async {
  //   await Provider.of<ComboProvider>(context, listen: false)
  //       .fetchCombos()
  //       .then((value) {
  //     this.setState(() {
  //       listCombo = value!;
  //       // for (var element in listProduct) {
  //       //   print(element.description);
  //       // }
  //     });
  //     Future.delayed(Duration(milliseconds: 3500), () {
  //       print('Delayed Done');
  //       this.setState(() {});
  //     });
  //   });
  // }

  loadVoucher() async {
    await Provider.of<VoucherProvider>(context, listen: false)
        .fetchVouchers("", "5")
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

  loadCoupon() async {
    await Provider.of<CouponProvider>(context, listen: false)
        .fetchCoupon(page: 1)
        .then((value) => this.setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  final dragController = DragController();

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context, listen: false);
    final home = Provider.of<HomeProvider>(context, listen: false);
    final coupons = Provider.of<CouponProvider>(context, listen: false);

    // PQ voucher combo

    final combos = Provider.of<ComboProvider>(context, listen: false);

    // Widget buildNewProducts = Container(
    //   child: ListenableProvider.value(
    //     value: products,
    //     child: Consumer<ProductProvider>(builder: (context, value, child) {
    //       if (value.loadingNew) {
    //         return Container(
    //             height: MediaQuery.of(context).size.height / 3.0,
    //             child: shimmerProductItemSmall());
    //       }
    //       return AspectRatio(
    //         aspectRatio: 3 / 2,
    //         child: ListView.separated(
    //           itemCount: value.listNewProduct.length,
    //           scrollDirection: Axis.horizontal,
    //           itemBuilder: (context, i) {
    //             return CardItem(
    //               product: value.listNewProduct[i],
    //               i: i,
    //               itemCount: value.listNewProduct.length,
    //             );
    //           },
    //           separatorBuilder: (BuildContext context, int index) {
    //             return SizedBox(
    //               width: 5,
    //             );
    //           },
    //         ),
    //       );
    //     }),
    //   ),
    // );

    //PQ voucher build Combo
    // Widget buildCombos = Container(
    //   child: ListenableProvider.value(
    //     value: products,
    //     child: Consumer<ComboProvider>(builder: (context, value, child) {
    //       // if (value.loadingNew) {
    //       //   return Container(
    //       //       height: MediaQuery.of(context).size.height / 3.0,
    //       //       child: shimmerProductItemSmall());
    //       // }
    //       return AspectRatio(
    //         aspectRatio: 3 / 2,
    //         child: ListView.separated(
    //           // itemCount: value.listCombo.length,
    //           // scrollDirection: Axis.horizontal,
    //           // itemBuilder: (context, i) {
    //           //   return CardItemPq(
    //           //     comboPq: value.listCombo[i],
    //           //     i: i,
    //           //     itemCount: value.listCombo.length,
    //           //   );
    //           // },
    //           itemCount: listCombo.length,
    //           scrollDirection: Axis.horizontal,
    //           itemBuilder: (context, i) {
    //             return CardItemPq(
    //               comboPq: listCombo[i],
    //               i: i,
    //               itemCount: listCombo.length,
    //             );
    //           },
    //           separatorBuilder: (BuildContext context, int index) {
    //             return SizedBox(
    //               width: 5,
    //             );
    //           },
    //         ),
    //       );
    //     }),
    //   ),
    // );
    Widget buildVoucher = Container(
      child: ListenableProvider.value(
        value: products,
        child: Consumer<VoucherProvider>(builder: (context, value, child) {
          // if (value.loadingNew) {
          //   return Container(
          //       height: MediaQuery.of(context).size.height / 3.0,
          //       child: shimmerProductItemSmall());
          // }
          if (isLoading) {
            return customLoading();
          }
          return AspectRatio(
            aspectRatio: 3 / 2,
            child: ListView.separated(
              // itemCount: value.listCombo.length,
              // scrollDirection: Axis.horizontal,
              // itemBuilder: (context, i) {
              //   return CardItemPq(
              //     comboPq: value.listCombo[i],
              //     i: i,
              //     itemCount: value.listCombo.length,
              //   );
              // },
              itemCount: listVoucher.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return new InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new ProductDetailVoucher(
                                  productId: listVoucher[i].id.toString(),
                                ))).then((value) => setState(() {
                          isLoading = true;
                          loadVoucher();
                        }));
                  },
                  child: Container(
                    child: CardItemPqVoucher(
                      voucher: listVoucher[i],
                      i: i,
                      itemCount: listVoucher.length,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 5,
                );
              },
            ),
          );
        }),
      ),
    );

    // Widget buildRecentProducts = Container(
    //   child: ListenableProvider.value(
    //     value: products,
    //     child: Consumer<ProductProvider>(builder: (context, value, child) {
    //       return Visibility(
    //           visible: value.listRecentProduct.isNotEmpty,
    //           child: Column(
    //             children: [
    //               Container(
    //                 margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       AppLocalizations.of(context)!
    //                           .translate('recent_view')!,
    //                       style: TextStyle(
    //                           fontSize: responsiveFont(14),
    //                           fontWeight: FontWeight.w600),
    //                     ),
    //                     GestureDetector(
    //                       onTap: () {
    //                         Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) => ProductMoreScreen(
    //                                       name: AppLocalizations.of(context)!
    //                                           .translate('recent_view')!,
    //                                       include: value.productRecent,
    //                                     )));
    //                       },
    //                       child: Text(
    //                         AppLocalizations.of(context)!.translate('more')!,
    //                         style: TextStyle(
    //                             fontSize: responsiveFont(12),
    //                             fontWeight: FontWeight.w600,
    //                             color: secondaryColor),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               AspectRatio(
    //                 aspectRatio: 3 / 2,
    //                 child: ListView.separated(
    //                   itemCount: value.listRecentProduct.length,
    //                   scrollDirection: Axis.horizontal,
    //                   itemBuilder: (context, i) {
    //                     return CardItem(
    //                       product: value.listRecentProduct[i],
    //                       i: i,
    //                       itemCount: value.listRecentProduct.length,
    //                     );
    //                   },
    //                   separatorBuilder: (BuildContext context, int index) {
    //                     return SizedBox(
    //                       width: 5,
    //                     );
    //                   },
    //                 ),
    //               )
    //             ],
    //           ));
    //     }),
    //   ),
    // );

    // Widget buildRecommendation = Container(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Container(
    //         margin: EdgeInsets.only(left: 15, top: 15),
    //         child: Text(
    //           AppLocalizations.of(context)!.translate('title_hap_3')!,
    //           style: TextStyle(
    //               fontSize: responsiveFont(14), fontWeight: FontWeight.w600),
    //         ),
    //       ),
    //       Container(
    //           margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
    //           child: Text(
    //             AppLocalizations.of(context)!.translate('description_hap_3')!,
    //             style: TextStyle(
    //               fontSize: responsiveFont(12),
    //               color: Colors.black,
    //             ),
    //             textAlign: TextAlign.justify,
    //           )),
    //       //recommendation item
    //       Container(
    //         margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //         child: GridView.builder(
    //           primary: false,
    //           shrinkWrap: true,
    //           itemCount: home.recommendationProducts[0].products!.length,
    //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisSpacing: 10,
    //               mainAxisSpacing: 10,
    //               crossAxisCount: 2,
    //               childAspectRatio: 78 / 125),
    //           itemBuilder: (context, i) {
    //             return GridItem(
    //               i: i,
    //               itemCount: home.recommendationProducts[0].products!.length,
    //               product: home.recommendationProducts[0].products![i],
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    // start copy above
    // Widget buildProduct = Container(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Container(
    //         margin: EdgeInsets.only(left: 15, top: 15),
    //         child: Text(
    //           "Sản phẩm",
    //           style: TextStyle(
    //               fontSize: responsiveFont(14), fontWeight: FontWeight.w600),
    //         ),
    //       ),
    //       Container(
    //           margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
    //           child: Text(
    //             "Đễ xuất sản phẩm",
    //             style: TextStyle(
    //               fontSize: responsiveFont(12),
    //               color: Colors.black,
    //             ),
    //             textAlign: TextAlign.justify,
    //           )),
    //       //recommendation item
    //       Container(
    //         margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //         child: GridView.builder(
    //           primary: false,
    //           shrinkWrap: true,
    //           itemCount: listProduct.length,
    //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisSpacing: 10,
    //               mainAxisSpacing: 10,
    //               crossAxisCount: 2,
    //               childAspectRatio: 78 / 125),
    //           itemBuilder: (context, i) {
    //             return GridItemPQ(
    //               i: i,
    //               itemCount: listProduct.length,
    //               product: listProduct[i],
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    //end copy

    String fullName =
        "${Session.data.getString('firstname')} ${Session.data.getString('lastname')}";

    return ColorfulSafeArea(
      color: primaryColor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? customLoading()
            : Stack(
                children: [
                  SmartRefresher(
                    controller: _refreshController,
                    scrollController: _scrollController,
                    onRefresh: refreshHome,
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                top: 60.h,
                                left: 0,
                                width: MediaQuery.of(context).size.width,
                                height: 180.h,
                                child: ClipPath(
                                  clipper: OvalBottomBorderClipper(),
                                  child: Container(
                                    height: 180.h,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              appBar(),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 70.h,
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 12,
                                    margin: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Container(
                                            height: double.infinity,
                                            alignment: Alignment
                                                .center, // This is needed
                                            child: Image.asset(
                                              "images/icon/icon.png",
                                              fit: BoxFit.contain,
                                            )),
                                        // CachedNetworkImage(
                                        //   imageUrl: home.logo.image!,
                                        //   placeholder: (context, url) => Container(),
                                        //   errorWidget: (context, url, error) => Icon(
                                        //     Icons.image_not_supported_rounded,
                                        //     size: 15,
                                        //   ),
                                        // ),
                                        Container(
                                          width: 12,
                                        ),
                                        Visibility(
                                            visible: Session.data
                                                        .getBool('isLogin') ==
                                                    null ||
                                                !Session.data
                                                    .getBool('isLogin')!,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "Phú Quốc Voucher",
                                                    style: TextStyle(
                                                        fontSize:
                                                            responsiveFont(14),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Vui lòng đăng nhập ",
                                                        style: TextStyle(
                                                            fontSize:
                                                                responsiveFont(
                                                                    10),
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Login(
                                                                            isFromNavBar:
                                                                                false,
                                                                          )));
                                                        },
                                                        child: Text(
                                                          "Tại đây",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  responsiveFont(
                                                                      10),
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                        Session.data.getString('firstname') !=
                                                null
                                            ? Visibility(
                                                visible: Session.data
                                                    .getBool('isLogin')!,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        fullName.length > 10
                                                            ? fullName
                                                                    .substring(
                                                                        0, 10) +
                                                                '... '
                                                            : fullName,
                                                        style: TextStyle(
                                                            fontSize:
                                                                responsiveFont(
                                                                    14),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'welcome_back')!,
                                                        style: TextStyle(
                                                            fontSize:
                                                                responsiveFont(
                                                                    10),
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                            : Container()
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 0,
                                  ),
                                  //Banner Item start Here
                                  Consumer<HomeProvider>(
                                      builder: (context, value, child) {
                                    return BannerContainer(
                                      contentHeight:
                                          MediaQuery.of(context).size.height,
                                      dataSliderLength: value.banners.length,
                                      dataSlider: value.banners,
                                      loading: customLoading(),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                          // wallet
                          // WalletCard(showBtnMore: true),
                          Container(
                            height: 15,
                          ),
                          //category section
                          // Consumer<HomeProvider>(builder: (context, value, child) {
                          //   return BadgeCategory(
                          //     value.categories,
                          //   );
                          // }),
                          //flash sale countdown & card product item
                          Consumer<HomeProvider>(
                              builder: (context, value, child) {
                            if (value.flashSales.isEmpty) {
                              return Container();
                            }
                            return FlashSaleCountdown(
                              dataFlashSaleCountDown: home.flashSales,
                              dataFlashSaleProducts:
                                  home.flashSales[0].products,
                              textAnimationController: _textAnimationController,
                              colorAnimationController:
                                  _colorAnimationController,
                              colorTween: _colorTween,
                              iconColorTween: _iconColorTween,
                              moveTween: _moveTween,
                              titleColorTween: _titleColorTween,
                              loading: home.loading,
                            );
                          }),
                          // Container(
                          //   width: double.infinity,
                          //   margin: EdgeInsets.only(
                          //       left: 15, bottom: 10, right: 15, top: 15),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         AppLocalizations.of(context)!
                          //             .translate('new_product')!,
                          //         style: TextStyle(
                          //             fontSize: responsiveFont(14),
                          //             fontWeight: FontWeight.w600),
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => BrandProducts(
                          //                         categoryId: clickIndex == 0
                          //                             ? ''
                          //                             : clickIndex.toString(),
                          //                         brandName: selectedCategory ??
                          //                             AppLocalizations.of(context)!
                          //                                 .translate('new_product'),
                          //                         sortIndex: 1,
                          //                       )));
                          //         },
                          //         child: Text(
                          //           AppLocalizations.of(context)!.translate('more')!,
                          //           style: TextStyle(
                          //               fontSize: responsiveFont(12),
                          //               fontWeight: FontWeight.w600,
                          //               color: secondaryColor),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Consumer<CategoryProvider>(
                          //     builder: (context, value, child) {
                          //   if (value.loading) {
                          //     return Container();
                          //   } else {
                          //     return Container(
                          //       height: MediaQuery.of(context).size.height / 21,
                          //       child: ListView.separated(
                          //           itemCount: value.productCategories.length,
                          //           scrollDirection: Axis.horizontal,
                          //           itemBuilder: (context, i) {
                          //             return GestureDetector(
                          //                 onTap: () {
                          //                   if (value.productCategories[i].id ==
                          //                       clickIndex) {
                          //                     setState(() {
                          //                       clickIndex = 0;
                          //                       selectedCategory =
                          //                           AppLocalizations.of(context)!
                          //                               .translate('new_product');
                          //                     });
                          //                   } else {
                          //                     setState(() {
                          //                       clickIndex =
                          //                           value.productCategories[i].id;
                          //                       selectedCategory =
                          //                           value.productCategories[i].name;
                          //                     });
                          //                   }
                          //                   loadNewProduct(true);
                          //                   setState(() {});
                          //                 },
                          //                 child: tabCategory(
                          //                     value.productCategories[i],
                          //                     i,
                          //                     value.productCategories.length));
                          //           },
                          //           separatorBuilder:
                          //               (BuildContext context, int index) {
                          //             return SizedBox(
                          //               width: 8,
                          //             );
                          //           }),
                          //     );
                          //   }
                          // }),
                          // Container(
                          //   height: 10,
                          // ),
                          // buildNewProducts,
                          // Container(
                          //   height: 15,
                          // ),
                          //Start build Combo
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 15, bottom: 10, right: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Voucher",
                                  style: TextStyle(
                                    fontSize: responsiveFont(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BrandProductsVoucher(
                                                  categoryId: clickIndex == 0
                                                      ? ''
                                                      : clickIndex.toString(),
                                                  brandName: "Voucher",
                                                  sortIndex: 1,
                                                ))).then(
                                        (value) => setState(() {
                                              isLoading = true;
                                              loadVoucher();
                                            }));
                                  },
                                  child: Text(
                                    "Xem thêm",
                                    style: TextStyle(
                                        fontSize: responsiveFont(12),
                                        fontWeight: FontWeight.w600,
                                        color: secondaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          buildVoucher,
                          //End build combo
                          Container(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Một số hình ảnh Phú Quốc",
                              style: TextStyle(
                                  fontSize: responsiveFont(14),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          //Mini Banner Item start Here
                          // Consumer<HomeProvider>(builder: (context, value, child) {
                          //   return Container(
                          //     margin: EdgeInsets.only(
                          //         left: 15, right: 15, top: 10, bottom: 15),
                          //     child: GridView.builder(
                          //       primary: false,
                          //       shrinkWrap: true,
                          //       itemCount: value.bannerSpecial.length,
                          //       gridDelegate:
                          //           SliverGridDelegateWithFixedCrossAxisCount(
                          //               crossAxisSpacing: 10,
                          //               mainAxisSpacing: 10,
                          //               crossAxisCount: 2,
                          //               childAspectRatio: 2 / 1),
                          //       itemBuilder: (context, i) {
                          //         return Container(
                          //           decoration: BoxDecoration(
                          //               color: primaryColor,
                          //               borderRadius: BorderRadius.circular(5)),
                          //           child: InkWell(
                          //             onTap: () {
                          //               if (value.bannerSpecial[i].product != null) {
                          //                 if (value.bannerSpecial[i].linkTo ==
                          //                     'product') {
                          //                   Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                           builder: (context) =>
                          //                               ProductDetail(
                          //                                 productId: value
                          //                                     .bannerSpecial[i]
                          //                                     .product
                          //                                     .toString(),
                          //                               )));
                          //                 } else {
                          //                   Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                           builder: (context) =>
                          //                               BrandProducts(
                          //                                 categoryId: value
                          //                                     .bannerSpecial[i]
                          //                                     .product
                          //                                     .toString(),
                          //                                 brandName: value
                          //                                     .bannerSpecial[i].name,
                          //                               )));
                          //                 }
                          //               }
                          //             },
                          //             child: Image.network(
                          //                 value.bannerSpecial[i].image!),
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   );
                          // }),

                          //Start banner
                          //Mini Banner Item start Here
                          Container(
                            margin: EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 15),
                            child: GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: 4,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 1),
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                    onTap: () {
                                      // if (value.bannerSpecial[i].product != null) {
                                      //   if (value.bannerSpecial[i].linkTo ==
                                      //       'product') {
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 ProductDetail(
                                      //                   productId: value
                                      //                       .bannerSpecial[i]
                                      //                       .product
                                      //                       .toString(),
                                      //                 )));
                                      //   } else {
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 BrandProducts(
                                      //                   categoryId: value
                                      //                       .bannerSpecial[i]
                                      //                       .product
                                      //                       .toString(),
                                      //                   brandName: value
                                      //                       .bannerSpecial[i].name,
                                      //                 )));
                                      //   }
                                      // }
                                    },
                                    // child: Image.network(listImage[i]),
                                    child: Image.asset(
                                      listImage[i],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          //End banner
                          //special for you item
                          // Consumer<HomeProvider>(builder: (context, value, child) {
                          //   return Column(
                          //     children: [
                          //       Container(
                          //           width: double.infinity,
                          //           margin: EdgeInsets.only(
                          //               left: 15, bottom: 10, right: 15),
                          //           child: Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceBetween,
                          //                 children: [
                          //                   Text(
                          //                     value.specialProducts[0].title! ==
                          //                             'Special Promo : App Only'
                          //                         ? AppLocalizations.of(context)!
                          //                             .translate('title_hap_1')!
                          //                         : value.specialProducts[0].title!,
                          //                     style: TextStyle(
                          //                         fontSize: responsiveFont(14),
                          //                         fontWeight: FontWeight.w600),
                          //                   ),
                          //                   // Text(
                          //                   //   value.specialProducts[0].title! ==
                          //                   //           'Special Promo : App Only'
                          //                   //       ? AppLocalizations.of(context)!
                          //                   //           .translate('title_hap_1')!
                          //                   //       : value.specialProducts[0].title!,
                          //                   //   style: TextStyle(
                          //                   //       fontSize: responsiveFont(14),
                          //                   //       fontWeight: FontWeight.w600),
                          //                   // ),
                          //                   GestureDetector(
                          //                     onTap: () {
                          //                       Navigator.push(
                          //                           context,
                          //                           MaterialPageRoute(
                          //                               builder:
                          //                                   (context) =>
                          //                                       ProductMoreScreen(
                          //                                         include: products
                          //                                             .productSpecial
                          //                                             .products,
                          //                                         name: value
                          //                                                     .specialProducts[
                          //                                                         0]
                          //                                                     .title! ==
                          //                                                 'Special Promo : App Only'
                          //                                             ? AppLocalizations.of(
                          //                                                     context)!
                          //                                                 .translate(
                          //                                                     'title_hap_1')!
                          //                                             : value
                          //                                                 .specialProducts[
                          //                                                     0]
                          //                                                 .title!,
                          //                                       )));
                          //                     },
                          //                     child: Text(
                          //                       AppLocalizations.of(context)!
                          //                           .translate('more')!,
                          //                       style: TextStyle(
                          //                           fontSize: responsiveFont(12),
                          //                           fontWeight: FontWeight.w600,
                          //                           color: secondaryColor),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //               Text(
                          //                 value.specialProducts[0].description! ==
                          //                         'For You'
                          //                     ? AppLocalizations.of(context)!
                          //                         .translate('description_hap_1')!
                          //                     : value.specialProducts[0].description!,
                          //                 style: TextStyle(
                          //                   fontSize: responsiveFont(12),
                          //                   color: Colors.black,
                          //                 ),
                          //                 textAlign: TextAlign.justify,
                          //               )
                          //             ],
                          //           )),
                          //       AspectRatio(
                          //         aspectRatio: 3 / 2,
                          //         child: value.loading
                          //             ? shimmerProductItemSmall()
                          //             : ListView.separated(
                          //                 itemCount: value
                          //                     .specialProducts[0].products!.length,
                          //                 scrollDirection: Axis.horizontal,
                          //                 itemBuilder: (context, i) {
                          //                   return CardItem(
                          //                     product: value
                          //                         .specialProducts[0].products![i],
                          //                     i: i,
                          //                     itemCount: value.specialProducts[0]
                          //                         .products!.length,
                          //                   );
                          //                 },
                          //                 separatorBuilder:
                          //                     (BuildContext context, int index) {
                          //                   return SizedBox(
                          //                     width: 5,
                          //                   );
                          //                 },
                          //               ),
                          //       ),
                          //     ],
                          //   );
                          // }),
                          // Container(
                          //   height: 10,
                          // ),
                          // Stack(
                          //   children: [
                          //     Container(
                          //       color: primaryColor,
                          //       width: double.infinity,
                          //       height: MediaQuery.of(context).size.height / 3.5,
                          //     ),
                          //     Consumer<HomeProvider>(
                          //         builder: (context, value, child) {
                          //       if (value.loading) {
                          //         return Column(
                          //           children: [
                          //             Shimmer.fromColors(
                          //                 child: Container(
                          //                   width: double.infinity,
                          //                   margin: EdgeInsets.only(
                          //                       left: 15, right: 15, top: 10),
                          //                   child: Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: [
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment.spaceBetween,
                          //                         children: [
                          //                           Container(
                          //                             width: 150,
                          //                             height: 10,
                          //                             color: Colors.white,
                          //                           )
                          //                         ],
                          //                       ),
                          //                       Container(
                          //                         height: 2,
                          //                       ),
                          //                       Container(
                          //                         width: 100,
                          //                         height: 8,
                          //                         color: Colors.white,
                          //                       )
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 baseColor: Colors.grey[300]!,
                          //                 highlightColor: Colors.grey[100]!),
                          //             Container(
                          //               height: 10,
                          //             ),
                          //             Container(
                          //               height:
                          //                   MediaQuery.of(context).size.height / 3.0,
                          //               child: shimmerProductItemSmall(),
                          //             )
                          //           ],
                          //         );
                          //       }
                          //       return Column(
                          //         children: [
                          //           Container(
                          //             width: double.infinity,
                          //             margin: EdgeInsets.only(
                          //                 left: 15, right: 15, top: 10),
                          //             child: Column(
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               children: [
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     Text(
                          //                       value.bestProducts[0].title! ==
                          //                               'Best Seller'
                          //                           ? AppLocalizations.of(context)!
                          //                               .translate('title_hap_2')!
                          //                           : value.bestProducts[0].title!,
                          //                       style: TextStyle(
                          //                           color: Colors.white,
                          //                           fontSize: responsiveFont(14),
                          //                           fontWeight: FontWeight.w600),
                          //                     ),
                          //                     GestureDetector(
                          //                       onTap: () {
                          //                         Navigator.push(
                          //                             context,
                          //                             MaterialPageRoute(
                          //                                 builder:
                          //                                     (context) =>
                          //                                         ProductMoreScreen(
                          //                                           name: value
                          //                                                       .bestProducts[
                          //                                                           0]
                          //                                                       .title! ==
                          //                                                   'Best Seller'
                          //                                               ? AppLocalizations.of(
                          //                                                       context)!
                          //                                                   .translate(
                          //                                                       'title_hap_2')!
                          //                                               : value
                          //                                                   .bestProducts[
                          //                                                       0]
                          //                                                   .title!,
                          //                                           include: products
                          //                                               .productBest
                          //                                               .products,
                          //                                         )));
                          //                       },
                          //                       child: Text(
                          //                         AppLocalizations.of(context)!
                          //                             .translate('more')!,
                          //                         style: TextStyle(
                          //                             fontSize: responsiveFont(12),
                          //                             fontWeight: FontWeight.w600,
                          //                             color: Colors.white),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 Text(
                          //                   value.bestProducts[0].description! ==
                          //                           'Get The Best Products'
                          //                       ? AppLocalizations.of(context)!
                          //                           .translate('description_hap_2')!
                          //                       : value.bestProducts[0].description!,
                          //                   style: TextStyle(
                          //                     fontSize: responsiveFont(12),
                          //                     color: Colors.white,
                          //                   ),
                          //                   textAlign: TextAlign.justify,
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //           Container(
                          //             height: 10,
                          //           ),
                          //           AspectRatio(
                          //             aspectRatio: 3 / 2,
                          //             child: ListView.separated(
                          //               itemCount:
                          //                   value.bestProducts[0].products!.length,
                          //               scrollDirection: Axis.horizontal,
                          //               itemBuilder: (context, i) {
                          //                 return CardItem(
                          //                   product:
                          //                       value.bestProducts[0].products![i],
                          //                   i: i,
                          //                   itemCount: value
                          //                       .bestProducts[0].products!.length,
                          //                 );
                          //               },
                          //               separatorBuilder:
                          //                   (BuildContext context, int index) {
                          //                 return SizedBox(
                          //                   width: 5,
                          //                 );
                          //               },
                          //             ),
                          //           )
                          //         ],
                          //       );
                          //     }),
                          //   ],
                          // ),
                          // //Start Voucher
                          // Stack(
                          //   children: [
                          //     Container(
                          //       color: primaryColor,
                          //       width: double.infinity,
                          //       height: MediaQuery.of(context).size.height / 3.5,
                          //     ),
                          //     Consumer<HomeProvider>(
                          //         builder: (context, value, child) {
                          //       if (value.loading) {
                          //         return Column(
                          //           children: [
                          //             Shimmer.fromColors(
                          //                 child: Container(
                          //                   width: double.infinity,
                          //                   margin: EdgeInsets.only(
                          //                       left: 15, right: 15, top: 10),
                          //                   child: Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: [
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment.spaceBetween,
                          //                         children: [
                          //                           Container(
                          //                             width: 150,
                          //                             height: 10,
                          //                             color: Colors.white,
                          //                           )
                          //                         ],
                          //                       ),
                          //                       Container(
                          //                         height: 2,
                          //                       ),
                          //                       Container(
                          //                         width: 100,
                          //                         height: 8,
                          //                         color: Colors.white,
                          //                       )
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 baseColor: Colors.grey[300]!,
                          //                 highlightColor: Colors.grey[100]!),
                          //             Container(
                          //               height: 10,
                          //             ),
                          //             Container(
                          //               height:
                          //                   MediaQuery.of(context).size.height / 3.0,
                          //               child: shimmerProductItemSmall(),
                          //             )
                          //           ],
                          //         );
                          //       }
                          //       return Column(
                          //         children: [
                          //           Container(
                          //             width: double.infinity,
                          //             margin: EdgeInsets.only(
                          //                 left: 15, right: 15, top: 10),
                          //             child: Column(
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               children: [
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     Text(
                          //                       "Voucher",
                          //                       style: TextStyle(
                          //                           color: Colors.white,
                          //                           fontSize: responsiveFont(14),
                          //                           fontWeight: FontWeight.w600),
                          //                     ),
                          //                     GestureDetector(
                          //                       onTap: () {
                          //                         Navigator.push(
                          //                             context,
                          //                             MaterialPageRoute(
                          //                                 builder:
                          //                                     (context) =>
                          //                                         ProductMoreScreen(
                          //                                           name: value
                          //                                                       .bestProducts[
                          //                                                           0]
                          //                                                       .title! ==
                          //                                                   'Best Seller'
                          //                                               ? AppLocalizations.of(
                          //                                                       context)!
                          //                                                   .translate(
                          //                                                       'title_hap_2')!
                          //                                               : value
                          //                                                   .bestProducts[
                          //                                                       0]
                          //                                                   .title!,
                          //                                           include: products
                          //                                               .productBest
                          //                                               .products,
                          //                                         )));
                          //                       },
                          //                       child: Text(
                          //                         AppLocalizations.of(context)!
                          //                             .translate('more')!,
                          //                         style: TextStyle(
                          //                             fontSize: responsiveFont(12),
                          //                             fontWeight: FontWeight.w600,
                          //                             color: Colors.white),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 Text(
                          //                   "Get The Best Voucher",
                          //                   style: TextStyle(
                          //                     fontSize: responsiveFont(12),
                          //                     color: Colors.white,
                          //                   ),
                          //                   textAlign: TextAlign.justify,
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //           Container(
                          //             height: 10,
                          //           ),
                          //           AspectRatio(
                          //             aspectRatio: 3 / 2,
                          //             child: ListView.separated(
                          //               itemCount: listVoucher.length,
                          //               scrollDirection: Axis.horizontal,
                          //               itemBuilder: (context, i) {
                          //                 return CardItemPqVoucher(
                          //                   voucher: listVoucher[i],
                          //                   i: i,
                          //                   itemCount: listVoucher.length,
                          //                 );
                          //               },
                          //               separatorBuilder:
                          //                   (BuildContext context, int index) {
                          //                 return SizedBox(
                          //                   width: 5,
                          //                 );
                          //               },
                          //             ),
                          //           )
                          //         ],
                          //       );
                          //     }),
                          //   ],
                          // ),
                          // //End voucher
                          // Container(
                          //   margin: EdgeInsets.only(
                          //       left: 15, right: 15, top: 15, bottom: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         AppLocalizations.of(context)!
                          //             .translate('banner_2')!,
                          //         style: TextStyle(
                          //             fontSize: responsiveFont(14),
                          //             fontWeight: FontWeight.w600),
                          //       ),
                          //       /*GestureDetector(
                          //         onTap: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => AllProducts()));
                          //         },
                          //         child: Text(
                          //           "More",
                          //           style: TextStyle(
                          //               fontSize: responsiveFont(12),
                          //               fontWeight: FontWeight.w600,
                          //               color: secondaryColor),
                          //         ),
                          //       ),*/
                          //     ],
                          //   ),
                          // ),
                          // //Mini Banner Item start Here
                          // Consumer<HomeProvider>(builder: (context, value, child) {
                          //   return Container(
                          //     margin: EdgeInsets.only(
                          //         left: 15, right: 15, top: 10, bottom: 15),
                          //     child: GridView.builder(
                          //       primary: false,
                          //       shrinkWrap: true,
                          //       itemCount: value.bannerLove.length,
                          //       gridDelegate:
                          //           SliverGridDelegateWithFixedCrossAxisCount(
                          //               crossAxisSpacing: 10,
                          //               mainAxisSpacing: 10,
                          //               crossAxisCount: 2,
                          //               childAspectRatio: 2 / 1),
                          //       itemBuilder: (context, i) {
                          //         return Container(
                          //           decoration: BoxDecoration(
                          //               color: primaryColor,
                          //               borderRadius: BorderRadius.circular(5)),
                          //           child: InkWell(
                          //               onTap: () {
                          //                 if (value.bannerLove[i].product != null) {
                          //                   if (value.bannerLove[i].linkTo ==
                          //                       'product') {
                          //                     Navigator.push(
                          //                         context,
                          //                         MaterialPageRoute(
                          //                             builder: (context) =>
                          //                                 ProductDetail(
                          //                                   productId: value
                          //                                       .bannerLove[i].product
                          //                                       .toString(),
                          //                                 )));
                          //                   } else {
                          //                     Navigator.push(
                          //                         context,
                          //                         MaterialPageRoute(
                          //                             builder: (context) =>
                          //                                 BrandProducts(
                          //                                   categoryId: value
                          //                                       .bannerLove[i].product
                          //                                       .toString(),
                          //                                   brandName: value
                          //                                       .bannerLove[i].name,
                          //                                 )));
                          //                   }
                          //                 }
                          //               },
                          //               child: Image.network(
                          //                   value.bannerLove[i].image!)),
                          //         );
                          //       },
                          //     ),
                          //   );
                          // }),
                          // //recently viewed item
                          // buildRecentProducts,
                          // Container(
                          //   height: 15,
                          // ),
                          // Container(
                          //   width: double.infinity,
                          //   height: 7,
                          //   color: HexColor("EEEEEE"),
                          // ),
                          // buildRecommendation,
                          // Container(
                          //   height: 15,
                          // ),
                          // Container(
                          //   width: double.infinity,
                          //   height: 7,
                          //   color: HexColor("EEEEEE"),
                          // ),
                          // buildProduct,
                          // if (home.loadingMore) customLoading()
                        ],
                      ),
                    ),
                  ),
                  // Visibility(
                  //     visible: coupons.coupons.isNotEmpty,
                  //     child: DraggableWidget(
                  //       bottomMargin: 120,
                  //       topMargin: 60,
                  //       intialVisibility: true,
                  //       horizontalSpace: 3,
                  //       verticalSpace: 30,
                  //       normalShadow: BoxShadow(
                  //         color: Colors.transparent,
                  //         offset: Offset(0, 10),
                  //         blurRadius: 0,
                  //       ),
                  //       shadowBorderRadius: 50,
                  //       child: GestureDetector(
                  //           onTap: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => CouponScreen()));
                  //           },
                  //           child: Container(
                  //               height: 100,
                  //               width: 100,
                  //               child: Image.asset("images/lobby/gift-coupon.gif"))),
                  //       initialPosition: AnchoringPosition.bottomRight,
                  //       dragController: dragController,
                  //     ))
                ],
              ),
      ),
    );
  }

  Widget tabCategory(ProductCategoryModel model, int i, int count) {
    return Container(
      margin: EdgeInsets.only(
          left: i == 0 ? 15 : 0, right: i == count - 1 ? 15 : 0),
      child: Tab(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: clickIndex == model.id
                  ? primaryColor.withOpacity(0.5)
                  : Colors.white,
              border: Border.all(
                  color: clickIndex == model.id
                      ? secondaryColor
                      : HexColor("B0b0b0")),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              convertHtmlUnescape(model.name!),
              style: TextStyle(
                  fontSize: 13,
                  color: clickIndex == model.id
                      ? secondaryColor
                      : HexColor("B0b0b0")),
            )),
      ),
    );
  }

  Widget appBar() {
    final animatedText =
        Provider.of<HomeProvider>(context, listen: false).searchBarText;
    return Material(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Container(
          height: 65.h,
          padding: EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()))
                          .then((value) => setState(() {
                                loadVoucher();
                                isLoading = true;
                              }));
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 200.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: responsiveFont(12),
                                  color: Colors.black45),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: true,
                                repeatForever: true,
                                animatedTexts: [
                                  TyperAnimatedText("Tiềm kiếm",
                                      speed: Duration(milliseconds: 80)),
                                  if (true) TyperAnimatedText("Ăn uống"),
                                  if (true) TyperAnimatedText("Vui chơi"),
                                ],
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchScreen()));
                                },
                              ),
                            )
                            // : DefaultTextStyle(
                            //     style: TextStyle(
                            //         fontSize: responsiveFont(12),
                            //         color: Colors.black45),
                            //     child: AnimatedTextKit(
                            //       isRepeatingAnimation: true,
                            //       repeatForever: true,
                            //       animatedTexts: [
                            //         TyperAnimatedText(
                            //             AppLocalizations.of(context)!
                            //                 .translate('search')!,
                            //             speed: Duration(milliseconds: 80)),
                            //       ],
                            //       onTap: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     SearchScreen()));
                            //       },
                            //     ),
                            //   ),
                          ],
                        )),
                  )),
              Container(
                width: 10.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => SocmedScreen()));
                  //   },
                  //   child: Container(
                  //       width: 23.w,
                  //       child: Image.asset("images/lobby/icon-cs-app-bar.png")),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => WishList()));
                  //   },
                  //   child: Container(
                  //       margin: EdgeInsets.only(left: 10),
                  //       width: 27.w,
                  //       child: Image.asset("images/lobby/heart.png")),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => MyOrder()));
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     width: 27.w,
                  //     child: Image.asset(
                  //       "images/lobby/document.png",
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                    },
                    child: Container(
                        width: 27.w,
                        child: Image.asset(
                          "images/lobby/bellRinging.png",
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
