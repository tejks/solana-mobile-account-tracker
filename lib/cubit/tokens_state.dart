part of 'tokens_cubit.dart';

@immutable
sealed class TokensState {}

final class TokensInitial extends TokensState {}

final class TokensLoading extends TokensState {}

final class TokensLoaded extends TokensState {
  final Map<String, List<Token>> tokens;
  final Map<String, double> priceFeed;

  TokensLoaded(this.tokens, this.priceFeed);

  double getTokenPriceByTokenAddress(String tokenAddress) {
    return priceFeed[tokenAddress]!;
  }

  List<Token> getTokensByLocalAccount(LocalAccount account) {
    if (account is SingleAccount) {
      return tokens[account.address] ?? [];
    } else if (account is AllAccounts) {
      Map<String, Token> repitation = {};

      for (var account in account.accounts) {
        final tokensByAccount = tokens[account.address] ?? [];
        for (var token in tokensByAccount) {
          if (repitation.containsKey(token.mint)) {
            repitation[token.mint]!.amountWithDecimals +=
                token.amountWithDecimals;
          } else {
            repitation[token.mint] = Token.copy(token);
          }
        }
      }

      return repitation.values.toList();
    } else {
      throw Exception('Unknown account type');
    }
  }

  List<Token> getStableTokensByLocalAccount(LocalAccount account) {
    final tokens = getTokensByLocalAccount(account);
    final List<Token> stableCoins = [];
    for (var token in tokens) {
      if (token.symbol == 'USDC' ||
          token.symbol == 'USDT' ||
          token.symbol == 'DAI' ||
          token.symbol == 'BUSD') {
        stableCoins.add(token);
      }
    }
    return stableCoins;
  }

  double getAccountTotalValueInUSD(LocalAccount account) {
    if (account is SingleAccount) {
      return getSingleAccountTotalValueInUSD(account);
    } else if (account is AllAccounts) {
      return getAllAccountsTotalValueInUSD(account);
    } else {
      throw Exception('Unknown account type');
    }
  }

  double getSingleAccountTotalValueInUSD(SingleAccount account) {
    final tokens = getTokensByLocalAccount(account);
    return tokens.fold<double>(
      0,
      (previousValue, element) =>
          previousValue +
          element.amountWithDecimals *
              getTokenPriceByTokenAddress(element.mint),
    );
  }

  double getAllAccountsTotalValueInUSD(AllAccounts allAccounts) {
    final tokens = getTokensByLocalAccount(allAccounts);
    return tokens.fold<double>(
      0,
      (previousValue, element) =>
          previousValue +
          element.amountWithDecimals *
              getTokenPriceByTokenAddress(element.mint),
    );
  }
}

final class TokensError extends TokensState {
  final String message;

  TokensError(this.message);
}
