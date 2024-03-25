import 'package:flutter/material.dart';
import 'package:solana_mobile_account_tracker/screens/token_list_screen.dart';

import '../models/token.dart';
import '../services/short_pubkey.dart';

class TokenList extends StatefulWidget {
  const TokenList({super.key, required this.tokens, required this.tokenPrices});

  final List<Token> tokens;
  final Map<String, double> tokenPrices;

  @override
  State<TokenList> createState() => _TokenListState();
}

class _TokenListState extends State<TokenList> {
  @override
  void initState() {
    sortTokensByPrice();
    super.initState();
  }

  getFromatedName(Token token) {
    if (token.name.length > 23) {
      return '${token.name.substring(0, 23)}...';
    } else {
      return token.name;
    }
  }

  getFormatedAmount(Token token) {
    final result = token.amountWithDecimals;

    if (result >= 1000000000) {
      return '${(result / 1000000000).toStringAsFixed(2)}B';
    } else if (result >= 1000000) {
      return '${(result / 1000000).toStringAsFixed(2)}M';
    } else {
      return result.toStringAsFixed(6);
    }
  }

  getUsdAmount(Token token, double tokenPrice) {
    final result = token.amountWithDecimals * tokenPrice;

    if (result < 0.01) {
      return '<0.01';
    } else {
      return result.toStringAsFixed(2);
    }
  }

  sortTokensByPrice() {
    widget.tokens.sort((a, b) {
      final aPrice = widget.tokenPrices[a.mint]!;
      final bPrice = widget.tokenPrices[b.mint]!;

      final aTokenPrice = a.amountWithDecimals * aPrice;
      final bTokenPrice = b.amountWithDecimals * bPrice;

      return bTokenPrice.compareTo(aTokenPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.tokens.length > 3 ? 3 : widget.tokens.length,
            (index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.tokens[index].logoURI,
              ),
            ),
            title: Text(
              getFromatedName(widget.tokens[index]),
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              shortPubkey(widget.tokens[index].mint),
              style: const TextStyle(fontSize: 11),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  getFormatedAmount(widget.tokens[index]),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${getUsdAmount(widget.tokens[index], widget.tokenPrices[widget.tokens[index].mint]!)}\$',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
        widget.tokens.length > 3
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TokenListScreen(
                        tokenPrices: widget.tokenPrices,
                        tokens: widget.tokens,
                      ),
                    ),
                  );
                },
                child: Text('--- Show ${widget.tokens.length} more ---'),
              )
            : const SizedBox(),
      ],
    );
  }
}
