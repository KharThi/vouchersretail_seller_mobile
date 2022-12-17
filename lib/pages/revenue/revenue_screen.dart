import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nyoba/models/revenue.dart';
import 'package:nyoba/provider/revenue_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/seller_model.dart';
import '../../provider/order_provider.dart';
import '../../provider/user_provider.dart';
import '../../services/session.dart';
import '../../utils/utility.dart';

// import 'shop_items_page.dart';

class RevenueScreen extends StatefulWidget {
  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  int orderNumber = 0;
  double totalRevenue = 0.0;
  List<List<double>>? revenues;
  String year = "";
  bool isLoading = true;
  Rank? rank;
  Seller? seller;
  int? exp;

  @override
  void initState() {
    super.initState();
    year = chartDropdownItems[0];
    loadDetail();
    loadRevenues();
  }

  loadDetail() async {
    await Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetail2()
        .then((value) => this.setState(() {
              seller = value;
            }));
  }

  loadRevenues() async {
    await Provider.of<RevenueProvider>(context, listen: false)
        .getListRevenue(year)
        .then((value) {
      setState(() {
        charts.clear();
        totalRevenue = 0.0;
        orderNumber = 0;
        List<Revenue> list = value;
        for (var element in list) {
          charts.add(double.parse(element.revenues.toString()));
          totalRevenue = totalRevenue + element.revenues!;
          orderNumber = orderNumber + element.order!;
        }
        isLoading = false;
      });
    });
  }

  final List<double> charts = List.empty(growable: true);

