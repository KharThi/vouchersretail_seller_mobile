import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/pages/auth/sign_in_otp_screen.dart';
import 'package:nyoba/pages/home/home_screen.dart';
import 'package:nyoba/provider/login_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:provider/provider.dart';
import 'forgot_password_screen.dart';
import '../../utils/utility.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Login extends StatefulWidget {
  final bool? isFromNavBar;
  Login({Key? key, this.isFromNavBar}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisible = false;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool? isFromNavBar = true;

  @override
  void initState() {
    super.initState();
    if (widget.isFromNavBar != null) {
      isFromNavBar = widget.isFromNavBar;
    }
  }

  loginGoogle() async {
    loadingPop(context);
    await Provider.of<LoginProvider>(context, listen: false)
        .signInWithGoogle(context)
        .then((value) {
      if (Session.data.getString('cookie') != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      } else {
        snackBar(context,
            message:
                "Invalid error when trying sign in using google, please contact admin or developer",
            color: Colors.red);
        Navigator.pop(context);
      }
    });
  }

  loginFacebook() async {
    loadingPop(context);
    await Provider.of<LoginProvider>(context, listen: false)
        .signInWithFacebook(context)
        .then((value) {
      if (Session.data.getString('cookie') != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      } else {
        snackBar(context,
            message:
                "Invalid error when trying sign in using facebook, please contact admin or developer",
            color: Colors.red);
        Navigator.pop(context);
      }
    });
  }

  loginApple() async {
    loadingPop(context);
    await Provider.of<LoginProvider>(context, listen: false)
        .signInWithApple(context)
        .then((value) {
      if (Session.data.getString('cookie') != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      } else {
        snackBar(context,
            message:
                "Invalid error when trying sign in using apple, please contact admin or developer",
            color: Colors.red);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<LoginProvider>(context, listen: false);

    var loginByDefault = () async {
      if (username.text.isNotEmpty && password.text.isNotEmpty) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        await Provider.of<LoginProvider>(context, listen: false)
            .login(context, password: password.text, username: username.text)
            .then((value) => this.setState(() {}));
      } else {
        snackBar(context,
            message: 'Tài khoản và mật khẩu không được để trống!');
      }
    };

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: !isFromNavBar!
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ))
              : null,
          title: AutoSizeText(
            "Đăng nhập",
            style: TextStyle(
                fontSize: responsiveFont(16), color: HexColor("960000")),
          ),
          backgroundColor: Colors.white),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xin chào!",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: responsiveFont(14),
                ),
              ),
              Text(
                "Vùi lòng nhập mật khẩu và tài khoản để đăng nhập!",
                style: TextStyle(
                  fontSize: responsiveFont(9),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 12,
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                      prefixIcon: Container(
                          width: 24.w,
                          height: 24.h,
                          padding: EdgeInsets.only(right: 5),
                          child: Image.asset("images/account/akun.png")),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: responsiveFont(10),
                      ),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: responsiveFont(12),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Tên tài khoản",
                      hintText: "Nhập tên tài khoản của bạn"),
                ),
              ),
              Container(
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 12,
                child: TextField(
                  controller: password,
                  obscureText: isVisible ? false : true,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Image.asset(isVisible
                                ? "images/account/melek.png"
                                : "images/account/merem.png")),
                      ),
                      prefixIcon: Container(
                          width: 24.w,
                          height: 24.h,
                          padding: EdgeInsets.only(right: 5),
                          child: Image.asset("images/account/lock.png")),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: responsiveFont(10),
                      ),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: responsiveFont(12),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Mật khẩu",
                      hintText: "Nhập mật khẩu của bạn"),
                ),
              ),
              Container(
                height: 10,
              ),
              // InkWell(
              //   onTap: () => Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => ForgotPasswordScreen()))
              //       .then((value) => this.setState(() {})),
              //   child: Container(
              //     alignment: Alignment.centerRight,
              //     width: double.infinity,
              //     child: Text(
              //       "Quên mật khẩu?",
              //       style: TextStyle(
              //         color: HexColor("FD490C"),
              //         fontSize: responsiveFont(10),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                height: 15,
              ),
              Container(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor:
                          auth.loading ? Colors.grey : HexColor("960000")),
                  onPressed: loginByDefault,
                  child: auth.loading
                      ? customLoading()
                      : Text(
                          "Đăng nhập",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsiveFont(10),
                          ),
                        ),
                ),
              ),
              Container(
                height: 15,
              ),
              Image.asset("images/account/baris.png"),
              Container(
                height: 15,
              ),
              // Center(
              //   child: RichText(
              //     text: TextSpan(
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: responsiveFont(10),
              //       ),
              //       children: <TextSpan>[
              //         TextSpan(
              //           text:
              //               "${AppLocalizations.of(context)!.translate("don't_have_account")} ",
              //         ),
              //         TextSpan(
              //             recognizer: new TapGestureRecognizer()
              //               ..onTap = () => Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => SignUp())),
              //             text: AppLocalizations.of(context)!
              //                 .translate('sign_up'),
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 color: HexColor("960000"))),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   height: 15,
              // ),
              // signInButton(
              //     "${AppLocalizations.of(context)!.translate('sign_in_otp')}",
              //     "message"),
              // Container(
              //   height: 10,
              // ),
              // signInButton(
              //     "${AppLocalizations.of(context).translate('sign_in')} Google",
              //     "google"),
              // Container(
              //   height: 10,
              // ),
              // signInButton(
              //     "${AppLocalizations.of(context).translate('sign_in')} Facebook",
              //     "facebook"),
              // Container(
              //   height: 10,
              // ),
              // if (Platform.isIOS)
              //   signInButton(
              //       "${AppLocalizations.of(context)!.translate('sign_in')} Apple",
              //       "apple"),
            ],
          ),
        ),
      ),
    );
  }

  Widget signInButton(String title, String image) {
    return InkWell(
      onTap: () {
        if (image == 'message') {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInOTPScreen()))
              .then((value) => this.setState(() {}));
        } else if (image == 'google') {
          loginGoogle();
        } else if (image == 'facebook') {
          loginFacebook();
        } else if (image == 'apple') {
          loginApple();
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: HexColor("c4c4c4"))),
          width: double.infinity,
          child: Row(
            children: [
              Container(
                  width: 17.w,
                  height: 17.h,
                  child: Image.asset("images/account/$image.png")),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: responsiveFont(10), color: HexColor("464646")),
              )
            ],
          )),
    );
  }
}
