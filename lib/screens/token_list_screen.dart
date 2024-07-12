import 'package:flutter/material.dart';
import 'package:solana_mobile_account_tracker/models/token.dart';
import 'package:solana_mobile_account_tracker/widgets/scrollable_token_list.dart';

class TokenListScreen extends StatelessWidget {
  const TokenListScreen(
      {super.key, required this.tokens, required this.tokenPrices});

  final List<Token> tokens;
  final Map<String, double> tokenPrices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Collections',
          style: TextStyle(color: Colors.grey[700]),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.grey[700]),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ScrollableTokenList(tokens: tokens, tokenPrices: tokenPrices),
      ),
    );
  }
}
