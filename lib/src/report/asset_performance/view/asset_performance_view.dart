import 'dart:async';

import 'package:mata/common/base/base_state.dart';
import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_navigator.dart';
import 'package:mata/common/component/custom_textField.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/report/asset_performance/model/asset_performance_model.dart';
import 'package:mata/src/report/asset_performance/provider/asset_performance_provider.dart';
import 'package:mata/src/report/asset_performance/view/view_asset_performance_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../utils/utils.dart';

class AssetPerformanceView extends StatefulWidget {
  const AssetPerformanceView({super.key});

  @override
  State<AssetPerformanceView> createState() => _AssetPerformanceViewState();
}

class _AssetPerformanceViewState extends BaseState<AssetPerformanceView> {
  @override
  void initState() {
    final woTP = context.read<AssetPerformanceProvider>();
    woTP.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => woTP.fetchAssetPerformance(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apP = context.watch<AssetPerformanceProvider>();
    final pagingC = context.watch<AssetPerformanceProvider>().pagingController;

    Widget search() => CustomTextField.borderTextField(
          controller: apP.assetPerformanceSearchC,
          required: false,
          hintText: "Search",
          hintColor: Constant.textHintColor,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child:
                Image.asset('assets/icons/ic-search.png', width: 5, height: 5),
          ),
          padding: EdgeInsets.zero,
          validator: null,
          onChange: (value) async {
            if (apP.searchOnStoppedTyping != null) {
              apP.searchOnStoppedTyping!.cancel();
            }
            apP.searchOnStoppedTyping = Timer(apP.duration, () {
              pagingC.refresh();
            });
          },
        );

    return Scaffold(
      appBar: CustomAppBar.appBar(context, "Asset Performance"),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              search(),
              Constant.xSizedBox16,
              Text("Asset Performance List",
                  style: Constant.grayMedium.copyWith(
                      color: Colors.black38, fontWeight: FontWeight.w500)),
              Constant.xSizedBox16,
              Flexible(
                child: PagedListView.separated(
                  shrinkWrap: true,
                  pagingController: pagingC,
                  padding: EdgeInsets.fromLTRB(0, 18, 0, 20),
                  separatorBuilder: (_, __) => Constant.xSizedBox16,
                  builderDelegate:
                      PagedChildBuilderDelegate<AssetPerformanceModelData>(
                    firstPageProgressIndicatorBuilder: (_) => Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 32),
                      child: CustomLoadingIndicator.buildIndicator(),
                    ),
                    newPageProgressIndicatorBuilder: (_) => Container(
                      color: Colors.white,
                      child: CustomLoadingIndicator.buildIndicator(),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => Padding(
                      padding: const EdgeInsets.only(top: 56),
                      child: Utils.notFoundImage(),
                    ),
                    itemBuilder: (context, item, index) {
                      return InkWell(
                        onTap: () {
                          CusNav.nPush(
                            context,
                            ViewAssetPerformanceView(id: item.id ?? "0"),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 0.7,
                                          // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/icons/ic-asset-performance.png',
                                      scale: 3,
                                    ),
                                  ),
                                  SizedBox(width: 13),
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.docNo ?? "",
                                            style: Constant.blackBold),
                                        SizedBox(height: 5),
                                        Text(item.dateDoc ?? "",
                                            style: Constant.grayRegular),
                                        SizedBox(height: 5),
                                        Text(item.cabangCode ?? "",
                                            style: Constant.grayRegular),
                                        SizedBox(height: 5),
                                        Text(item.site ?? "",
                                            style: Constant.grayRegular),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 13),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(item.docStatus ?? "",
                                            style: Constant.iPrimaryMedium8
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        SizedBox(height: 30),
                                        Text(item.dateDoc ?? "",
                                            style: Constant.grayRegular),
                                        SizedBox(height: 5),
                                        Text(item.docStatus ?? "",
                                            style: Constant.grayRegular),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 100,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "Log",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 100,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "Approver",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
