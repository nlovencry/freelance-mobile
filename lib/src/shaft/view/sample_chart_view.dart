import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SampleChartView extends StatefulWidget {
  const SampleChartView({super.key});

  @override
  State<SampleChartView> createState() => _SampleChartViewState();
}

class _SampleChartViewState extends State<SampleChartView> {
  var baselineX = 0.0;
  var baselineY = 0.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0, right: 0.0),
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

  const _Chart(this.baselineX, this.baselineY) : super();

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
      child: Text('A', style: style),
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
      child: Text('D', style: style),
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
      child: Text('B', style: style),
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
      child: Text('C', style: style),
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
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 6),
              FlSpot(1, 0),
              FlSpot(1, 0),
              FlSpot(2, -6),
            ],
            color: Color(0xffFABB00),
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            barWidth: 5,
            spots: [
              FlSpot(0, 6),
              FlSpot(0, 0),
              FlSpot(0, 0),
              FlSpot(2, -6),
            ],
            color: Color(0xff9E9E9E),
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
        minY: -10,
        maxY: 10,
        baselineY: baselineY,
        minX: -10,
        maxX: 10,
        baselineX: baselineX,
      ),
      duration: Duration.zero,
    );
  }
}
