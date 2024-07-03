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
import '../model/operation_hours_view_model.dart';
import '../provider/operation_hours_provider.dart';
import 'create_operation_hours_view.dart';

class ViewOperationHoursView extends StatefulWidget {
  final String operationHoursCode;
  final String operationHoursId;
  final String operationHoursName;

  const ViewOperationHoursView(
      {super.key,
      required this.operationHoursCode,
      required this.operationHoursId,
      required this.operationHoursName});

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<ViewOperationHoursView> createState() => _ViewOperationHoursViewState();
}

class _ViewOperationHoursViewState extends BaseState<ViewOperationHoursView> {
  @override
  void initState() {
    final amP = context.read<OperationHoursProvider>();
    amP.pagingControllerView = PagingController(firstPageKey: 1)
      ..addPageRequestListener((pageKey) => amP.fetchOperationHoursView(
          page: pageKey, operationHoursCode: widget.operationHoursCode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final operationHoursViewMeterP =
        context.watch<OperationHoursProvider>().operationHoursViewModel.data;

    final pagingC =
        context.watch<OperationHoursProvider>().pagingControllerView;
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
                  child: Text(widget.operationHoursCode,
                      style: Constant.blackBold16))
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
                  child: Text(widget.operationHoursName,
                      style: Constant.blackBold16))
            ],
          ),
        ],
      );
    }

    Widget buttonAdd() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Operation Hours List", style: Constant.grayMedium),
          CustomButton.smallMainButton(
            "+ Add New",
            () async {
              final f = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateOperationHoursView(
                            operationHoursCode: widget.operationHoursCode,
                            operationHoursId: widget.operationHoursId,
                            date: "",
                            dateTime: "",
                            category: "",
                            meter: "",
                            description: "",
                          )));
              if (f != null) {
                pagingC.refresh();
              }
              context.read<OperationHoursProvider>().clearOperationHoursForm();
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
          builderDelegate:
              PagedChildBuilderDelegate<OperationHoursViewModelData>(
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
                          builder: (context) => CreateOperationHoursView(
                                operationHoursCode: widget.operationHoursCode,
                                operationHoursId: widget.operationHoursId,
                                date: item.dateDoc ?? "",
                                dateTime: item.time ?? "",
                                category: item.assetMeterCode ?? "",
                                meter: item.meterReading ?? "",
                                description: item.description ?? "",
                                isEdit: true,
                              )));
                  if (f != null) {
                    pagingC.refresh();
                  }
                  context
                      .read<OperationHoursProvider>()
                      .clearOperationHoursForm();
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
                            Text("Doc No", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(item.docNo ?? "-"),
                            Constant.xSizedBox4,
                            Text("Category", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(item.assetMeterCode ?? "-"),
                            Constant.xSizedBox4,
                            Text("Meter", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(item.meterReading ?? "-"),
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
                            Text("Date", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(item.dateDoc ?? "-"),
                            Constant.xSizedBox4,
                            Text("Description", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(item.description ?? "-"),
                            Constant.xSizedBox4,
                            Text("Created By", style: Constant.grayRegular8),
                            Constant.xSizedBox4,
                            Text(item.createdBy ?? "-"),
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "View Operation Hours"),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: RefreshIndicator(
            color: Constant.primaryColor,
            onRefresh: () async {},
            // onRefresh: () async => await context
            //     .read<OperationHoursProvider>()
            //     .fetchOperationHours(withLoading: true),
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
