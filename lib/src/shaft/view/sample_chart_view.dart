import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/provider/data_add_provider.dart';

class SampleChartView extends StatefulWidget {
  final int activeIndex;
  SampleChartView({super.key, required this.activeIndex});

  @override
  State<SampleChartView> createState() => _SampleChartViewState();
}

class _SampleChartViewState extends State<SampleChartView> {
  var baselineX = 0.0;
  var baselineY = 0.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
                    child: _Chart(
                      baselineX,
                      (20 - (baselineY + 10)) - 10,
                      widget.activeIndex,
                    ),
                  )
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
  final int activeIndex;

  const _Chart(this.baselineX, this.baselineY, this.activeIndex) : super();

  Widget getHorizontalTitles(value, TitleMeta meta) {
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
      padding: const EdgeInsets.all(4.0),
      child: Text('', style: style),
      // child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getHorizontalTitlesBottom(value, TitleMeta meta) {
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
      padding: const EdgeInsets.all(4.0),
      child: Text('', style: style),
      // child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getVerticalTitles(value, TitleMeta meta) {
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
      padding: const EdgeInsets.all(4.0),
      child: Text(activeIndex == 0 ? 'A' : 'B', style: style),
      // child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getVerticalTitlesRight(value, TitleMeta meta) {
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
      padding: const EdgeInsets.all(4.0),
      child: Text(activeIndex == 0 ? 'C' : 'D', style: style),
      // child: Text(meta.formattedValue, style: style),
    );
  }

  FlLine getHorizontalVerticalLine(double value) {
    if ((value - baselineY).abs() <= 0.1) {
      return FlLine(
        color: Color(0xff576778),
        strokeWidth: 1,
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
        strokeWidth: 1,
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
    // AC
    final acUpper = d.acUpper;
    final acClutch = d.acClutch;
    final acTurbine = d.acTurbine;
    // BD
    final bdUpper = d.bdUpper;
    final bdClutch = d.bdClutch;
    final bdTurbine = d.bdTurbine;
    // UPPER
    final upper = d.upper;

    FlSpot getFlSpotUpper() {
      if (activeIndex == 1) return FlSpot(bdUpper[0], bdUpper[1]);
      return FlSpot(acUpper[0], acUpper[1]);
    }

    FlSpot getFlSpotClutch() {
      if (activeIndex == 1) return FlSpot(bdClutch[0], bdClutch[1]);
      return FlSpot(acClutch[0], acClutch[1]);
    }

    FlSpot getFlSpotTurbine() {
      if (activeIndex == 1) return FlSpot(bdTurbine[0], bdTurbine[1]);
      return FlSpot(acTurbine[0], acTurbine[1]);
    }

    FlSpot getFlSpotYellowTop() {
      if (activeIndex == 1) return FlSpot(bdUpper[0], bdUpper[1]);
      return FlSpot(acUpper[0], acUpper[1]);
    }

    FlSpot getFlSpotYellowBottom() {
      if (activeIndex == 1) return FlSpot(bdTurbine[0], bdTurbine[1]);
      return FlSpot(acTurbine[0], acTurbine[1]);
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            barWidth: 1,
            spots: [
              getFlSpotYellowTop(),
              getFlSpotYellowBottom(),
            ],
            color: Color(0xffFABB00),
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            barWidth: 2,
            spots: [
              getFlSpotUpper(),
              getFlSpotClutch(),
              getFlSpotClutch(),
              getFlSpotTurbine(),
            ],
            color: Colors.green,
            dotData: FlDotData(show: false),
          ),
        ],
        // betweenBarsData: [BetweenBarsData(fromIndex: 0, toIndex: 2)],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getHorizontalTitles,
                reservedSize: 32),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitlesRight,
              reservedSize: 36,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getHorizontalTitlesBottom,
                reservedSize: 32),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: getHorizontalVerticalLine,
          getDrawingVerticalLine: getVerticalVerticalLine,
        ),
        minY: -5,
        maxY: 5,
        baselineY: baselineY,
        minX: -15,
        maxX: 15,
        baselineX: baselineX,
      ),
      duration: Duration.zero,
    );
  }
}
