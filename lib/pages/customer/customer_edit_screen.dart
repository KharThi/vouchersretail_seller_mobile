import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:nyoba/models/customer.dart';
import 'package:nyoba/provider/customer_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/utility.dart';

class CustomerEditScreen extends StatefulWidget {
  final Customer? userModel;
  CustomerEditScreen({Key? key, this.userModel}) : super(key: key);

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  bool isVisible = false;
  bool checkedValue = false;

  TextEditingController controllerFirstname = new TextEditingController();
  TextEditingController controllerLastname = new TextEditingController();
  TextEditingController controllerUsername = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerPasswordConfirm = new TextEditingController();
  TextEditingController controllerOldPassword = new TextEditingController();

  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerDateOfBirth = new TextEditingController();
  TextEditingController controllerIdentity = new TextEditingController();
  TextEditingController controllerCustomerName = new TextEditingController();

  List gender = ["Nam", "Nữ"];

  String? select;
  int? genderInt;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // CustomerProvider.loading = false;
    // controllerEmail.text = widget.userModel!.userInfo!.email!;
    // controllerUsername.text = widget.userModel!.userInfo!.userName!;
    // controllerPhone.text = widget.userModel!.userInfo!.phoneNumber!;
    // controllerCustomerName.text = widget.userModel!.customerName!;
    // controllerFirstname.text = widget.userModel!.firstname!;
    // controllerLastname.text = widget.userModel!.lastname!;
    // controllerCustomerName.text = widget.userModel!.profiles!.first.name != null
    //     ? widget.userModel!.profiles!.first.name!
    //     : "";
    // // controllerEmail.text = "";
    // controllerPhone.text = widget.userModel!.profiles!.first.phoneNumber != null
    //     ? widget.userModel!.profiles!.first.phoneNumber!
    //     : "";
    // ;
    // // controllerUsername.text = "";
    // controllerDateOfBirth.text =
    //     widget.userModel!.profiles!.first.dateOfBirth != null
    //         ? widget.userModel!.profiles!.first.dateOfBirth!
    //         : "";
    // controllerIdentity.text =
    //     widget.userModel!.profiles!.first.civilIdentify != null
    //         ? widget.userModel!.profiles!.first.civilIdentify!
    //         : "";
    // select = widget.userModel!.profiles!.first.sex! == 1 ? "Nam" : "Nữ";
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomerProvider>(context, listen: false);

    var save = () async {
      // FocusScopeNode currentFocus = FocusScope.of(context);

      // if (!currentFocus.hasPrimaryFocus) {
      //   currentFocus.unfocus();
      // }

      // this.setState(() {});
      // if (controllerPassword.text != controllerPasswordConfirm.text) {
      //   snackBar(context,
      //       message: 'Your password and confirmation password does not match.');
      // } else {
      user.loading = true;
      // Profile profile = new Profile(
      //     civilIdentify: controllerIdentity.text,
      //     customerId: widget.userModel!.id,
      //     dateOfBirth: controllerDateOfBirth.text,
      //     name: controllerCustomerName.text,
      //     phoneNumber: controllerPhone.text,
      //     sex: genderInt,
      //     id: widget.userModel!.profiles!.first.id);
      // bool check = await user.updateCustomer(context);
      // if (check) {
      //   setState(() {});
      // }
      // user.loading = false;

      // authResponse.then((value) {
      //   if (value!['is_success'] == true) {
      //     Navigator.pop(context);
      //     snackBar(context,
      //         message:
      //             AppLocalizations.of(context)!.translate('succ_update_acc')!,
      //         color: Colors.green);
      //   } else {
      //     snackBar(context, message: value['message'], color: Colors.red);
      //   }
      //   this.setState(() {});
      // });
      // }
    };

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Cập nhật thông tin khách hàng",
            style: TextStyle(
                fontSize: responsiveFont(16), color: HexColor("960000")),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  form("Nhập tên của khách hàng", "Tên khách hàng", true,
                      controllerCustomerName,
                      icon: "akun"),
                  Container(
                    height: 15,
                  ),
                  form("Nhập số điện thoại", "Số điện thoại", true,
                      controllerPhone,
                      icon: "phone-call"),
                  Container(
                    height: 15,
                  ),

