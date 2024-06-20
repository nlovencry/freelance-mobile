import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../common/component/custom_appbar.dart';
import '../../../common/helper/constant.dart';
import 'sample_chart_view.dart';
import "package:provider/provider.dart";
import '../../../common/component/custom_textfield.dart';
import '../../data/provider/data_add_provider.dart';
import 'upper_chart_view.dart';

class ShaftDetailView extends StatefulWidget {
  ShaftDetailView({super.key, required this.id});
  final String id;
  @override
  State<ShaftDetailView> createState() => _ShaftDetailViewState();
}

class _ShaftDetailViewState extends State<ShaftDetailView>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late TabController tabController;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final p = context.read<DataAddProvider>();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      log("INDEX ACTIVE : ${tabController.index}");
      setState(() {});
    });
    await p.fetchTurbineDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final d = context.watch<DataAddProvider>();
    final shaft =
        context.watch<DataAddProvider>().turbineDetailModel.Data?.Shaft;
    final upperData = context
        .watch<DataAddProvider>()
        .turbineDetailModel
        .Data
        ?.DetailData
        ?.Upper;
    Widget _buildTab(String tag) {
      return Tab(child: Text(tag, style: TextStyle(fontSize: 18)));
    }

    Widget toggleTab() {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Constant.primaryColor, width: 0.5)),
        child: Center(
          child: TabBar(
            isScrollable: true,
            controller: tabController,
            indicatorWeight: 4,
            unselectedLabelColor: Constant.grayColor,
            labelColor: Constant.primaryColor,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
            indicatorColor: Constant.primaryColor,
            tabs: [_buildTab("A-C"), _buildTab("B-D"), _buildTab("Upper")],
          ),
        ),
      );
    }

    Widget acBdActive() => Column(
          children: [
            Container(
              color: Color(0xffEFEFEF),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Gen. Bearing-Kopling',
                      style: TextStyle(color: Constant.textColorBlack),
                    ),
                  ),
                  Constant.xSizedBox8,
                  Expanded(
                    flex: 5,
                    child: Text(
                      '${shaft?.GenBearingToCoupling ?? 0}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Kopling - Turbin',
                      style: TextStyle(color: Constant.textColorBlack),
                    ),
                  ),
                  Constant.xSizedBox8,
                  Expanded(
                    flex: 5,
                    child: Text(
                      '${shaft?.CouplingToTurbine ?? 0}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xffEFEFEF),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Total',
                      style: TextStyle(color: Constant.textColorBlack),
                    ),
                  ),
                  Constant.xSizedBox8,
                  Expanded(
                    flex: 5,
                    child: Text(
                      '${shaft?.Total ?? 0}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Rasio',
                      style: TextStyle(color: Constant.textColorBlack),
                    ),
                  ),
                  Constant.xSizedBox8,
                  Expanded(
                    flex: 5,
                    child: Text(
                      (shaft?.Ratio ?? 0).toStringAsFixed(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

    Widget upperActive() => Table(
          border: TableBorder.all(
              color: Constant.borderSearchColor,
              borderRadius: BorderRadius.circular(5)),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(),
            4: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Text('\n\n', textAlign: TextAlign.center),
              Text('\nA\n', textAlign: TextAlign.center),
              Text('\nB\n', textAlign: TextAlign.center),
              Text('\nC\n', textAlign: TextAlign.center),
              Text('\nD\n', textAlign: TextAlign.center),
            ]),
            TableRow(children: [
              Text('1', textAlign: TextAlign.center),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.A?.the1 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.B?.the1 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.C?.the1 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.D?.the1 ?? 0}'),
            ]),
            TableRow(children: [
              Text('2', textAlign: TextAlign.center),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.A?.the2 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.B?.the2 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.C?.the2 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.D?.the2 ?? 0}'),
            ]),
            TableRow(children: [
              Text('3', textAlign: TextAlign.center),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.A?.the3 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.B?.the3 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.C?.the3 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.D?.the3 ?? 0}'),
            ]),
            TableRow(children: [
              Text('4', textAlign: TextAlign.center),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.A?.the4 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.B?.the4 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.C?.the4 ?? 0}'),
              CustomTextField.tableTextField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = '${upperData?.D?.the4 ?? 0}'),
            ]),
          ],
        );

    return Scaffold(
      appBar: CustomAppBar.appBar(context, 'Shaft'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'Grafik Shaft',
              style: Constant.iBlackMedium16,
            ),
            Constant.xSizedBox8,
            Row(
              children: [
                Expanded(
                    child: Text(
                  'Tampilan grafik dari data shaft',
                  style: TextStyle(fontSize: 12, color: Constant.grayColor),
                )),
                Constant.xSizedBox4,
                Text(
                  '${DateFormat('dd/MM/yyyy  |  HH : mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(d.turbineDetailModel.Data?.CreatedAt ?? '${DateTime.now()}'))}',
                  style: TextStyle(color: Constant.textColorBlack),
                ),
              ],
            ),
            Constant.xSizedBox16,
            toggleTab(),
            Container(
                child: tabController.index == 2
                    ? UpperChartView()
                    : SampleChartView(activeIndex: tabController.index)),
            Constant.xSizedBox16,
            Text('Detail Data', style: Constant.iBlackMedium16),
            Constant.xSizedBox8,
            Text(
              'Detail data shaft yang telah di input',
              style: TextStyle(fontSize: 12, color: Constant.grayColor),
            ),
            Constant.xSizedBox16,
            upperActive(),
            Constant.xSizedBox16,
            acBdActive(),
            Constant.xSizedBox18,
          ],
        ),
      ),
    );
  }
}
