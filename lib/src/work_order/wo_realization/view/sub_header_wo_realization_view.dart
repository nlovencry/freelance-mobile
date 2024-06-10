import 'package:mata/src/work_order/wo_realization/view/create_wo_realization/view_wo_realization_view.dart';
import 'package:flutter/material.dart';

import '../../../../common/component/custom_navigator.dart';
import '../../../../common/helper/constant.dart';
import 'create_wo_realization/activity_wo_realization.dart';
import 'create_wo_realization/attachment_realisasi_wo_realization.dart';
import 'create_wo_realization/attachment_wo_realization.dart';
import 'create_wo_realization/failure_code_wo_realization.dart';
import 'create_wo_realization/labours_wo_realization.dart';
import 'create_wo_realization/progress_wo_realization.dart';
import 'create_wo_realization/service_wo_realization.dart';
import 'create_wo_realization/sparepart_wo_realization.dart';
import 'create_wo_realization/tools_wo_realization.dart';

List<String> name = [
  "Work Order",
  "Activities",
  "Tools",
  "Labours",
  "Service",
  "Sparepart",
  "Attachment",
  "Progress",
  "Failure Code",
  "Attachment Realisasi",
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

Widget choicePage(int index, bool) {
  if (index == 0) {
    return ViewWORealizationView();
  }
  if (index == 1) {
    return ActivityWORealization();
  }
  if (index == 2) {
    return ToolsWORealization();
  }
  if (index == 3) {
    return LaboursWORealization();
  }
  if (index == 4) {
    return ServiceWORealization();
  }
  if (index == 5) {
    return SparepartWORealization();
  }
  if (index == 6) {
    return AttachmentWORealization();
  }
  if (index == 7) {
    return ProgressWORealization();
  }
  if (index == 8) {
    return FailureCodeView();
  }
  return AttachmentRealizationView();
}

ScrollController _scrollController1 = ScrollController();

_scrollToLastPosition1(int index) {
  double scrollPosition = index * 100;
  _scrollController.jumpTo(scrollPosition);
}

ScrollController _scrollController = ScrollController();

_scrollToLastPosition(int index) {
  double scrollPosition = index * 100;
  _scrollController.jumpTo(scrollPosition);
}

Widget subHeaderWo(int pcc, BuildContext context, {bool isEdit = false}) {
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    _scrollToLastPosition(pcc);
  });
  return SizedBox(
    height: 80,
    child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 8,
          );
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
                  CusNav.nPush(context, choicePage(index, isEdit));
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
                            : Constant.grayColor,
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
                      style: Constant.iPrimaryMedium8.copyWith(
                          fontSize: 13,
                          color: index == pcc
                              ? Constant.primaryColor
                              : Constant.grayColor),
                    )
                  ],
                ),
              ),
              if (index != name.length - 1)
                ...divider(
                    index == pcc ? Constant.primaryColor : Constant.grayColor),
            ],
          );
        }),
  );
}

//
// Widget subHeaderWo2(int pcc, BuildContext context, {bool isEdit = false}) {
//   WidgetsBinding.instance!.addPostFrameCallback((_) {
//     _scrollToLastPosition1(pcc);
//   });
//   return Container(
//     child: SingleChildScrollView(
//       controller: _scrollController1,
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: List.generate(
//           name.length,
//           (index) {
//             return Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     CusNav.nPop(context);
//                     CusNav.nPush(context, choicePage(index, isEdit));
//                   },
//                   child: Column(
//                     children: [
//                       Constant.xSizedBox16,
//                       Container(
//                         width: 35,
//                         height: 35,
//                         decoration: BoxDecoration(
//                           color: Constant.primaryColor,
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Center(
//                             child: Text(
//                               "${index + 1}",
//                               style: Constant.whiteRegular12.copyWith(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                             )),
//                       ),
//                       Text(
//                         name[index],
//                         style: Constant.iPrimaryMedium8.copyWith(fontSize: 13),
//                       )
//                     ],
//                   ),
//                 ),
//                 if (index != name.length - 1) ...divider(),
//               ],
//             );
//           }
//         ),
//       ),
//     ),
//   );
//
// }

