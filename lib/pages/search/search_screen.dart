import 'package:flutter/material.dart';
import 'package:nyoba/models/product_model.dart';
import 'package:nyoba/pages/search/qr_scanner_screen.dart';
import 'package:nyoba/provider/home_provider.dart';
import 'package:nyoba/provider/search_provider.dart';
import 'package:nyoba/provider/voucher_provider.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:provider/provider.dart';

import '../../widgets/product/list_item_product2.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  int page = 1;
  List<Voucher> searchList = List.empty(growable: true);
  bool isLoading = true;

  Future search() async {
    await Provider.of<VoucherProvider>(context, listen: false)
        .fetchVouchers(searchController.text, "", "")
        .then((value) => this.setState(() {
              searchList = value!;
              isLoading = false;
            }));
  }

  @override
  void initState() {
    // final productSearch =
    //     Provider.of<SearchProvider>(context, listen: false).listSearchProducts2;
    super.initState();
    // productSearch.clear();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (searchList.length % 10 == 0) {
          setState(() {
            isLoading = true;
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

    Widget buildProduct = Container(
      child: ListenableProvider.value(
        value: searchProvider,
        child: Consumer<SearchProvider>(builder: (context, value, child) {
          if (isLoading && page == 1) {
            return Center(
              child: customLoading(),
            );
          }
          if (searchList.isEmpty) {
            return buildSearchEmpty(
              context,
              searchController.text.isEmpty
                  ? "Tìm kiếm ở đây"
                  : "Không tiềm thấy sản phẩm",
            );
          }
          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: ScrollPhysics(),
                itemCount: searchList.length,
                itemBuilder: (context, i) {
                  // int? price = searchList[i]
                  //     .prices!
                  //     .firstWhere((currency) => currency.isDefault == false)
                  //     .price;
                  return ListItemProduct2(
                    itemCount: searchList.length,
                    product: searchList[i],
                    i: i,
                    price: "",
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
                // Container(
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle, color: Colors.white),
                //     child: Container(
                //         height: 30,
                //         padding: EdgeInsets.all(5),
                //         child: Image.asset("images/search/barcode_icon.png"))),
                // SizedBox(
                //   width: 5,
                // ),
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
                              isLoading = true;
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
                          hintText: "Tìm kiếm",
                          hintStyle: TextStyle(fontSize: responsiveFont(10)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: searchController.text.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            searchController.clear();
                            page = 1;
                            searchProvider.listSearchProducts.clear();
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
            child: buildProduct,
          ),
          if (searchProvider.loadingSearch && page != 1) customLoading()
        ],
      ),
    );
  }
}
