import 'package:mata/common/component/custom_navigator.dart';
import 'package:mata/src/work_order/wo_agreement/provider/wo_agreement_provider.dart';
import 'package:mata/src/work_order/wo_realization/view/wo_realization_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/helper/constant.dart';

import '../wo_agreement/view/wo_agreement_view.dart';
import '../provider/work_order_provider.dart';
import '../wo_realization/provider/wo_realization_provider.dart';

class WorkOrderView extends StatelessWidget {
  WorkOrderView();

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  Widget build(BuildContext context) {
    final workOrder = context.watch<WorkOrderProvider>();

    Widget subMenu() {
      return Container(
        height: 92,
        margin: EdgeInsets.only(top: 14, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () {
                  context
                      .read<WOAgreementProvider>()
                      .woAgreementSearchC
                      .clear();
                  CusNav.nPush(context, WOAgreementView());
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 4, bottom: 8),
                          child: Image.asset(
                              'assets/icons/ic-wo-agreement-menu.png',
                              width: 30)),
                      Text('WO Agreement',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () {
                  context
                      .read<WORealizationProvider>()
                      .woRealizationSearchC
                      .clear();
                  CusNav.nPush(context, WORealizationView());
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 4, bottom: 8),
                            child: Image.asset(
                                'assets/icons/ic-wo-realization-menu.png',
                                width: 30)),
                        Text('WO Realization',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis),
                      ],
                    )),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: Container(
          color: Colors.white,
          child: RefreshIndicator(
            color: Constant.primaryColor,
            onRefresh: () async => await context
                .read<WorkOrderProvider>()
                .fetchWorkOrder(withLoading: true),
            child: ListView(
              children: [
                SizedBox(height: 48),
                subMenu(),
                SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
