class Token {
  Token({
    required this.address,
    required this.mint,
    required this.decimals,
    required this.name,
    required this.symbol,
    required this.logoURI,
    required this.amount,
    required this.amountWithDecimals,
  });

  String address;
  String mint;
  int decimals;
  String name;
  String symbol;
  String logoURI;
  BigInt amount;
  double amountWithDecimals;

  Token.copy(Token token)
      : address = token.address,
        mint = token.mint,
        decimals = token.decimals,
        name = token.name,
        symbol = token.symbol,
        logoURI = token.logoURI,
        amount = token.amount,
        amountWithDecimals = token.amountWithDecimals;
}