                  form(
                      "Nhập ngày sinh của khách hàng",
                      "Ngày sinh (Ví dụ: 2022-12-01)",
                      true,
                      controllerDateOfBirth,
                      icon: "date-of-birth",
                      enable: true),
                  Container(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(right: 5),
                          width: 50,
                          height: 50,
                          child: Image.asset("images/account/gender.png")),
                      addRadioButton(0, 'Nam'),
                      addRadioButton(1, 'Nữ'),
                    ],
                  ),
                  Container(
                    height: 15,
                  ),
                  form("Nhập số CCCD/CMNN của khách hàng", "CCCD/CMNN", true,
                      controllerIdentity,
                      icon: "id-card", enable: true),
                  Container(
                    height: 15,
                  ),
                  // Visibility(
                  //     visible: Session.data.getString('login_type') == 'default',
                  //     child: Column(
                  //       children: [
                  //         passwordForm("Current Password", "Current Password",
                  //             controllerOldPassword),
                  //         Container(
                  //           height: 15,
                  //         ),
                  //         passwordForm(
                  //             AppLocalizations.of(context)!
                  //                 .translate('new_password'),
                  //             "Password",
                  //             controllerPassword),
                  //         Container(
                  //           height: 15,
                  //         ),
                  //         passwordForm(
                  //             AppLocalizations.of(context)!
                  //                 .translate('repeat_new_password'),
                  //             AppLocalizations.of(context)!
                  //                 .translate('repeat_password'),
                  //             controllerPasswordConfirm),
                  //         Container(
                  //           height: 15,
                  //         ),
                  //       ],
                  //     )),
                  Container(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          backgroundColor:
                              user.loading ? Colors.grey : HexColor("960000")),
                      onPressed: () {
                        // _formKey.currentState!.validate();
                        if (_formKey.currentState!.validate()) {
                          save();
                          print("Non Validate");
                        } else {
                          print("Validating");
                        }
                      },
                      child: user.loading
                          ? customLoading()
                          : Text(
                              "Cập nhật",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsiveFont(10),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget passwordForm(
      String? hints, String? label, TextEditingController controller) {
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      child: TextField(
        controller: controller,
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
                alignment: Alignment.topCenter,
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
            labelText: hints,
            hintText: label),
      ),
    );
  }

  Widget form(String? hints, String? label, bool prefix,
      TextEditingController controller,
      {String icon = "email", bool enable = true}) {
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      child: TextFormField(
        validator: (text) {
          if (label == "Email") {
            final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(text!);
            if (text.isEmpty) {
              return 'Vui lòng nhập ' + label!;
            } else if (!emailValid) {
              return "Email sai định dạng";
            }
            return null;
          } else if (label == "Ngày sinh (Ví dụ: 2022-12-01)") {
            if (text == null || text.isEmpty) {
              return 'Vui lòng nhập ' + label!;
            } else if (!isDate(text, "yyyy-MM-dd")) {
              return "Sai định dạng ngày";
            }
            return null;
          }
          if (text == null || text.isEmpty) {
            return 'Vui lòng nhập ' + label!;
          }
          return null;
        },
        controller: controller,
        enabled: enable,
        decoration: InputDecoration(
            prefixIcon: prefix
                ? Container(
                    padding: EdgeInsets.only(right: 5),
                    width: 24.w,
                    height: 24.h,
                    child: Image.asset("images/account/$icon.png"))
                : null,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: responsiveFont(10),
            ),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: responsiveFont(12),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            hintText: hints),
      ),
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<String>(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value.toString();
              if (select == "Nam") {
                genderInt = 1;
              } else {
                genderInt = 0;
              }
            });
          },
        ),
        Text(title)
      ],
    );
  }

  String? validateName(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  String? validatePhone(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  String? validateUsername(String value) {
    if (!value.isNotEmpty) {
      return "Vui lòng nhập Username của khách hàng";
    }
    return null;
  }

  String? validateEmail(String value) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!(emailValid && value.isNotEmpty)) {
      return "Email sai định dạng";
    }
    return null;
  }

  String? validateBirth(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  String? validateIndentity(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  bool isDate(String input, String format) {
    try {
      //print(d);
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }
}
