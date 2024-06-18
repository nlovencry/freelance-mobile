import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/shaft/view/sample_chart_view.dart';
import 'package:provider/provider.dart';

import '../../data/provider/data_add_provider.dart';

class ShaftView extends StatefulWidget {
  const ShaftView({super.key});

  @override
  State<ShaftView> createState() => _ShaftViewState();
}

class _ShaftViewState extends State<ShaftView> with TickerProviderStateMixin {
  int currentIndex = 0;
  late TabController tabController;
  @override
  void initState() {
    final p = context.read<DataAddProvider>();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final d = context.watch<DataAddProvider>();
    final shaft =
        context.watch<DataAddProvider>().turbineCreateModel.Data?.Shaft;
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
            // width: 91, // width in percent
            // borderRadius: 30,
            // height: 50,
            // selectedIndex: currentIndex,
            // selectedBackgroundColors: [Constant.primaryColor],
            // unSelectedBackgroundColors: [Color(0xffffffff)],
            // selectedTextStyle:
            //     TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            // unSelectedTextStyle: TextStyle(color: Colors.black87),
            tabs: [
              _buildTab("Upper"),
              _buildTab("Clutch"),
              _buildTab("Turbine")
            ],
            // selectedLabelIndex: (index) {
            //   setState(() {
            //     currentIndex = index;
            //     tabController.index = index;
            //   });
            // },
            // isScroll: false,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar.appBar(context, 'Shaft'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ListView(
          shrinkWrap: true,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  '${DateFormat('dd/MM/yyyy  |  HH : mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(d.turbineCreateModel.Data?.CreatedAt ?? '${DateTime.now()}'))}',
                  style: TextStyle(color: Constant.textColorBlack),
                ),
              ],
            ),
            Constant.xSizedBox16,
            toggleTab(),
            Constant.xSizedBox16,
            Container(
              color: Colors.white,
              height: 325,
              child: TabBarView(
                controller: tabController,
                children: [
                  SampleChartView(activeIndex: 0),
                  SampleChartView(activeIndex: 1),
                  SampleChartView(activeIndex: 2),
                  // UPPER LINGKARAN
                  // SampleChartView(),
                ],
              ),
            ),
            Constant.xSizedBox16,

            Text('Detail Data', style: Constant.iBlackMedium16),
            Constant.xSizedBox8,
            Text(
              'Detail data shaft yang telah di input',
              style: TextStyle(fontSize: 12, color: Constant.grayColor),
            ),
            Constant.xSizedBox16,
            Column(
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
            ),
            Constant.xSizedBox18,
            // Stack(
            //   children: [
            //     SampleChartView(),
            //     // Positioned(
            //     //   top: 0,
            //     //   bottom: 0,
            //     //   right: 0,
            //     //   left: 0,
            //     //   child: Icon(Icons.alarm),
            //     // ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
