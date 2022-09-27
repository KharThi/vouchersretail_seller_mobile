import 'package:flutter/material.dart';
import 'package:nyoba/pages/search/qr_scanner_screen.dart';
import 'package:nyoba/provider/home_provider.dart';
import 'package:nyoba/provider/search_provider.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/customer/list_item_customer.dart';
import 'package:nyoba/widgets/product/list_item_product.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../widgets/product/list_item_product2.dart';

class SearchScreenCustomer extends StatefulWidget {
  SearchScreenCustomer({Key? key}) : super(key: key);

  @override
  _SearchScreenCustomerState createState() => _SearchScreenCustomerState();
}

class _SearchScreenCustomerState extends State<SearchScreenCustomer> {
  TextEditingController searchController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  int page = 1;

  Future search() async {
    await Provider.of<SearchProvider>(context, listen: false)
        .searchCustomer(searchController.text, page)
        .then((value) => this.setState(() {}));
  }

  @override
  void initState() {
    final customerSearch =
        Provider.of<SearchProvider>(context, listen: false).listSearchCustomer;
    super.initState();
    customerSearch.clear();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (customerSearch.length % 10 == 0) {
          setState(() {
            page++;
          });
          search();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final settingProvider = Provider.of<HomeProvider>(context, listen: false);

    Widget buildCustomer = Container(
      child: ListenableProvider.value(
        value: searchProvider,
        child: Consumer<SearchProvider>(builder: (context, value, child) {
          if (value.loadingSearch && page == 1) {
            return Center(
              child: customLoading(),
            );
          }
          if (value.listSearchCustomer.isEmpty) {
            return buildSearchEmpty(
              context,
              searchController.text.isEmpty
                  ? "Tìm kiếm khách hàng ở đây"
                  : "Không tìm thấy khách hàng nào",
            );
          }
          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: ScrollPhysics(),
                itemCount: value.listSearchCustomer.length,
                itemBuilder: (context, i) {
                  return ListItemCustomer(
                    itemCount: value.listSearchCustomer.length,
                    customer: value.listSearchCustomer[i],
                    i: i,
                  );
                }),
          );
        }),
      ),
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: settingProvider.isBarcodeActive!,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QRScanner()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50), color: primaryColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    // decoration: BoxDecoration(
                    //     shape: BoxShape.circle, color: Colors.white),
                    child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreenCustomer()))
                        .then((result) => setState(() {
                              // customers = [];
                              // getListCustomerOrder();
                            }));
                  },
                  icon: Icon(Icons.add),
                  label: Text("Bấm vào đây để tạo mới khách hàng"),
                )),
                SizedBox(
                  width: 5,
                ),
                // Text(
                //   "SCAN BARCODE",
                //   style: TextStyle(
                //       color: Colors.white, fontWeight: FontWeight.bold),
                // )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            child: Container(
                height: 70,
                padding: EdgeInsets.only(right: 10, top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          Future.delayed(Duration(milliseconds: 600), () {
                            this.setState(() {
                              page = 1;
                            });
                            search();
                          });
                        },
                        style: TextStyle(fontSize: 14),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          filled: true,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(5),
                            ),
                          ),
                          prefixIcon: Icon(Icons.search),
                          hintText: "Tìm kiếm khách hàng",
                          hintStyle: TextStyle(fontSize: responsiveFont(10)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: searchController.text.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            page = 1;
                            searchProvider.listSearchCustomer.clear();
                          });
                          search();
                        },
                        icon: Icon(Icons.cancel),
                        color: primaryColor,
                      ),
                    )
                  ],
                ))),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildCustomer,
          ),
          if (searchProvider.loadingSearch && page != 1) customLoading()
        ],
      ),
    );
  }
}
