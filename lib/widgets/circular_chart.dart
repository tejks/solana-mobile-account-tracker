import 'package:flutter/material.dart';
import 'package:solana_mobile_account_tracker/models/token.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final colors = [
  Colors.green[400],
  Colors.green[300],
  Colors.green[200],
  Colors.green[100],
];

final colors2 = [
  Colors.blue[400],
  Colors.green[300],
  Colors.red[200],
];

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
        chartData.add(_PieData(token.symbol, data, token.symbol));
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
      child: Container(
        height: 200,
        width: 200,
        child: SfCircularChart(
          margin: const EdgeInsets.all(0),
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
              pointColorMapper: (_PieData data, index) {
                return colors2[index];
              },
            ),
          ],
        ),
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
