import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/models/seller_model.dart';
import 'package:nyoba/pages/account/account_edit_screen.dart';
import 'package:nyoba/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../app_localizations.dart';
import '../../utils/utility.dart';

class AccountDetailScreen extends StatefulWidget {
  AccountDetailScreen({Key? key}) : super(key: key);

  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  UserProvider? userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    loadDetail();
  }

  loadDetail() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBody = Container(
      child: ListenableProvider.value(
        value: userProvider,
        child: Consumer<UserProvider>(builder: (context, value, child) {
          if (value.loading) {
            return buildDetailLoading();
          }
          return buildDetail(value.user);
        }),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.translate('account')!,
          style: TextStyle(
              fontSize: responsiveFont(16),
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: buildBody,
      ),
    );
  }

  buildDetail(Seller user) {
    return Column(
      children: [
        // buildTable(
        //     AppLocalizations.of(context)!.translate('first_name')!,
        //     user.firstname!.isEmpty
        //         ? AppLocalizations.of(context)!.translate('not_set')
        //         : user.firstname),
        // buildTable(
        //     AppLocalizations.of(context)!.translate('last_name')!,
        //     user.lastname!.isEmpty
        //         ? AppLocalizations.of(context)!.translate('not_set')
        //         : user.lastname),
        buildTable(AppLocalizations.of(context)!.translate('username')!,
            user.sellerName),
        buildTable("Email", user.userInfo!.email),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: HexColor("960000")),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountEditScreen(
                            userModel: user,
                          ))).then((value) {
                loadDetail();
              });
            },
            child: Text(
              AppLocalizations.of(context)!.translate('edit_account')!,
              style: TextStyle(
                color: Colors.white,
                fontSize: responsiveFont(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildDetailLoading() {
    return Column(
      children: [
        buildTableShimmer(
            AppLocalizations.of(context)!.translate('first_name')!),
        buildTableShimmer(
            AppLocalizations.of(context)!.translate('last_name')!),
        buildTableShimmer(AppLocalizations.of(context)!.translate('username')!),
        buildTableShimmer("Email"),
      ],
    );
  }

  Widget buildTable(String type, String? data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  type,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: responsiveFont(10)),
                ),
                Text(": $data",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: responsiveFont(10),
                        fontStyle: data ==
                                AppLocalizations.of(context)!
                                    .translate('not_set')
                            ? FontStyle.italic
                            : null)),
              ]),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 3,
          color: HexColor("CCCCCC"),
        ),
      ]),
    );
  }

  Widget buildTableShimmer(String type) {
    return Shimmer.fromColors(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Table(
                children: [
                  TableRow(children: [
                    Text(
                      type,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                    ),
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ]),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 3,
              color: HexColor("CCCCCC"),
            ),
          ]),
        ),
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!);
  }
}
