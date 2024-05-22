import 'package:bimops/common/base/base_state.dart';
import 'package:bimops/common/component/custom_appbar.dart';
import 'package:bimops/common/component/custom_button.dart';
import 'package:bimops/src/transaction/asset_meter/model/asset_meter_view_model.dart';
import 'package:bimops/src/transaction/asset_meter/view/create_asset_meter_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../provider/asset_meter_provider.dart';

class ViewAssetMeterView extends StatefulWidget {
  final String assetCode;
  final String assetId;
  final String assetName;

  const ViewAssetMeterView({
    super.key,
    required this.assetCode,
    required this.assetName,
    required this.assetId,
  });

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<ViewAssetMeterView> createState() => _ViewAssetMeterViewState();
}

class _ViewAssetMeterViewState extends BaseState<ViewAssetMeterView> {
  @override
  void initState() {
    final amP = context.read<AssetMeterProvider>();
    amP.pagingControllerView = PagingController(firstPageKey: 1)
      ..addPageRequestListener((pageKey) =>
          amP.fetchAssetMeterView(page: pageKey, assetCode: widget.assetCode));
    super.initState();
  }

  setData() {
    final p = context.read<AssetMeterProvider>();
    final data = context.read<AssetMeterProvider>().assetMeterViewModel.data;
    p.assetC.text = widget.assetCode;
  }

  @override
  Widget build(BuildContext context) {
    final assetViewMeterP =
        context.watch<AssetMeterProvider>().assetMeterViewModel.data;
    final assetP = context.watch<AssetMeterProvider>();

    final pagingC = context.watch<AssetMeterProvider>().pagingControllerView;
    Widget header() {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 60,
                  child: Text("Code", style: Constant.grayRegular12)),
              Constant.xSizedBox16,
              Flexible(
                  child: Text(widget.assetCode, style: Constant.blackBold16))
            ],
          ),
          Constant.xSizedBox16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 60,
                  child: Text("Name", style: Constant.grayRegular12)),
              Constant.xSizedBox16,
              Flexible(
                  child: Text(widget.assetName, style: Constant.blackBold16))
            ],
          ),
        ],
      );
    }

    Widget buttonAdd() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Asset Meter List", style: Constant.grayMedium),
          CustomButton.smallMainButton(
            "+ Add New",
            () async {
              final f = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateAssetMeterView(
                            assetCode: widget.assetCode,
                            assetId: widget.assetId,
                            documentDate: "",
                            documentDateTime: "",
                            category: "",
                            meterLalu: "0",
                            meter: "",
                            desc: "",
                          )));
              if (f != null) {
                pagingC.refresh();
              }
              context.read<AssetMeterProvider>().clearAssetMeterForm();
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            textStyle: Constant.whiteBold,
          )
        ],
      );
    }

    Widget table() {
      return Flexible(
        child: PagedListView.separated(
          shrinkWrap: true,
          pagingController: pagingC,
          padding: EdgeInsets.zero,
          separatorBuilder: (_, __) => Constant.xSizedBox4,
          builderDelegate: PagedChildBuilderDelegate<AssetMeterViewModelData>(
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
                onTap: () async {
                  final f = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAssetMeterView(
                                assetCode: widget.assetCode,
                                assetId: widget.assetId,
                                documentDate: item.dateDoc ?? "",
                                documentDateTime: item.time ?? "",
                                category: item.assetMeterCode ?? "",
                                meterLalu: item.meterLalu ?? "",
                                meter: item.meterReading ?? "",
                                desc: item.description ?? "",
                                isEdit: true,
                              )));
                  if (f != null) {
                    pagingC.refresh();
                  }
                  context.read<AssetMeterProvider>().clearAssetMeterForm();
                },
                child: Container(
                  color:
                      index % 2 == 0 ? Colors.white : Constant.tableBlueColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Constant.xSizedBox8,
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text("${index + 1}",
                              style: Constant.grayRegular13),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Constant.xSizedBox4,
                            Text("Category", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.assetMeterCode ?? "Asset Code -",
                            ),
                            Constant.xSizedBox4,
                            Text("Description", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.description ?? "-",
                            ),
                            Constant.xSizedBox4,
                          ],
                        ),
                      ),
                      Constant.xSizedBox4,
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Constant.xSizedBox4,
                            Text("Tanggal", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.dateDoc ?? "Tanggal -",
                            ),
                            Constant.xSizedBox4,
                            Text("Created By", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.createdBy ?? "Created By -",
                            ),
                            Constant.xSizedBox4,
                          ],
                        ),
                      ),
                      Constant.xSizedBox4,
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Constant.xSizedBox4,
                            Text("Meter", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.meterReading ?? "Meter Reading -",
                            ),
                            Constant.xSizedBox4,
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: InkWell(
                            //     onTap: () async {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   CreateAssetMeterView(
                            //                       assetCode: widget.assetCode,
                            //                       assetId: widget.assetId)));

                            //       context
                            //           .read<AssetMeterProvider>()
                            //           .clearAssetMeterForm();
                            //     },
                            //     child: Container(
                            //         padding: EdgeInsets.all(4),
                            //         width: 27,
                            //         height: 27,
                            //         child:
                            //             Image.asset('assets/icons/ic-edit.png')),
                            //   ),
                            // ),
                            // Constant.xSizedBox4,
                          ],
                        ),
                      ),
                      Constant.xSizedBox4,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "View Asset Meter"),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: RefreshIndicator(
            color: Constant.primaryColor,
            onRefresh: () async => pagingC.refresh(),
            child: Column(
              children: [
                header(),
                Constant.xSizedBox24,
                buttonAdd(),
                Constant.xSizedBox18,
                table(),
                Constant.xSizedBox16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
