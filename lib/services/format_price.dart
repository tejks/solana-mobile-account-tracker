String formatPrice(BigInt amount, int decimals) {
  final BigInt amountWithDecimals = amount * BigInt.from(10).pow(decimals);
  final String formattedAmount = amountWithDecimals.toString();
  final String wholeNumber =
      formattedAmount.substring(0, formattedAmount.length - decimals);
  final String fraction =
      formattedAmount.substring(formattedAmount.length - decimals);

  if (wholeNumber.length >= 7 && wholeNumber.length <= 9) {
    final double value = double.parse(wholeNumber) / 1000000;
    return '${value.toStringAsFixed(2)}M';
  } else if (wholeNumber.length >= 10) {
    final double value = double.parse(wholeNumber) / 1000000000;
    return '${value.toStringAsFixed(2)}B';
  } else {
    return '$wholeNumber.$fraction';
  }
}
