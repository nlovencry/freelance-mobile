import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../model/asset_downtime_view_model.dart';
import '../provider/asset_downtime_provider.dart';
import 'create_asset_downtime_view.dart';

class ViewAssetDowntimeView extends StatefulWidget {
  final String assetCode;
  final String assetId;
  final String assetName;

  const ViewAssetDowntimeView(
      {super.key,
      required this.assetCode,
      required this.assetId,
      required this.assetName});

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<ViewAssetDowntimeView> createState() => _ViewAssetDowntimeViewState();
}

class _ViewAssetDowntimeViewState extends BaseState<ViewAssetDowntimeView> {
  @override
  void initState() {
    final amP = context.read<AssetDowntimeProvider>();
    amP.pagingControllerView = PagingController(firstPageKey: 1)
      ..addPageRequestListener((pageKey) => amP.fetchAssetDowntimeView(
          page: pageKey, assetCode: widget.assetCode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final assetDowntimeP = context.watch<AssetDowntimeProvider>();

    final pagingC = context.watch<AssetDowntimeProvider>().pagingControllerView;
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
          Text("Asset Downtime List", style: Constant.grayMedium),
          CustomButton.smallMainButton(
            "+ Add New",
            () async {
              final f = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateAssetDowntimeView(
                            assetCode: widget.assetCode,
                            assetId: widget.assetId,
                            documentDate: "",
                            documentDateTime: "",
                            upDate: "",
                            upDateTime: "",
                            description: "",
                            isCreate: true,
                          )));
              if (f != null) {
                pagingC.refresh();
              }

              context.read<AssetDowntimeProvider>().clearAssetDowntimeForm();
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            textStyle: Constant.whiteBold,
          ),
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
          builderDelegate:
              PagedChildBuilderDelegate<AssetDowntimeViewModelData>(
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
                          builder: (context) => CreateAssetDowntimeView(
                                assetCode: item.assetCode ?? "",
                                assetId: item.id ?? "0",
                                documentDate: item.dateDoc ?? "",
                                documentDateTime: item.time ?? "",
                                upDate: item.dateUp ?? "",
                                upDateTime: item.timeUp ?? "",
                                description: item.description ?? "",
                                isEdit: false,
                                isCreate: false,
                              )));
                  if (f != null) {
                    pagingC.refresh();
                  }
                  context
                      .read<AssetDowntimeProvider>()
                      .clearAssetDowntimeForm();
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
                            Text("Downtime", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.dateDoc ?? "",
                            ),
                            Constant.xSizedBox4,
                            Text("Up Date", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.dateDoc ?? "",
                            ),
                            Constant.xSizedBox4,
                            Text("Time", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.time ?? "",
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
                            Text("Time", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.time ?? "",
                            ),
                            Constant.xSizedBox4,
                            Text("Time", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.dateDoc ?? "",
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
                            // Constant.xSizedBox4,
                            // Text("Estimate Date", style: Constant.grayRegular8),
                            // Constant.xSizedBox4,
                            // Text(
                            //   item.dateDoc ?? "",
                            // ),
                            Constant.xSizedBox4,
                            Text("Created By", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(
                              item.createdBy ?? "",
                            ),
                            Constant.xSizedBox4,
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () async {
                                  final f = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateAssetDowntimeView(
                                                assetCode: item.assetCode ?? "",
                                                assetId: item.id ?? "0",
                                                documentDate:
                                                    item.dateDoc ?? "",
                                                documentDateTime:
                                                    item.time ?? "",
                                                upDate: item.dateUp ?? "",
                                                upDateTime: item.timeUp ?? "",
                                                description:
                                                    item.description ?? "",
                                                isEdit: true,
                                                isCreate: false,
                                              )));
                                  if (f != null) {
                                    pagingC.refresh();
                                  }

                                  context
                                      .read<AssetDowntimeProvider>()
                                      .clearAssetDowntimeForm();
                                },
                                child: Container(
                                    padding: EdgeInsets.all(4),
                                    width: 27,
                                    height: 27,
                                    child: Image.asset(
                                        'assets/icons/ic-edit.png')),
                              ),
                            ),
                            Constant.xSizedBox4,
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

    Widget cancelSaveButton() {
      return Row(
        children: [
          Expanded(child: CustomButton.secondaryButton("Cancel", () {})),
          Constant.xSizedBox16,
          Expanded(child: CustomButton.mainButton("Save", () {}))
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "View Asset Downtime"),
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
