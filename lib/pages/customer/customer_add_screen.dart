import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoba/models/customer.dart';
import 'package:nyoba/provider/customer_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/utility.dart';

class CustomerAddScreen extends StatefulWidget {
  final Customer? userModel;
  CustomerAddScreen({Key? key, this.userModel}) : super(key: key);

  @override
  _CustomerAddScreenState createState() => _CustomerAddScreenState();
}

class _CustomerAddScreenState extends State<CustomerAddScreen> {
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
  TextEditingController controllerCustomerName = new TextEditingController();

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
      Customer customer = new Customer(
          id: 1,
          customerName: controllerCustomerName.text,
          userInfo: UserInfo(
              id: 1,
              email: controllerEmail.text,
              avatarLink: null,
              userName: controllerUsername.text,
              role: "Customer",
              phoneNumber: controllerPhone.text,
              createAt: null,
              updateAt: null,
              deleteAt: null,
              status: "Active"),
          userInfoId: 1,
          cartId: 0);
      bool check = await user.addCustomer(context, customer);
      if (check) {
        setState(() {
          controllerCustomerName.text = "";
          controllerEmail.text = "";
          controllerPhone.text = "";
          controllerUsername.text = "";
        });
      }
      user.loading = false;

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
            "Tạo mới khách hàng",
            style:
                TextStyle(fontSize: responsiveFont(16), color: secondaryColor),
          ),
        ),
        body: Container(
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
                    icon: "call"),
                Container(
                  height: 15,
                ),
                form("Nhập username khách hành", "Username khách hành", true,
                    controllerUsername,
                    icon: "akun", enable: true),
                Container(
                  height: 15,
                ),
                form("Nhập email khách hàng", "Email", true, controllerEmail,
                    icon: "email", enable: true),
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
                            user.loading ? Colors.grey : secondaryColor),
                    onPressed: user.loading ? null : save,
                    child: user.loading
                        ? customLoading()
                        : Text(
                            "Thêm",
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
      height: MediaQuery.of(context).size.height / 12,
      child: TextField(
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
}
