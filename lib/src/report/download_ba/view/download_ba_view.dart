import 'dart:async';

import 'package:mata/common/base/base_state.dart';
import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_textField.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/report/download_ba/model/ba_model.dart';
import 'package:mata/src/report/download_ba/view/view_download_ba_view.dart';
import 'package:mata/src/report/provider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../utils/utils.dart';
import '../provider/ba_provider.dart';

class DownloadBAView extends StatefulWidget {
  const DownloadBAView({super.key});

  @override
  State<DownloadBAView> createState() => _DownloadBAViewState();
}

class _DownloadBAViewState extends BaseState<DownloadBAView> {
  @override
  void initState() {
    final baP = context.read<BAProvider>();
    baP.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener((pageKey) => baP.fetchBA(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final baP = context.watch<BAProvider>();
    final pagingC = context.watch<BAProvider>().pagingController;

    Widget search() => CustomTextField.borderTextField(
          controller: baP.baSearchC,
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
          padding: EdgeInsets.zero,
          validator: null,
          onChange: (value) async {
            if (baP.searchOnStoppedTyping != null) {
              baP.searchOnStoppedTyping!.cancel();
            }
            baP.searchOnStoppedTyping = Timer(baP.duration, () {
              pagingC.refresh();
            });
          },
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Download BA"),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              search(),
              Constant.xSizedBox16,
              Text("BA List",
                  style: Constant.grayMedium.copyWith(
                      color: Colors.black38, fontWeight: FontWeight.w500)),
              Constant.xSizedBox16,
              Flexible(
                child: PagedListView.separated(
                  shrinkWrap: true,
                  pagingController: pagingC,
                  padding: EdgeInsets.fromLTRB(0, 18, 0, 20),
                  separatorBuilder: (_, __) => Constant.xSizedBox16,
                  builderDelegate: PagedChildBuilderDelegate<BAModelData>(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewDownloadBAView(
                                        id: item.id ?? "",
                                        docNo: item.docNo ?? "",
                                      )));
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
                                      'assets/icons/ic-document-ba.png',
                                      scale: 4,
                                    ),
                                  ),
                                  SizedBox(width: 13),
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.assetCode ?? "",
                                            style: Constant.blackBold),
                                        SizedBox(height: 5),
                                        Text(item.typeWork?.name ?? "",
                                            style: Constant.grayRegular),
                                        SizedBox(height: 5),
                                        Text(item.asset?.name ?? "",
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
                                        Text(item.dateDoc ?? "-",
                                            style: Constant.grayRegular),
                                        SizedBox(height: 5),
                                        Text(item.cabang?.name ?? "",
                                            style: Constant.grayRegular),
                                        SizedBox(height: 5),
                                        Text(item?.docStatus ?? "-",
                                            style: Constant.iPrimaryMedium8
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
