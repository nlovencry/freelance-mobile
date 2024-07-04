import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:provider/provider.dart';
import 'package:powers/powers.dart';
import '../../data/provider/data_add_provider.dart';

class UpperChartView extends StatefulWidget {
  UpperChartView({super.key});

  @override
  State<UpperChartView> createState() => _UpperChartViewState();
}

class _UpperChartViewState extends State<UpperChartView> {
  var baselineX = 0.0;
  var baselineY = 0.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  // slider
                  // RotatedBox(
                  //   quarterTurns: 1,
                  //   child: Slider(
                  //     value: baselineY,
                  //     onChanged: (newValue) {
                  //       setState(() {
                  //         baselineY = newValue;
                  //       });
                  //     },
                  //     min: -10,
                  //     max: 10,
                  //   ),
                  // ),
                  Expanded(
                    // child: RotatedBox(
                    // quarterTurns: 1,
                    child: _Chart(
                      baselineX,
                      (20 - (baselineY + 10)) - 10,
                    ),
                  ),
                  // )
                ],
              ),
            ),
            // Slider(
            //   value: baselineX,
            //   onChanged: (newValue) {
            //     setState(() {
            //       baselineX = newValue;
            //     });
            //   },
            //   min: -10,
            //   max: 10,
            // ),
          ],
        ),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  final double baselineX;
  final double baselineY;

  const _Chart(this.baselineX, this.baselineY) : super();

  Widget getTTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineX).abs() <= 0.1) {
      style = const TextStyle(
        color: Color(0xff303030),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 14,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text('B', style: style),
      // child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getBTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineX).abs() <= 0.1) {
      style = const TextStyle(
        color: Color(0xff303030),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 14,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text('D', style: style),
      // child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getLTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineY).abs() <= 0.1) {
      style = const TextStyle(
        color: Color(0xff303030),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Text('C', style: style),
      // child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getRTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineY).abs() <= 0.1) {
      style = const TextStyle(
        color: Color(0xff303030),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Text('A', style: style),
      // child: Text(meta.formattedValue, style: style),
    );
  }

  FlLine getHorizontalVerticalLine(double value) {
    if ((value - baselineY).abs() <= 0.1) {
      return FlLine(
        color: Color(0xff576778),
        strokeWidth: 2,
        // dashArray: [8, 4],
      );
    } else {
      return FlLine(
        color: Color.fromARGB(176, 230, 231, 233),
        strokeWidth: 1,
        // dashArray: [8, 4],
      );
    }
  }

  FlLine getVerticalVerticalLine(double value) {
    if ((value - baselineX).abs() <= 0.1) {
      return FlLine(
        color: Color(0xff576778),
        strokeWidth: 2,
        // dashArray: [8, 4],
      );
    } else {
      return FlLine(
        color: Color.fromARGB(176, 230, 231, 233),
        strokeWidth: 1,
        // dashArray: [8, 4],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = context.watch<DataAddProvider>();
    // UPPER
    final upper = d.upper;
    final upperCrockedLine = d.upperCrockedLine;

    double getBiggestXY() {
      double upper0 = upper[0];
      double upper1 = upper[1];
      double result = 0;
      if (upper0 < 1) upper0 * (-1);
      if (upper1 < 1) upper1 * (-1);
      if (upper0 <= upper1)
        result = upper1;
      else
        result = upper0;
      return upper0;
    }

    double getBiggestScale(double value) {
      double val = value;
      if (value < 1) {
        val = val * (-1);
      }
      if (val > 0 && val <= 5) val = val;
      if (val > 5 && val <= 10)
        val = val * 10;
      else if (val > 10 && val <= 100)
        val = val * 50;
      else if (val > 100 && val <= 1000)
        val = val * 500;
      else if (val > 1000 && val <= 10000)
        val = val * 5000;
      else if (val > 10000 && val <= 100000)
        val = val * 50000;
      else if (val > 100000 && val <= 1000000)
        val = val * 500000;
      else if (val > 1000000 && val <= 10000000) val = val * 5000000;
      return val + 1;
    }

    log("GET BIGGEST XY ${getBiggestXY()}");
    log("GET BIGGEST SCALE ${getBiggestScale(getBiggestXY())}");

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final textStyle = TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                );
                return LineTooltipItem(
                  '${touchedSpot.x.toStringAsFixed(0)},${touchedSpot.y.toStringAsFixed(0)}',
                  textStyle,
                );
              }).toList();
            },
            tooltipBgColor: Constant.primaryColor,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            barWidth: 4,
            show: true,
            spots: [
              FlSpot(upper[0], upper[1]),
              FlSpot(0, 0),
            ],
            belowBarData: BarAreaData(show: false),
            color: Colors.green,
            dotData: FlDotData(show: true),
          ),
          // LineChartBarData(
          //   barWidth: 2,
          //   show: true,
          //   spots: [
          //     FlSpot(upperCrockedLine, 0),
          //     // FlSpot(0, 0),
          //   ],
          //   belowBarData: BarAreaData(show: false),
          //   color: Colors.red,
          //   dotData: FlDotData(show: true),
          // ),
        ],
        // betweenBarsData: [BetweenBarsData(fromIndex: 0, toIndex: 2)],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getLTitles,
              reservedSize: 24,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getTTitles,
                reservedSize: 28),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getRTitles,
              reservedSize: 24,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBTitles,
                reservedSize: 24),
          ),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: Color(0xffE6E7E9B0))),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: getHorizontalVerticalLine,
          getDrawingVerticalLine: getVerticalVerticalLine,
        ),
        // minY: -10,
        // maxY: 10,
        // minX: -10,
        // maxX: 10,
        minY: -getBiggestScale(getBiggestXY()) - 0.5,
        maxY: getBiggestScale(getBiggestXY()) + 0.5,
        minX: -getBiggestScale(getBiggestXY()) - 0.5,
        maxX: getBiggestScale(getBiggestXY()) + 0.5,
        baselineX: baselineX,
        baselineY: baselineY,
      ),
      duration: Duration.zero,
    );
  }
}
