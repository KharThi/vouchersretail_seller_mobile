import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'dart:developer';

import 'package:nyoba/pages/auth/login_screen.dart';
import 'package:nyoba/pages/product/modal_sheet_cart/modal_sheet_cart.dart';
import 'package:nyoba/provider/home_provider.dart';
import 'package:nyoba/provider/order_provider.dart';
import 'package:nyoba/widgets/home/card_item_shimmer.dart';
import 'package:provider/provider.dart';

import '../app_localizations.dart';

Color primaryColor = HexColor("ED1D1D");
Color secondaryColor = HexColor("960000");

double responsiveFont(double designFont) {
  return ScreenUtil().setSp(designFont + 2);
}

Widget customLoading({Color? color}) {
  return LoadingFlipping.circle(
    borderColor: color != null ? color : HexColor("960000"),
    borderSize: 3.0,
    size: 30.0,
    duration: Duration(milliseconds: 500),
  );
}

printLog(String message, {String? name}) {
  return log(message, name: name ?? 'log');
}

convertDateFormatShortMonth(date) {
  String dateTime = DateFormat("dd MMM yyyy").format(date);
  return dateTime;
}

convertDateFormatSlash(date) {
  String dateTime = DateFormat("dd/MM/yyyy").format(date);
  return dateTime;
}

convertDateFormatFull(date) {
  String dateTime = DateFormat("dd MMMM yyyy").format(date);
  return dateTime;
}

convertDateFormatDash(date) {
  String dateTime = DateFormat("dd-MM-yyyy").format(date);
  return dateTime;
}

snackBar(context, {required String message, Color? color, int duration = 2}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color != null ? color : null,
    duration: Duration(seconds: duration),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String? alertPhone(context) {
  return AppLocalizations.of(context)!.translate('hint_otp');
}

loadingPop(context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
          content: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  customLoading(),
                  SizedBox(width: 10),
                  Text("Loading...")
                ],
              )));
    },
    barrierDismissible: false,
  );
}

buildNoAuth(context) {
  final imageNoLogin =
      Provider.of<HomeProvider>(context, listen: false).imageNoLogin;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      imageNoLogin.image == null
          ? Icon(
              Icons.not_interested,
              color: primaryColor,
              size: 75,
            )
          : CachedNetworkImage(
              imageUrl: imageNoLogin.image!,
              height: MediaQuery.of(context).size.height * 0.4,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Icon(
                    Icons.not_interested,
                    color: primaryColor,
                    size: 75,
                  )),
      SizedBox(
        height: 10,
      ),
      Text(
        "B???n c???n ????ng nh???p ????? s??? d???ng t??nh n??ng n??y!",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, HexColor("960000")])),
        height: 30.h,
        width: MediaQuery.of(context).size.width * 0.5,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: Text(
            "????ng nh???p",
            style: TextStyle(
                color: Colors.white,
                fontSize: responsiveFont(10),
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ],
  );
}

convertHtmlUnescape(String textCharacter) {
  var unescape = HtmlUnescape();
  var text = unescape.convert(textCharacter);
  return text;
}

Widget shimmerProductItemSmall() {
  return ListView.separated(
    itemCount: 6,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, i) {
      return CardItemShimmer(
        i: i,
        itemCount: 6,
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return SizedBox(
        width: 5,
      );
    },
  );
}

Widget buildSearchEmpty(context, text) {
  final searchEmpty =
      Provider.of<HomeProvider>(context, listen: false).imageSearchEmpty;
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        searchEmpty.image == null
            ? Icon(
                Icons.search,
                color: primaryColor,
                size: 75,
              )
            : CachedNetworkImage(
                imageUrl: searchEmpty.image!,
                height: MediaQuery.of(context).size.height * 0.4,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Icon(
                      Icons.search,
                      color: primaryColor,
                      size: 75,
                    )),
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    ),
  );
}

buildButtonCart(context, product) {
  final loadCount =
      Provider.of<OrderProvider>(context, listen: false).loadCartCount;
  return GestureDetector(
    onTap: () {
      if (product.stockStatus != 'outofstock' && product.productStock >= 1) {
        showMaterialModalBottomSheet(
          context: context,
          builder: (context) => ModalSheetCart(
            product: product,
            type: 'add',
            loadCount: loadCount,
          ),
        );
      } else {
        snackBar(context,
            message:
                AppLocalizations.of(context)!.translate('product_out_stock')!);
      }
    },
    child: Icon(
      Icons.add_shopping_cart,
      color: HexColor("960000"),
      size: 20.h,
    ),
  );
}

buildButtonCartPq(context) {
  return GestureDetector(
    onTap: () {
      // if (product.stockStatus != 'outofstock' && product.productStock >= 1) {
      //   showMaterialModalBottomSheet(
      //     context: context,
      //     builder: (context) => ModalSheetCart(
      //       product: product,
      //       type: 'add',
      //       loadCount: loadCount,
      //     ),
      //   );
      // } else {
      //   snackBar(context, message: AppLocalizations.of(context)!.translate('product_out_stock')!);
      // }
    },
    child: Icon(
      Icons.add_shopping_cart,
      color: HexColor("960000"),
      size: 20.h,
    ),
  );
}

buildError(context) {
  return Container(
    padding: EdgeInsets.all(15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline_outlined,
          size: 64,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            "Oops!",
            style: TextStyle(fontSize: responsiveFont(24)),
          ),
        ),
        Container(
          child: Text(
            "Something went wrong. Please refresh the app or contact the administrator/developer.",
            style: TextStyle(fontSize: responsiveFont(18)),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        MaterialButton(
          padding: EdgeInsets.all(10),
          onPressed: () {
            Phoenix.rebirth(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Icon(Icons.refresh), Text('Refresh App')],
          ),
        )
      ],
    ),
  );
}
