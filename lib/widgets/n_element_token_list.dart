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
    } else if (result >= 1) {
      return result.toStringAsFixed(2);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 5, top: 3, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collections',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
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
                child: Row(
                  children: [
                    Text(
                      'View all',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    Icon(Icons.arrow_right, color: Colors.grey[400])
                  ],
                ),
              ),
            ],
          ),
        ),
        ...List.generate(widget.tokens.length > 3 ? 3 : widget.tokens.length,
            (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.tokens[index].logoURI,
                ),
              ),
              title: Text(
                getFromatedName(widget.tokens[index]),
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              subtitle: Text(
                shortPubkey(widget.tokens[index].mint),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getFormatedAmount(widget.tokens[index]),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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
            ),
          );
        })
      ],
    );
  }
}
