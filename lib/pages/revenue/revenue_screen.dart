import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import 'shop_items_page.dart';

class RevenueScreen extends StatefulWidget {
  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  String? orderNumber;
  String? totalRevenue;
  List<List<double>>? revenues;
  @override
  void initState() {
    super.initState();
  }

  final List<List<double>> charts = [
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ]
  ];

  static final List<String> chartDropdownItems = [
    '7 ngày trước',
    'Tháng trước',
    'Nắm trước'
  ];
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
            Container(
              margin: EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('beclothed.com',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0)),
                  Icon(Icons.arrow_drop_down, color: Colors.black54)
                ],
              ),
            )
          ],
        ),
        body: StaggeredGrid.count(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Tổng thu nhập',
                                    style: TextStyle(color: Colors.blueAccent)),
                                Text('265.000 Vnd',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                          ),
                          Material(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline,
                                    color: Colors.white, size: 30.0),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Biểu đồ doanh thu',
                                    style: TextStyle(color: Colors.green)),
                                Text('\$16K',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0)),
                              ],
                            ),
                            DropdownButton(
                                isDense: true,
                                value: actualDropdown,
                                onChanged: (value) => setState(() {
                                      actualDropdown = value.toString();
                                      actualChart = chartDropdownItems.indexOf(
                                          value
                                              .toString()); // Refresh the chart
                                    }),
                                items: chartDropdownItems.map((String title) {
                                  return DropdownMenuItem(
                                    value: title,
                                    child: Text(title,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0)),
                                  );
                                }).toList())
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 4.0)),
                        Sparkline(
                          data: charts[actualChart],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Số lượng đơn',
                                style: TextStyle(color: Colors.redAccent)),
                            Text('173',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 34.0))
                          ],
                        ),
                        Material(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(24.0),
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
