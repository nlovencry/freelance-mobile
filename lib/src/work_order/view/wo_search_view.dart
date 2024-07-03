import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/component/custom_textField.dart';
import '../../../common/helper/constant.dart';
import '../../../common/base/base_state.dart';
import '../provider/work_order_provider.dart';

class WOSearchView extends StatefulWidget {
  const WOSearchView({super.key});
  @override
  State<WOSearchView> createState() => _WOSearchViewState();
}

class _WOSearchViewState extends BaseState<WOSearchView> {
  @override
  void initState() {
    context.read<WorkOrderProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchP = context.watch<WorkOrderProvider>();
    Widget resultSearch() {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.search, color: Colors.black45),
                SizedBox(width: 5),
                Expanded(
                    flex: 6,
                    child: Text(
                      "Impact Drill",
                      style: TextStyle(color: Colors.grey),
                    )),
                Icon(Icons.close, size: 20),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.black45,
                ),
                SizedBox(width: 5),
                Expanded(
                    flex: 6,
                    child: Text(
                      "Grinder",
                      style: TextStyle(color: Colors.grey),
                    )),
                Icon(Icons.close),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.black45,
                ),
                SizedBox(width: 5),
                Expanded(
                    flex: 6,
                    child: Text(
                      "Palu",
                      style: TextStyle(color: Colors.grey),
                    )),
                Icon(Icons.close),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.black45,
                ),
                SizedBox(width: 5),
                Expanded(
                    flex: 6,
                    child: Text(
                      "Baut",
                      style: TextStyle(color: Colors.grey),
                    )),
                Icon(Icons.close),
              ],
            ),
            SizedBox(height: 40),
            // Text(
            //   "Terakhir Dilihat",
            //   style: TextStyle(
            //       color: Constant.primaryColor,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 18),
            // ),
            // SizedBox(height: 10),
            // Row(
            //   children: [
            //     Container(
            //       width: 80,
            //       height: 80,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           image: DecorationImage(
            //               image: AssetImage(
            //                   'assets/images/shopping_cart/bor.jpg'))),
            //     ),
            //     SizedBox(width: 10),
            //     Container(
            //       width: 80,
            //       height: 80,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           image: DecorationImage(
            //               image: AssetImage(
            //                   'assets/images/shopping_cart/gerinda.jpg'))),
            //     ),
            //     SizedBox(width: 10),
            //     Container(
            //       width: 80,
            //       height: 80,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           image: DecorationImage(
            //               image: AssetImage(
            //                   'assets/images/shopping_cart/bor.jpg'))),
            //     ),
            //   ],
            // ),
            // ListView.separated(
            //   physics: NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: searchP.getSearchProductModel.data?.length ?? 0,
            //   separatorBuilder: (context, index) {
            //     return SizedBox(
            //       height: 0,
            //     );
            //   },
            //   itemBuilder: (context, index) {
            //     final data = (searchP.getSearchProductModel.data ?? [])[index];
            //     return Container(
            //       margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            //       padding: EdgeInsets.all(10),
            //       child: Row(
            //         children: [
            //           SafeNetworkImage(
            //               width: 50, height: 50, url: data?.image ?? ""),
            //           SizedBox(width: 5),
            //           Expanded(
            //               child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 data?.name ?? "",
            //                 style: Constant.dark16,
            //               ),
            //               Text(
            //                 (data?.price ?? 0).toString(),
            //                 style: Constant.dark14,
            //               ),
            //               Text(
            //                 (data?.priceDiscount ?? 0).toString(),
            //                 style: Constant.dark14,
            //               ),
            //             ],
            //           ))
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      );
    }

    Widget suffixIconSearch(String text) {
      if (text == "") {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/icons/ic-search.png',
            width: 5,
            height: 5,
          ),
        );
      }
      return InkWell(
        onTap: () => searchP.searchC.clear(),
        child: Padding(
            padding: const EdgeInsets.all(12), child: Icon(Icons.clear)),
      );
    }

    return Scaffold(
      appBar: CustomAppBar.searchAppBar(
          context,
          CustomTextField.borderTextField(
            controller: searchP.searchC,
            hintText: "Search Products...",
            hintColor: Constant.textHintColor2,
            suffixIcon: suffixIconSearch(searchP.searchC.text),
            // readOnly: true,
            padding: EdgeInsets.zero,
            validator: null,
            required: false,
            onChange: (value) async {
              setState(() {});
              // if (value.length >= 3) {
              // await Future.delayed(Duration(
              //     milliseconds: 2000)); // Add a delay of 500 milliseconds
              // await searchP.fetchSearchProduct(withLoading: true);
              // }
            },
          ),
          action: [SizedBox(width: 24)]),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(80),
      //   child: Container(
      //     margin: EdgeInsets.only(top: 15),
      //     child: AppBar(
      //       backgroundColor: Colors.white,
      //       foregroundColor: Constant.primaryColor,
      //       titleSpacing: 0,
      //       title: CustomTextField.borderTextField(
      //         controller: searchP.searchC,
      //         hintText: "Search Products...",
      //         prefixIcon: Icon(Icons.search),
      //         padding: EdgeInsets.zero,
      //         onChange: (value) async {
      //           if (value.length >= 3) {
      //             await Future.delayed(Duration(
      //                 milliseconds: 2000)); // Add a delay of 500 milliseconds
      //             await searchP.fetchSearchProduct(withLoading: true);
      //           }
      //         },
      //       ),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(child: Column(children: [resultSearch()])),
    );
  }
}
