import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/shaft/view/sample_chart_view.dart';

class ShaftView extends StatefulWidget {
  const ShaftView({super.key});

  @override
  State<ShaftView> createState() => _ShaftViewState();
}

class _ShaftViewState extends State<ShaftView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(context, 'Shaft'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Grafik Shaft'),
            Constant.xSizedBox16,
            Row(
              children: [
                Text('Tampilan grafik dari data shaft'),
                Text(
                    '${DateFormat('dd/MM/yyyy | HH : mm').format(DateTime.now())}'),
              ],
            ),
            Constant.xSizedBox16,
            Stack(
              children: [
                SampleChartView(),
                // Positioned(
                //   top: 0,
                //   bottom: 0,
                //   right: 0,
                //   left: 0,
                //   child: Icon(Icons.alarm),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
