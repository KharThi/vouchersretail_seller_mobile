import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/app_localizations.dart';
import 'package:nyoba/pages/home/home_screen.dart';
import 'package:nyoba/pages/point/my_point_screen.dart';
import 'package:nyoba/provider/app_provider.dart';
import 'package:nyoba/provider/home_provider.dart';
import 'package:nyoba/provider/user_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utility.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  loadDetail() async {
    await Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetail()
        .then((value) => this.setState(() {}));
  }

  Future _init() async {
    final _packageInfo = await PackageInfo.fromPlatform();

    return _packageInfo.version;
  }

  logout() async {
    final home = Provider.of<HomeProvider>(context, listen: false);
    var auth = FirebaseAuth.instance;
    // final AccessToken? accessToken = await FacebookAuth.instance.accessToken;

    Session().removeUser();
    if (auth.currentUser != null) {
      await GoogleSignIn().signOut();
    }
    // if (accessToken != null) {
    //   await FacebookAuth.instance.logOut();
    // }
    if (Session.data.getString('login_type') == 'apple') {
      await auth.signOut();
    }
    home.isReload = true;
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final generalSettings = Provider.of<HomeProvider>(context, listen: false);

    final point = Provider.of<UserProvider>(context, listen: false);
    _launchPhoneURL(String phoneNumber) async {
      String url = 'tel:' + phoneNumber;
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "T??i kho???n",
          style: TextStyle(
              fontSize: responsiveFont(16),
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  point.loading
                      ? Text(
                          "Xin ch??o",
                          style: TextStyle(
                              color: HexColor("960000"),
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w500),
                        )
                      : Text(
                          "Xin ch??o, ${Session.data.getString('sellerName')} !",
                          style: TextStyle(
                              color: HexColor("960000"),
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w500),
                        ),
                  Text(
                    "Ch??o m???ng quay l???i",
                    style: TextStyle(fontSize: responsiveFont(9)),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 5,
              color: Colors.black12,
            ),
            point.loading
                ? Container()
                : Visibility(
                    visible: point.point != null,
                    child: buildPointCard(),
                  ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 15, left: 15, bottom: 5),
            //   child: Text(
            //     "T??i kho???n",
            //     style: TextStyle(
            //         fontSize: responsiveFont(10),
            //         fontWeight: FontWeight.w600,
            //         color: HexColor("960000")),
            //   ),
            // ),
            // accountButton("akun", "Th??ng tin t??i kho???n", func: () {
            //   Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => AccountDetailScreen()))
            //       .then((value) => this.setState(() {}));
            // }),
            point.loading
                ? Container()
                : Visibility(
                    visible: point.point != null,
                    child: accountButton("coin",
                        AppLocalizations.of(context)!.translate('my_point')!,
                        func: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPoint()))
                          .then((value) => this.setState(() {}));
                    }),
                  ),
            SizedBox(
              height: 5,
            ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 15, left: 15, bottom: 5),
            //   child: Text(
            //     AppLocalizations.of(context)!.translate('transaction')!,
            //     style: TextStyle(
            //         fontSize: responsiveFont(10),
            //         fontWeight: FontWeight.w600,
            //         color: HexColor("960000")),
            //   ),
            // ),
            // accountButton(
            //     "myorder", AppLocalizations.of(context)!.translate('my_order')!,
            //     func: () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => MyOrder()));
            // }),
            // accountButton("wishlist",
            //     AppLocalizations.of(context)!.translate('wishlist')!, func: () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => WishList()));
            // }),
            // accountButton(
            //     "review", AppLocalizations.of(context)!.translate('review')!,
            //     func: () {
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => ReviewScreen()));
            // }),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 5, left: 15, bottom: 5),
              child: Text(
                "C??i ?????t",
                style: TextStyle(
                    fontSize: responsiveFont(10),
                    fontWeight: FontWeight.w600,
                    color: HexColor("960000")),
              ),
            ),
            // Column(
            //   children: [
            //     Container(
            //       margin: EdgeInsets.symmetric(horizontal: 10),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Row(
            //             children: [
            //               Container(
            //                   width: 25.w,
            //                   height: 25.h,
            //                   child:
            //                       Image.asset("images/account/darktheme.png")),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text(
            //                 "Ch??? ????? t???i",
            //                 style: TextStyle(fontSize: responsiveFont(11)),
            //               )
            //             ],
            //           ),
            //           Consumer<AppNotifier>(
            //               builder: (context, theme, _) => Switch(
            //                     value: theme.isDarkMode,
            //                     onChanged: (value) {
            //                       setState(() {
            //                         theme.isDarkMode = !theme.isDarkMode;
            //                       });
            //                       if (theme.isDarkMode) {
            //                         theme.setDarkMode();
            //                       } else {
            //                         theme.setLightMode();
            //                       }
            //                     },
            //                     activeTrackColor: Colors.lightGreenAccent,
            //                     activeColor: Colors.green,
            //                   )),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       margin: EdgeInsets.symmetric(horizontal: 15),
            //       width: double.infinity,
            //       height: 2,
            //       color: Colors.black12,
            //     )
            //   ],
            // ),
            // accountButton("languange",
            //     AppLocalizations.of(context)!.translate('title_language')!,
            //     func: () {
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => LanguageScreen()));
            // }),
            // accountButton(
            //     "rateapp", AppLocalizations.of(context)!.translate('rate_app')!,
            //     func: () {
            //   if (Platform.isIOS) {
            //     LaunchReview.launch(writeReview: false, iOSAppId: appId);
            //   } else {
            //     LaunchReview.launch(
            //         androidAppId: generalSettings.packageInfo!.packageName);
            //   }
            // }),
            // accountButton("aboutus", "V??? ch??ng t??i", func: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => WebViewScreen(
            //                 url: generalSettings.about.description,
            //                 title: AppLocalizations.of(context)!
            //                     .translate('about_us'),
            //               )));
            // }),
            // accountButton("privacy", "??i???u kho???n b???o m???t", func: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => WebViewScreen(
            //                 url: generalSettings.privacy.description,
            //                 title: AppLocalizations.of(context)!
            //                     .translate('privacy'),
            //               )));
            // }),
            // accountButton("terms_conditions", "??i???u kho???n v?? ??i???u ki???n",
            //     func: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => WebViewScreen(
            //                 url: generalSettings.terms.description,
            //                 title: AppLocalizations.of(context)!
            //                     .translate('terms_conditions'),
            //               )));
            // }),
            // accountButton("contact", "Li??n h???", func: () {
            //   _launchPhoneURL(generalSettings.phone.description!);
            // }),
            accountButton("logout", "????ng xu???t", func: logoutPopDialog),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              alignment: Alignment.centerLeft,
              child: FutureBuilder(
                future: _init(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Phi??n b???n ' + "1.0.0",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: responsiveFont(10)),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              // Text(
              //   "${AppLocalizations.of(context).translate('version')} $version",
              //   style: TextStyle(
              //       fontWeight: FontWeight.w300, fontSize: responsiveFont(10)),
              // ),
            )
          ],
        ),
      ),
    );
  }

  Widget accountButton(String image, String title, {var func}) {
    return Column(
      children: [
        InkWell(
          onTap: func,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset("images/account/$image.png")),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: responsiveFont(11)),
                    )
                  ],
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: 2,
          color: Colors.black12,
        )
      ],
    );
  }

  Widget buildPointCard() {
    final point = Provider.of<UserProvider>(context, listen: false);
    String fullName = "${Session.data.getString('sellerName')}";

    if (point.point == null) {
      return Container();
    }
    return Container(
        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Stack(
          children: [
            Image.asset("images/account/card_point.png"),
            Positioned(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  Session.data
                      .getString('role')!
                      .replaceAll('_', ' ')
                      .toUpperCase(),
                  style: TextStyle(
                      fontSize: responsiveFont(12),
                      color: HexColor("960000"),
                      fontWeight: FontWeight.w600),
                ),
              ),
              top: 15,
              right: 15,
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.translate('full_name')!,
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          color: primaryColor,
                          fontWeight: FontWeight.w400)),
                  Text(
                    fullName.length > 10
                        ? fullName.substring(0, 10) + '... '
                        : fullName,
                    style: TextStyle(
                        fontSize: responsiveFont(18),
                        color: HexColor("960000"),
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              bottom: 10,
              left: 15,
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppLocalizations.of(context)!.translate('total_point')!,
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          color: primaryColor,
                          fontWeight: FontWeight.w400)),
                  point.loading
                      ? Text(
                          '-',
                          style: TextStyle(
                              fontSize: responsiveFont(18),
                              color: HexColor("960000"),
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          '${point.point!.pointsBalance} ${point.point!.pointsLabel}',
                          style: TextStyle(
                              fontSize: responsiveFont(18),
                              color: HexColor("960000"),
                              fontWeight: FontWeight.w600),
                        )
                ],
              ),
              bottom: 10,
              right: 15,
            )
          ],
        ));
  }

  logoutPopDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          insetPadding: EdgeInsets.all(0),
          content: Builder(
            builder: (context) {
              return Container(
                height: 150.h,
                width: 330.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "?????ng ?? ????ng xu???t?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "B???n c?? mu???n ????ng xu???t kh???i t??i kho???n?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Container(
                        child: Column(
                      children: [
                        Container(
                          color: Colors.black12,
                          height: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(false),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15)),
                                      color: primaryColor),
                                  child: Text(
                                    "Kh??ng",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () => logout(),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15)),
                                      color: Colors.white),
                                  child: Text(
                                    "?????ng ??",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ))
                  ],
                ),
              );
            },
          )),
    );
  }
}
