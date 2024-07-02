import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/helper/constant.dart';
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
      padding: const EdgeInsets.all(0),
      child: Text('', style: style),
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
      padding: const EdgeInsets.all(0),
      child: Text('', style: style),
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
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        activeIndex == 0 ? 'A' : 'B',
        style: style,
        textAlign: TextAlign.right,
      ),
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
      padding: const EdgeInsets.only(left: 3, right: 4),
      child: Text(activeIndex == 0 ? 'C' : 'D', style: style),
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
    // AC
    final acUpper = d.acUpper;
    final acClutch = d.acClutch;
    final acTurbine = d.acTurbine;
    final acCrockedLine = d.acCrockedLine;
    // BD
    final bdUpper = d.bdUpper;
    final bdClutch = d.bdClutch;
    final bdTurbine = d.bdTurbine;
    final bdCrockedLine = d.bdCrockedLine;

    double getPlusY() {
      if (activeIndex == 1) return bdUpper[1];
      return bdUpper[1];
    }

    double getMinY() {
      if (activeIndex == 1) return bdTurbine[1];
      return bdTurbine[1];
    }

    double getYBiggest() {
      if (getPlusY() > (getMinY() * (-1))) return getPlusY();
      return (getMinY() * (-1));
    }

    double getXBiggest() {
      double biggest = 0;
      double bdUpper0 = bdUpper[0] < 0 ? (bdUpper[0] * (-1)) : bdUpper[0];
      double acUpper0 = acUpper[0] < 0 ? (acUpper[0] * (-1)) : acUpper[0];
      double bdClutch0 = bdClutch[0] < 0 ? (bdClutch[0] * (-1)) : bdClutch[0];
      double acClutch0 = acClutch[0] < 0 ? (acClutch[0] * (-1)) : acClutch[0];
      double bdTurbine0 =
          bdTurbine[0] < 0 ? (bdTurbine[0] * (-1)) : bdTurbine[0];
      double acTurbine0 =
          acTurbine[0] < 0 ? (acTurbine[0] * (-1)) : acTurbine[0];
      if (activeIndex == 1) {
        if (bdUpper0 <= bdClutch0) biggest = bdClutch0;
        if (bdClutch0 <= bdTurbine0) biggest = bdTurbine0;
      } else {
        if (acUpper0 <= acClutch0) biggest = acClutch0;
        if (acClutch0 <= acTurbine0) biggest = acTurbine0;
      }
      return biggest;
    }

    double getPlusX() {
      if (activeIndex == 1) return bdUpper[1];
      return bdUpper[0];
    }

    double getBottomY() {
      if (activeIndex == 1) return bdTurbine[1];
      return bdTurbine[0];
    }

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

    FlSpot getCrockedLine() {
      if (activeIndex == 1)
        return FlSpot(bdClutch[0] < 0 ? -bdCrockedLine : bdCrockedLine, 0);
      return FlSpot(acClutch[0] < 0 ? -acCrockedLine : acCrockedLine, 0);
    }

    if (acClutch.isEmpty) return SizedBox();
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: false,
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
            barWidth: 10,
            spots: [
              getFlSpotUpper(),
              getFlSpotClutch(),
              getFlSpotClutch(),
              getFlSpotTurbine(),
            ],
            color: Color(0xff9D9D9D),
            dotData: FlDotData(
              show: true,
              getDotPainter: (p0, p1, p2, p3) {
                return FlDotSquarePainter(
                  size: 20,
                  color: Color(0xff7B7B7B),
                  strokeColor: Color(0xff97B7B7B),
                );
              },
            ),
          ),
          LineChartBarData(
            barWidth: 4,
            spots: [
              getFlSpotYellowTop(),
              getFlSpotYellowBottom(),
            ],
            color: Color(0xffFBBB00),
            dotData: FlDotData(show: false),
          ),
          // LineChartBarData(
          //   barWidth: 4,
          //   spots: [getFlSpotClutch(), getCrockedLine()],
          //   color: Colors.red,
          //   dotData: FlDotData(show: false),
          // ),
        ],
        // betweenBarsData: [BetweenBarsData(fromIndex: 0, toIndex: 2)],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getLTitles,
              reservedSize: 16,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getRTitles,
              reservedSize: 16,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true, getTitlesWidget: getTTitles, reservedSize: 0),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true, getTitlesWidget: getBTitles, reservedSize: 0),
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
        minY: (-(getYBiggest())) - 1,
        maxY: getYBiggest() + 1,
        baselineY: baselineY,
        minX: (-(getXBiggest())) - 1,
        maxX: (getXBiggest() + 1),
        baselineX: baselineX,
      ),
      duration: Duration.zero,
    );
  }
}
