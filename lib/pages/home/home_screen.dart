import 'package:flutter/material.dart';
import 'package:nyoba/pages/account/account_screen.dart';
import 'package:nyoba/pages/order/my_order_screen.dart';
import 'package:nyoba/pages/revenue/revenue_screen.dart';
import 'package:nyoba/provider/order_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import '../../app_localizations.dart';
import '../auth/login_screen.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'lobby_screen.dart';
import '../order/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool? isLogin = false;
  Animation<double>? animation;
  late AnimationController controller;
  List<bool> isAnimate = [false, false, false, false, false];
  Timer? _timer;

  static List<Widget> _widgetOptions = <Widget>[
    LobbyScreen(),
    RevenueScreen(),
    MyOrder(),
    CartScreen(
      isFromHome: true,
    ),
    AccountScreen()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 24, end: 24).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0,
          0.150,
          curve: Curves.ease,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
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
                                onTap: () => Navigator.of(context).pop(true),
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
    ).then((value) => value as bool);
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        canDismissDialog: false,
        showIgnore: false,
        showReleaseNotes: false,
      ),
      // messages: CustomMessages()),
      child: WillPopScope(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: _widgetOptions.elementAt(_selectedIndex),
            bottomNavigationBar: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: bottomNavBar,
                ),
              ],
            ),
          ),
          onWillPop: _onWillPop),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget bottomNavBar(BuildContext context, Widget? child) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5)]),
      child: BottomAppBar(
        child: Container(
          height: 50.h,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      isAnimate[0] = true;
                      _animatedFlutterLogoState(0);
                    });
                    await _onItemTapped(0);
                  },
                  child: Container(
                      child: navbarItem(0, "images/lobby/home.png",
                          "images/lobby/homeClicked.png", "Trang ch???", 28, 14)),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isAnimate[1] = true;
                        _animatedFlutterLogoState(1);

                        _onItemTapped(1);
                      });
                    },
                    child: Container(
                        child: navbarItem(
                            1,
                            "images/lobby/writing.png",
                            "images/lobby/writingClicked.png",
                            "Thu nh???p",
                            28,
                            14)),
                  )),
              Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isAnimate[2] = true;
                        _animatedFlutterLogoState(2);

                        _onItemTapped(2);
                      });
                    },
                    child: Container(
                        child: navbarItem(
                            2,
                            "images/order/processing_dark.png",
                            "images/order/processing_dark.png",
                            "????n h??ng",
                            28,
                            14)),
                  )),
              Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isAnimate[3] = true;
                        _animatedFlutterLogoState(3);

                        _onItemTapped(3);
                      });
                    },
                    child: Container(
                        child: navbarItem(
                            3,
                            "images/lobby/cart.png",
                            "images/lobby/cartClicked.png",
                            "Gi??? h??ng",
                            28,
                            14)),
                  )),
              Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      if (Session.data.getBool('isLogin') != null) {
                        setState(() {
                          isLogin = Session.data.getBool('isLogin');
                        });
                      }
                      if (!isLogin!) {
                        setState(() {
                          _widgetOptions[4] = Login();
                        });
                      } else {
                        setState(() {
                          _widgetOptions[4] = AccountScreen();
                        });
                      }
                      printLog(isLogin.toString(), name: 'isLogin');
                      printLog(Session.data.getBool('isLogin').toString(),
                          name: 'isLoginShared');
                      setState(() {
                        isAnimate[4] = true;
                        _animatedFlutterLogoState(4);

                        _onItemTapped(4);
                      });
                    },
                    child: Container(
                        child: navbarItem(
                            4,
                            "images/lobby/account.png",
                            "images/lobby/accountClicked.png",
                            "T??i kho???n",
                            28,
                            14)),
                  ))
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
        elevation: 5,
      ),
    );
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  _animatedFlutterLogoState(int index) {
    _timer = new Timer(const Duration(milliseconds: 200), () {
      setState(() {
        isAnimate[index] = false;
      });
    });
    return _timer;
  }

  Widget navbarItem(
    int index,
    String image,
    String clickedImage,
    String title,
    int width,
    int smallWidth,
  ) {
    var count = Provider.of<OrderProvider>(context).cartCount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 1,
        ),
        Stack(
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: isAnimate[index] == true ? 0 : 1,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  alignment: Alignment.bottomCenter,
                  width: isAnimate[index] == true ? smallWidth.w : width.w,
                  height: isAnimate[index] == true ? smallWidth.w : width.w,
                  child: _selectedIndex == index
                      ? Image.asset(clickedImage)
                      : Image.asset(image)),
            ),
            Visibility(
              child: Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(0.2),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black54, blurRadius: 1)
                      ]),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child:
                      Consumer<OrderProvider>(builder: (context, data, child) {
                    return Text(
                      '${data.cartCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ),
              visible: index == 3 && count != 0,
            )
          ],
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: _selectedIndex == index
                      ? FontWeight.w600
                      : FontWeight.normal,
                  fontSize: responsiveFont(8),
                  fontFamily: 'Poppins',
                  color: _selectedIndex == index ? primaryColor : Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

// class CustomMessages extends UpgraderMessages {
//   /// Override the message function to provide custom language localization.
//   @override
//   String? message(UpgraderMessage messageKey) {
//     switch (messageKey) {
//       case UpgraderMessage.body:
//         return 'App Name : {{appName}}\nYour Version : {{currentInstalledVersion}}\nAvailable : {{currentAppStoreVersion}}';
//       case UpgraderMessage.buttonTitleIgnore:
//         return 'Ignore';
//       case UpgraderMessage.buttonTitleLater:
//         return 'Later';
//       case UpgraderMessage.buttonTitleUpdate:
//         return 'Update Now';
//       case UpgraderMessage.prompt:
//         return 'Would you like to update it now?';
//       case UpgraderMessage.title:
//         return 'New Version Available';
//       case UpgraderMessage.releaseNotes:
//         break;
//     }
//     return null;
//     // Messages that are not provided above can still use the default values.
//   }
// }
