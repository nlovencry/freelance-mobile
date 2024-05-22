import 'package:bimops/src/work_order/wo_agreement/view/create_wo_agreement/activity_wo_agreement_view.dart';
import 'package:bimops/src/work_order/wo_agreement/view/create_wo_agreement/attachment_wo_agreement.dart';
import 'package:bimops/src/work_order/wo_agreement/view/create_wo_agreement/labours_wo_agreement.dart';
import 'package:bimops/src/work_order/wo_agreement/view/create_wo_agreement/service_wo_agreement.dart';
import 'package:bimops/src/work_order/wo_agreement/view/create_wo_agreement/sparepart_wo_agreement.dart';
import 'package:bimops/src/work_order/wo_agreement/view/create_wo_agreement/tools_wo_agreement.dart';
import 'package:bimops/src/work_order/wo_agreement/view/create_wo_agreement/view_wo_agreement_view.dart';
import 'package:bimops/src/work_order/wo_agreement/view/header_wo_agreement_view.dart';
import 'package:flutter/material.dart';
import '../../../../common/component/custom_navigator.dart';
import '../../../../common/helper/constant.dart';

List<String> name = [
  "Work Order",
  "Activities",
  "Tools",
  "Labours",
  "Service",
  "Sparepart",
  "Attachment",
];

List<Widget> divider(Color color) {
  return [
    Constant.xSizedBox8,
    Container(
      width: 30,
      height: 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    Constant.xSizedBox8,
  ];
}

Widget choicePage(int index) {
  if (index == 0) {
    return ViewWOAgreementView();
  }
  if (index == 1) {
    return ActivityWOAgreement();
  }
  if (index == 2) {
    return ToolsWOAgreement();
  }
  if (index == 3) {
    return LaboursWOAgreement();
  }
  if (index == 4) {
    return ServiceWOAgreement();
  }
  if (index == 5) {
    return SparepartWOAgreement();
  }
  return AttachmentWOAgreement();
}

ScrollController _scrollController = ScrollController();

_scrollToLastPosition(int index) {
  double scrollPosition = index * 100;
  _scrollController.jumpTo(
      scrollPosition
  );
}

Widget subHeaderWo(int pcc ,BuildContext context) {
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    _scrollToLastPosition(pcc);
  });
  return SizedBox(
    height: 80,
    child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(width: 8,);
        },
        controller: _scrollController,
        itemCount: name.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            children: [
              InkWell(
                onTap: () {
                  CusNav.nPop(context);
                  CusNav.nPush(context, choicePage(index));
                },
                child: Column(
                  children: [
                    Constant.xSizedBox16,
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: index == pcc
                        ? Constant.primaryColor
                        : Constant.grayColor
                        ,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                          child: Text(
                            "${index + 1}",
                            style: Constant.whiteRegular12.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )),
                    ),
                    Text(
                      name[index],
                      style: Constant.iPrimaryMedium8.copyWith(fontSize: 13, color: index == pcc
                      ? Constant.primaryColor
                      : Constant.grayColor
                      ),
                    )
                  ],
                ),
              ),
              if (index != name.length - 1) ...divider(
                index==pcc
                    ? Constant.primaryColor
                    : Constant.grayColor
              ),
            ],
          );
        }),
  );
}
