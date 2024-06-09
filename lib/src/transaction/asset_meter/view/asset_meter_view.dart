import 'dart:async';

import 'package:mata/common/base/base_state.dart';
import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_textfield.dart';
import 'package:mata/common/helper/safe_network_image.dart';
import 'package:mata/src/transaction/asset_meter/model/asset_meter_model.dart';
import 'package:mata/src/transaction/asset_meter/view/create_asset_meter_view.dart';
import 'package:mata/src/transaction/asset_meter/view/view_asset_meter_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../provider/asset_meter_provider.dart';

class AssetMeterView extends StatefulWidget {
  AssetMeterView();

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<AssetMeterView> createState() => _AssetMeterViewState();
}

class _AssetMeterViewState extends BaseState<AssetMeterView> {
  @override
  void initState() {
    final aM = context.read<AssetMeterProvider>();
    aM.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener((pageKey) => aM.fetchAssetMeter(page: pageKey));
    super.initState();
  }

  @override
  void dispose() {
    // context.read<AssetMeterProvider>().pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetMeterP = context.watch<AssetMeterProvider>();
    final assetMeterModel =
        context.watch<AssetMeterProvider>().assetMeterModel.data;
    final pagingC = context.watch<AssetMeterProvider>().pagingController;

    Widget search() => CustomTextField.borderTextField(
          controller: assetMeterP.assetSearchC,
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
            if (assetMeterP.searchOnStoppedTyping != null) {
              assetMeterP.searchOnStoppedTyping!.cancel();
            }
            assetMeterP.searchOnStoppedTyping = Timer(assetMeterP.duration, () {
              pagingC.refresh();
            });
          },
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Asset Meter"),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () => Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => CreateAssetMeterView()))),
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
                        PagedChildBuilderDelegate<AssetMeterModelData>(
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
                            assetMeterP.assetMeterModelData = assetData;
                            FocusManager.instance.primaryFocus?.unfocus();
                            assetMeterP.assetSearchC.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewAssetMeterView(
                                          assetCode: assetData.code ?? "-",
                                          assetName: assetData.name ?? "-",
                                          assetId: assetData.id ?? "0",
                                        )));
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
                                          'assets/icons/ic-asset-meter.png'),
                                    ),
                                  ),
                                ),
                                Constant.xSizedBox18,
                                Expanded(
                                  flex: 6,
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
                                        assetData?.jenisAsset?.name ?? "-",
                                        style: Constant.grayRegular12,
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        assetData?.regional?.name ?? "-",
                                        style: Constant.grayRegular12,
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
