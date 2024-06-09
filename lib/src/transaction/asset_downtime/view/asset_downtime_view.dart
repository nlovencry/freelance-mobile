import 'dart:async';

import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_textfield.dart';
import 'package:mata/common/helper/safe_network_image.dart';
import 'package:mata/src/transaction/asset_downtime/view/view_asset_downtime_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/base/base_state.dart';
import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../model/asset_downtime_model.dart';
import '../provider/asset_downtime_provider.dart';

class AssetDowntimeView extends StatefulWidget {
  AssetDowntimeView();

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<AssetDowntimeView> createState() => _AssetDowntimeViewState();
}

class _AssetDowntimeViewState extends BaseState<AssetDowntimeView> {
  @override
  void initState() {
    final aD = context.read<AssetDowntimeProvider>();
    aD.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => aD.fetchAssetDowntime(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final assetDowntimeP = context.watch<AssetDowntimeProvider>();
    final assetDowntimeModel =
        context.watch<AssetDowntimeProvider>().assetDowntimeModel.data;
    final pagingC = context.watch<AssetDowntimeProvider>().pagingController;

    Widget search() => CustomTextField.borderTextField(
          controller: assetDowntimeP.assetSearchC,
          required: false,
          hintText: "Search",
          hintColor: Constant.textHintColor,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/ic-search.png',
              width: 5,
              height: 5,
            ),
          ),
          onChange: (val) {
            if (assetDowntimeP.searchOnStoppedTyping != null) {
              assetDowntimeP.searchOnStoppedTyping!.cancel();
            }
            assetDowntimeP.searchOnStoppedTyping =
                Timer(assetDowntimeP.duration, () {
              pagingC.refresh();
            });
          },
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Asset Downtime"),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () => Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => CreateAssetDowntimeView()))),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: RefreshIndicator(
            color: Constant.primaryColor,
            onRefresh: () async => pagingC.refresh(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                search(),
                Constant.xSizedBox16,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Asset List",
                      style: Constant.grayMedium.copyWith(
                          color: Colors.black38, fontWeight: FontWeight.w500)),
                ),
                Constant.xSizedBox8,
                Flexible(
                  child: PagedListView(
                    shrinkWrap: true,
                    pagingController: pagingC,
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 20),
                    // shrinkWrap: true,
                    // separatorBuilder: (_, __) => Constant.xSizedBox16,
                    builderDelegate:
                        PagedChildBuilderDelegate<AssetDowntimeModelData>(
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
                        final assetData = item;
                        final assetDataFiles = item.file ?? [];
                        return InkWell(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            assetDowntimeP.assetSearchC.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewAssetDowntimeView(
                                        assetCode: assetData.code ?? "-",
                                        assetName: assetData.name ?? "-",
                                        assetId: assetData.id ?? "0")));
                          },
                          child: Container(
                            // width: double.infinity,
                            // margin:
                            //     EdgeInsets.only(left: 20, right: 20, top: 10),
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 12, bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: SafeNetworkImage.circle(
                                    radius: 30,
                                    url: assetDataFiles.isEmpty
                                        ? "a"
                                        : assetDataFiles.first ??
                                            "asset gambar",
                                    errorBuilder: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                          'assets/icons/ic-asset-downtime.png'),
                                    ),
                                  ),
                                ),
                                Constant.xSizedBox18,
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(assetData?.code ?? "-",
                                          style: Constant.blackBold),
                                      SizedBox(height: 5),
                                      Text(assetData?.name ?? "-",
                                          style: Constant.grayRegular),
                                      SizedBox(height: 5),
                                      Text(assetData?.cabang?.name ?? "-",
                                          style: Constant.grayRegular12),
                                    ],
                                  ),
                                ),
                                Constant.xSizedBox4,
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        assetData.jenisAsset?.name ?? "-",
                                        style: Constant.grayRegular12,
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        assetData.company?.name ?? "-",
                                        style: Constant.grayRegular12,
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        assetData.downtime == "0"
                                            ? "Running"
                                            : "Not Running",
                                        style: Constant().statusText(
                                            assetData.downtime ?? "0"),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }
}
