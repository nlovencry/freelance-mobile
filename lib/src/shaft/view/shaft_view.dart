import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

class _ShaftViewState extends State<ShaftView> {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DataAddProvider>();
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
                Expanded(child: Text('Tampilan grafik dari data shaft')),
                Constant.xSizedBox8,
                Text(
                    '${DateFormat('dd/MM/yyyy  |  HH : mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(d.turbineCreateModel.Data?.CreatedAt ?? '${DateTime.now()}'))}'),
              ],
            ),
            Constant.xSizedBox16,
            SampleChartView(),
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
