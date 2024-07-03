import 'dart:async';

import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/common/component/custom_textfield.dart';
import 'package:hy_tutorial/common/helper/safe_network_image.dart';
import 'package:hy_tutorial/src/work_order/view/work_order_view.dart';
import 'package:hy_tutorial/src/work_order/wo_agreement/model/wo_agreement_model.dart';
import 'package:hy_tutorial/src/work_order/wo_agreement/view/create_wo_agreement/view_wo_agreement_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/base/base_state.dart';
import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../provider/wo_agreement_provider.dart';

class WOAgreementView extends StatefulWidget {
  WOAgreementView();

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<WOAgreementView> createState() => _WOAgreementViewState();
}

class _WOAgreementViewState extends BaseState<WOAgreementView> {
  @override
  void initState() {
    final woA = context.read<WOAgreementProvider>();
    woA.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => woA.fetchWOAgreement(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final woAgreementP = context.watch<WOAgreementProvider>();
    final pagingC = context.watch<WOAgreementProvider>().pagingController;

    Widget search() => CustomTextField.borderTextField(
          controller: woAgreementP.woAgreementSearchC,
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
            if (woAgreementP.searchOnStoppedTyping != null) {
              woAgreementP.searchOnStoppedTyping!.cancel();
            }
            woAgreementP.searchOnStoppedTyping =
                Timer(woAgreementP.duration, () {
              pagingC.refresh();
            });
          },
        );

    Widget logPopUp() {
      final logData = woAgreementP.woAgreementLogModel.data;
      return SingleChildScrollView(
        child: Container(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: (logData ?? []).isEmpty
                ? [Utils.notFoundImage()]
                : List.generate(
                    logData?.length ?? 0,
                    (index) {
                      final item = logData?[index];
                      return Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: Constant.grayRegular
                                      .copyWith(fontSize: 10),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  item?.name ?? "-",
                                  style: Constant.grayRegular13,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Date",
                                  style: Constant.grayRegular
                                      .copyWith(fontSize: 10),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  item?.time ?? "-",
                                  style: Constant.grayRegular13,
                                ),
                              ],
                            ),
                            SizedBox(width: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Doc Status",
                                  style: Constant.grayRegular
                                      .copyWith(fontSize: 10),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  item?.docStatus ?? "-",
                                  style: Constant.grayRegular13,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Note",
                                  style: Constant.grayRegular
                                      .copyWith(fontSize: 10),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  item?.note ?? "-",
                                  style: Constant.grayRegular13,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      );
    }

    Widget aproverPopup() {
      return SingleChildScrollView(
        child: Container(
          width: 600,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      "1",
                      style: Constant.grayRegular13,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "1706104008 - Budianto Hari",
                      style: Constant.grayRegular13,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue.shade50,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      "2",
                      style: Constant.grayRegular13,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "880314249 - Mochamad Azwar",
                      style: Constant.grayRegular13,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      "3",
                      style: Constant.grayRegular13,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "760813221 - Munari Khusaeri",
                      style: Constant.grayRegular13,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue.shade50,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      "4",
                      style: Constant.grayRegular13,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "890904833 - Dusty Widha Hutama",
                      style: Constant.grayRegular13,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "WO Agreement",
        // leading: IconButton(
        //     onPressed: () => Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => WorkOrderView())),
        //     icon: Icon(Icons.keyboard_arrow_left)),
      ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("WO List",
                          style: Constant.grayMedium.copyWith(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500)),
                      CustomButton.smallMainButton("+ Create", () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        woAgreementP.woAgreementSearchC.clear();
                        await woAgreementP.clearAllCreateWO();
                        woAgreementP.isCreate = true;
                        woAgreementP.woAgreementModelData =
                            WOAgreementModelData();
                        final f = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewWOAgreementView()));
                        if (f != null) {
                          pagingC.refresh();
                        }
                        // woAgreementP.isCreate = false;
                        // woAgreementP.clearAllCreateWO();
                      },
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          textStyle: Constant.whiteBold,
                          borderRadius: BorderRadius.circular(10))
                    ],
                  ),
                ),
                Flexible(
                  child: PagedListView.separated(
                    shrinkWrap: true,
                    pagingController: pagingC,
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 20),
                    separatorBuilder: (_, __) => Constant.xSizedBox16,
                    builderDelegate:
                        PagedChildBuilderDelegate<WOAgreementModelData>(
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
                      itemBuilder: (context, item, indexs) {
                        final woDataFiles = item.woFiles ?? [];
                        return InkWell(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            woAgreementP.woAgreementSearchC.clear();
                            woAgreementP.woAgreementModelData = item;

                            woAgreementP.isCreate = false;
                            final f = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewWOAgreementView()));
                            if (f != null) {
                              pagingC.refresh();
                            }

                            // woAgreementP.woAgreementModelData =
                            //     WOAgreementModelData();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SafeNetworkImage.circle(
                                      radius: 25,
                                      url: woDataFiles.isEmpty
                                          ? "a"
                                          : "https://${Constant.DOMAIN}" +
                                              (woDataFiles.first?.file ??
                                                  "asset gambar"),
                                      errorBuilder: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                            'assets/icons/ic-wo-agreement-menu.png'),
                                      ),
                                    ),
                                  ),
                                  Constant.xSizedBox16,
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.docNo ?? "-",
                                            style: Constant.blackBold),
                                        SizedBox(height: 5),
                                        Text(item.typeWork?.name ?? "-",
                                            style: Constant.grayRegular),
                                        SizedBox(height: 5),
                                        Text(item.asset?.name ?? "-",
                                            style: Constant.grayRegular),
                                        SizedBox(height: 5),
                                        Text(item.cabang?.name ?? "",
                                            style: Constant.grayRegular),
                                      ],
                                    ),
                                  ),
                                  Constant.xSizedBox4,
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          item.dateDoc ?? "-",
                                          style: Constant.grayRegular,
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 7),
                                        // RichText(
                                        //   textAlign: TextAlign.right,
                                        //   text: TextSpan(
                                        //     text: "Cond : ",
                                        //     children: [
                                        //       if (item.isDowntime == "1")
                                        //         TextSpan(
                                        //           text: "Running",
                                        //           style: Constant.greenBold12,
                                        //         ),
                                        //       if (item.isDowntime == "0")
                                        //         TextSpan(
                                        //           text: "Not Running",
                                        //           style: Constant.redBold12,
                                        //         ),
                                        //     ],
                                        //     style: Constant.grayRegular12,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 7),
                                        RichText(
                                          textAlign: TextAlign.right,
                                          text: TextSpan(
                                            text: "Down : ",
                                            children: [
                                              if (item.isDowntime == "1")
                                                TextSpan(
                                                  text: "Yes",
                                                  style: Constant.redBold12,
                                                ),
                                              if (item.isDowntime == "0")
                                                TextSpan(
                                                  text: "No",
                                                  style: Constant.greenBold12,
                                                ),
                                            ],
                                            style: Constant.grayRegular12,
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        RichText(
                                          textAlign: TextAlign.right,
                                          text: TextSpan(
                                            text: "Doc : ",
                                            children: [
                                              TextSpan(
                                                text: item.docStatus ?? "-",
                                                style: Constant.blueBold12,
                                              ),
                                            ],
                                            style: Constant.grayRegular12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Constant.xSizedBox12,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomButton.smallMainButton("Log", () async {
                                    await context
                                        .read<WOAgreementProvider>()
                                        .fetchWOAgreementLog(item.id ?? "0",
                                            withLoading: true)
                                        .then(
                                          (value) => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'List Log',
                                                  style: Constant.primaryBold15,
                                                ),
                                                content: logPopUp(),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                        .onError(
                                          (error, stackTrace) =>
                                              Utils.showFailed(
                                                  msg: error
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains("doctype")
                                                      ? "Maaf, Terjadi Galat!"
                                                      : "$error"),
                                        );
                                  },
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      color: Constant.textHintColor2,
                                      textStyle: Constant.whiteRegular12),
                                  Constant.xSizedBox8,
                                  CustomButton.smallMainButton("Approver",
                                      () async {
                                    await context
                                        .read<WOAgreementProvider>()
                                        .fetchWOAgreementApprove(item.id ?? "0",
                                            withLoading: true)
                                        .then(
                                          (value) => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'List Approver',
                                                  style: Constant.primaryBold15,
                                                ),
                                                content: logPopUp(),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                        .onError(
                                          (error, stackTrace) =>
                                              Utils.showFailed(
                                                  msg: error
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains("doctype")
                                                      ? "Maaf, Terjadi Galat!"
                                                      : "$error"),
                                        );
                                  },
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      color: Constant.textHintColor2,
                                      textStyle: Constant.whiteRegular12),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