  static final List<String> chartDropdownItems = ['2022', '2023', '2024'];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Doanh thu',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0)),
          actions: <Widget>[
            // Container(
            //   margin: EdgeInsets.only(right: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       Text('beclothed.com',
            //           style: TextStyle(
            //               color: Colors.blue,
            //               fontWeight: FontWeight.w700,
            //               fontSize: 14.0)),
            //       Icon(Icons.arrow_drop_down, color: Colors.black54)
            //     ],
            //   ),
            // )
          ],
        ),
        body: !Session.data.getBool('isLogin')!
            ? Center(
                child: buildNoAuth(context),
              )
            : isLoading
                ? customLoading()
                : SingleChildScrollView(
                    child: StaggeredGrid.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      children: <Widget>[
                        StaggeredGridTile.count(
                          crossAxisCellCount: 4,
                          mainAxisCellCount: 1.5,
                          child: _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 13,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'Rank hiện tại: ' +
                                                    seller!.rank!.rank
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: LinearPercentIndicator(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      175,
                                                  animation: true,
                                                  lineHeight: 20.0,
                                                  animationDuration: 2500,
                                                  percent: seller!.exp! /
                                                      seller!.nextRank!
                                                          .epxRequired!,
                                                  center: Text(
                                                      seller!.exp.toString() +
                                                          "/" +
                                                          seller!.nextRank!
                                                              .epxRequired
                                                              .toString() +
                                                          " exp"),
                                                  linearStrokeCap:
                                                      LinearStrokeCap.roundAll,
                                                  progressColor: Colors.green,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      CachedNetworkImage(
                                          imageUrl:
                                              seller!.rank!.logo.toString())
                                      // Material(
                                      //     color: Colors.blue,
                                      //     borderRadius:
                                      //         BorderRadius.circular(24.0),
                                      //     child: Center(
                                      //         child: Padding(
                                      //       padding: const EdgeInsets.all(16.0),
                                      //       child: ,
                                      //     )))
                                    ]),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 4,
                          mainAxisCellCount: 1.75,
                          child: _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 13,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Tổng thu nhập',
                                                style: TextStyle(
                                                    color: Colors.blueAccent)),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                  totalRevenue.toString() +
                                                      " Vnd",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 34.0)),
                                            )
                                          ],
                                        ),
                                      ),
                                      Material(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Icon(Icons.timeline,
                                                color: Colors.white,
                                                size: 30.0),
                                          )))
                                    ]),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                        // StaggeredGridTile.count(
                        //   crossAxisCellCount: 2,
                        //   mainAxisCellCount: 2,
                        //   child: _buildTile(
                        //     Padding(
                        //       padding: const EdgeInsets.all(24.0),
                        //       child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: <Widget>[
                        //             Material(
                        //                 color: Colors.teal,
                        //                 shape: CircleBorder(),
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.all(16.0),
                        //                   child: Icon(Icons.settings_applications,
                        //                       color: Colors.white, size: 30.0),
                        //                 )),
                        //             Padding(padding: EdgeInsets.only(bottom: 16.0)),
                        //             Text('General',
                        //                 style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontWeight: FontWeight.w700,
                        //                     fontSize: 24.0)),
                        //             Text('Images, Videos',
                        //                 style: TextStyle(color: Colors.black45)),
                        //           ]),
                        //     ),
                        //     onTap: () {},
                        //   ),
                        // ),
                        // StaggeredGridTile.count(
                        //   crossAxisCellCount: 2,
                        //   mainAxisCellCount: 2,
                        //   child: _buildTile(
                        //     Padding(
                        //       padding: const EdgeInsets.all(24.0),
                        //       child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: <Widget>[
                        //             Material(
                        //                 color: Colors.amber,
                        //                 shape: CircleBorder(),
                        //                 child: Padding(
                        //                   padding: EdgeInsets.all(16.0),
                        //                   child: Icon(Icons.notifications,
                        //                       color: Colors.white, size: 30.0),
                        //                 )),
                        //             Padding(padding: EdgeInsets.only(bottom: 16.0)),
                        //             Text('Alerts',
                        //                 style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontWeight: FontWeight.w700,
                        //                     fontSize: 24.0)),
                        //             Text('All ', style: TextStyle(color: Colors.black45)),
                        //           ]),
                        //     ),
                        //     onTap: () {},
                        //   ),
                        // ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 4,
                          mainAxisCellCount: 2.5,
                          child: _buildTile(
                            Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Biểu đồ doanh thu',
                                                style: TextStyle(
                                                    color: Colors.green)),
                                            // Text('\$16K',
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontWeight: FontWeight.w700,
                                            //         fontSize: 34.0)),
                                          ],
                                        ),
                                        DropdownButton(
                                            isDense: true,
                                            value: actualDropdown,
                                            onChanged: (value) => setState(() {
                                                  actualDropdown =
                                                      value.toString();
                                                  actualChart =
                                                      chartDropdownItems
                                                          .indexOf(
                                                              value.toString());
                                                  year = actualDropdown;
                                                  isLoading = true;
                                                  loadRevenues(); // Refresh the chart
                                                }),
                                            items: chartDropdownItems
                                                .map((String title) {
                                              return DropdownMenuItem(
                                                value: title,
                                                child: Text(title,
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                              );
                                            }).toList())
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 4.0)),
                                    Sparkline(
                                      data: charts,
                                      lineWidth: 5.0,
                                      lineColor: Colors.greenAccent,
                                    )
                                  ],
                                )),
                            onTap: () {},
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 4,
                          mainAxisCellCount: 1.5,
                          child: _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Số lượng đơn',
                                            style: TextStyle(
                                                color: Colors.redAccent)),
                                        Text(orderNumber.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 34.0))
                                      ],
                                    ),
                                    Material(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Center(
                                            child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(Icons.store,
                                              color: Colors.white, size: 30.0),
                                        )))
                                  ]),
                            ),
                            onTap: () => null
                            // => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopItemsPage()))
                            ,
                          ),
                        )
                      ],
                      // staggeredTiles: [
                      //   StaggeredTile.extent(2, 110.0),
                      //   StaggeredTile.extent(1, 180.0),
                      //   StaggeredTile.extent(1, 180.0),
                      //   StaggeredTile.extent(2, 220.0),
                      //   StaggeredTile.extent(2, 110.0),
                      // ],
                    ),
                  ));
  }

  Widget _buildTile(Widget child, {required Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            // ignore: unnecessary_null_comparison
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}
