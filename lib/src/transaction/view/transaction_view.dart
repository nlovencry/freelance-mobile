import 'package:hy_tutorial/src/transaction/asset_downtime/provider/asset_downtime_provider.dart';
import 'package:hy_tutorial/src/transaction/asset_downtime/view/asset_downtime_view.dart';
import 'package:hy_tutorial/src/transaction/asset_meter/provider/asset_meter_provider.dart';
import 'package:hy_tutorial/src/transaction/operation_hours/provider/operation_hours_provider.dart';

import 'package:hy_tutorial/src/transaction/operation_hours/view/operation_hours_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/helper/constant.dart';

import '../asset_meter/view/asset_meter_view.dart';
import '../provider/transaction_provider.dart';

class TransactionView extends StatelessWidget {
  TransactionView();

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  Widget build(BuildContext context) {
    final transaction = context.watch<TransactionProvider>();
    final assetMeterP = context.watch<AssetMeterProvider>();
    final assetDowntimeP = context.watch<AssetDowntimeProvider>();
    final operationHoursP = context.watch<OperationHoursProvider>();

    Widget subMenu() {
      return Container(
        height: 92,
        margin: EdgeInsets.only(top: 14, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  assetMeterP.assetSearchC.clear();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AssetMeterView()));
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
                          child: Image.asset('assets/icons/ic-asset-meter.png',
                              width: 30)),
                      Text('Asset Meter',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => TambahJamaah2View(),
                  //     ));
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
                    child: InkWell(
                      onTap: () {
                        assetDowntimeP.assetSearchC.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssetDowntimeView()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 4, bottom: 8),
                              child: Image.asset(
                                  'assets/icons/ic-asset-downtime.png',
                                  width: 30)),
                          Text('Asset\nDowntime',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    )),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  operationHoursP.assetSearchC.clear();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OperationHoursView()));
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
                              'assets/icons/ic-operation-hours.png',
                              width: 30)),
                      Text('Operation\nHours',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                ),
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
                .read<TransactionProvider>()
                .fetchTransaction(withLoading: true),
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
