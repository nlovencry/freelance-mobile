import 'dart:async';

import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/component/custom_textfield.dart';
import 'package:hy_tutorial/common/helper/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../model/operation_hours_model.dart';
import '../provider/operation_hours_provider.dart';
import 'view_operation_hours_view.dart';

class OperationHoursView extends StatefulWidget {
  OperationHoursView();

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<OperationHoursView> createState() => _OperationHoursViewState();
}

class _OperationHoursViewState extends BaseState<OperationHoursView> {
  @override
  void initState() {
    final oH = context.read<OperationHoursProvider>();
    oH.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => oH.fetchOperationHours(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final operationHoursP = context.watch<OperationHoursProvider>();
    final operationHoursModel =
        context.watch<OperationHoursProvider>().operationHoursModel.data;
    final pagingC = context.watch<OperationHoursProvider>().pagingController;

    Widget search() => CustomTextField.borderTextField(
          controller: operationHoursP.assetSearchC,
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
            if (operationHoursP.searchOnStoppedTyping != null) {
              operationHoursP.searchOnStoppedTyping!.cancel();
            }
            operationHoursP.searchOnStoppedTyping =
                Timer(operationHoursP.duration, () {
              pagingC.refresh();
            });
          },
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Operation Hours"),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () => Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => CreateOperationHoursView()))),
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
                  child: Text("Operation Hour List",
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
                        PagedChildBuilderDelegate<OperationHoursModelData>(
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
                        final operationHoursData = item;
                        final operationHoursDataFiles = item.file ?? [];
                        return InkWell(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            operationHoursP.assetSearchC.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewOperationHoursView(
                                          operationHoursCode:
                                              operationHoursData.code ?? "-",
                                          operationHoursName:
                                              operationHoursData.name ?? "-",
                                          operationHoursId:
                                              operationHoursData.id ?? "0",
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
                                    url: operationHoursDataFiles.isEmpty
                                        ? "a"
                                        : operationHoursDataFiles.first ??
                                            "asset goHbar",
                                    errorBuilder: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                          'assets/icons/ic-operation-hours.png'),
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
                                      Text(operationHoursData.code ?? "-",
                                          style: Constant.blackBold),
                                      SizedBox(height: 5),
                                      Text(operationHoursData.name ?? "-",
                                          style: Constant.grayRegular),
                                      SizedBox(height: 5),
                                      Text(
                                          operationHoursData.cabang?.name ??
                                              "-",
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
                                        operationHoursData.jenisAsset?.name ??
                                            "-",
                                        style: Constant.grayRegular12,
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        operationHoursData.company?.name ?? "-",
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
