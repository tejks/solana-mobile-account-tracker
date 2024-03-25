import 'package:flutter/material.dart';
import 'package:solana_mobile_account_tracker/models/token.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircularChart extends StatelessWidget {
  const CircularChart(
      {super.key, required this.tokens, required this.tokenPrices});

  final List<Token> tokens;
  final Map<String, double> tokenPrices;

  List<_PieData> getChartData() {
    final List<_PieData> chartData = [];
    final sum = tokens.fold<double>(
      0,
      (previousValue, element) =>
          previousValue +
          element.amountWithDecimals * tokenPrices[element.mint]!,
    );
    var otherAmount = 0.0;

    for (var token in tokens) {
      final data = token.amountWithDecimals * tokenPrices[token.mint]!;
      if (data / sum < 0.05) {
        otherAmount += data;
      } else {
        chartData.add(_PieData(token.name, data, token.name));
      }
    }

    if (otherAmount > 0) {
      chartData.add(_PieData('Other', otherAmount, 'Other'));
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfCircularChart(
        legend: const Legend(isVisible: true, toggleSeriesVisibility: true),
        series: <PieSeries<_PieData, String>>[
          PieSeries<_PieData, String>(
            animationDuration: 400,
            dataSource: getChartData(),
            xValueMapper: (_PieData data, _) => data.xData,
            yValueMapper: (_PieData data, _) => data.yData,
            dataLabelMapper: (_PieData data, _) => data.text,
            legendIconType: LegendIconType.seriesType,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            // opacity: 0.7,
          ),
        ],
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  String? text;
}
