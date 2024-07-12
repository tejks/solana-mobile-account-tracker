import 'package:flutter/material.dart';
import 'package:solana_mobile_account_tracker/models/token.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final colors = [
  const Color.fromRGBO(42, 38, 95, 1),
  const Color.fromRGBO(60, 61, 153, 1),
  const Color.fromRGBO(87, 82, 209, 1),
  const Color.fromRGBO(132, 129, 221, 1),
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
        chartData.add(
          _PieData(
              token.symbol, data, '${(data / sum * 100).toStringAsFixed(2)}%'),
        );
      }
    }

    if (otherAmount > 0) {
      chartData.add(
        _PieData('Other', otherAmount,
            '${(otherAmount / sum * 100).toStringAsFixed(2)}%'),
      );
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 270,
        width: 250,
        child: SfCircularChart(
          margin: const EdgeInsets.all(10),
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom,
          ),
          series: <PieSeries<_PieData, String>>[
            PieSeries<_PieData, String>(
              animationDuration: 400,
              dataSource: getChartData(),
              xValueMapper: (_PieData data, _) => data.xData,
              yValueMapper: (_PieData data, _) => data.yData,
              dataLabelMapper: (_PieData data, _) => data.text,
              legendIconType: LegendIconType.diamond,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve,
                  width: 1,
                ),
                overflowMode: OverflowMode.shift,
                showZeroValue: false,
                color: Colors.white,
                borderRadius: 20,
                borderWidth: 5,
                borderColor: Colors.white,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              pointColorMapper: (_PieData data, index) {
                return colors[index];
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
