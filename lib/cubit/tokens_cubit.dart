import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/models/local_account.dart';
import 'package:solana_mobile_account_tracker/models/token.dart';
import 'package:solana_mobile_account_tracker/models/token_account.dart';
import 'package:solana_mobile_account_tracker/models/token_metadata.dart';

part 'tokens_state.dart';

class TokensCubit extends Cubit<TokensState> {
  TokensCubit() : super(TokensInitial());

  void loadTokens(List<String> accounts) async {
    emit(TokensLoading());

    final String response = await rootBundle.loadString('assets/tokens.json');
    final tokensMetadataMap = jsonDecode(response) as List<dynamic>;

    final tokensMetadata =
        tokensMetadataMap.map((e) => TokenMetadata.fromJson(e)).toList();

    final client = SolanaClient(
      rpcUrl: Uri.parse(""),
      websocketUrl: Uri.parse(""),
    );

    Map<String, List<Token>> tokens = {};
    Map<String, double> tokenPrices = {};

    final tokenAccountFuture = accounts.map((accountPubkey) async {
      List<Token> tokensResult = [];

      final solBalance =
          (await client.rpcClient.getBalance(accountPubkey)).value;

      tokensResult.add(Token(
        address: accountPubkey,
        mint: tokensMetadata[0].address,
        name: tokensMetadata[0].name,
        symbol: tokensMetadata[0].symbol,
        logoURI: tokensMetadata[0].logoURI,
        decimals: tokensMetadata[0].decimals,
        amount: BigInt.from(solBalance),
        amountWithDecimals: solBalance / pow(10, tokensMetadata[0].decimals),
      ));

      final tokenAccounts = await client.rpcClient
          .getTokenAccountsByOwner(
            accountPubkey,
            const TokenAccountsFilter.byProgramId(TokenProgram.programId),
            encoding: Encoding.base64,
          )
          .value;

      for (var account in tokenAccounts) {
        final tokenAccountBytes = account.account.data as BinaryAccountData;
        final tokenAccountData =
            TokenAccount.fromBorsh(tokenAccountBytes.data as Uint8List);

        if (tokenAccountData.amount == BigInt.zero) continue;

        final tokenMetadata = tokensMetadata.indexWhere(
            (element) => element.address == tokenAccountData.mint.toString());

        if (tokenMetadata == -1) continue;

        tokensResult.add(Token(
          address: account.pubkey,
          mint: tokensMetadata[tokenMetadata].address,
          name: tokensMetadata[tokenMetadata].name,
          symbol: tokensMetadata[tokenMetadata].symbol,
          logoURI: tokensMetadata[tokenMetadata].logoURI,
          decimals: tokensMetadata[tokenMetadata].decimals,
          amount: tokenAccountData.amount,
          amountWithDecimals: tokenAccountData.amount.toInt() /
              pow(10, tokensMetadata[tokenMetadata].decimals),
        ));
      }

      final priceFeedResponse = tokensResult
          .where((element) => tokenPrices[element.mint] == null)
          .map(
        (e) async {
          return http.get(
            Uri.parse('https://price.jup.ag/v6/price?ids=${e.mint}'),
          );
        },
      );

      final priceFeed = await Future.wait(priceFeedResponse);

      for (var i = 0; i < priceFeed.length; i++) {
        final response = priceFeed[i];

        if (response.statusCode == 200) {
          final jsonResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          var price = jsonResponse['data'][tokensResult[i].mint]['price'];
          tokenPrices[tokensResult[i].mint] = double.parse(price.toString());
        }
      }

      return tokensResult;
    });

    try {
      final tokenAccounts = await Future.wait(tokenAccountFuture);

      for (var i = 0; i < tokenAccounts.length; i++) {
        tokens[accounts[i]] = tokenAccounts[i];
      }

      emit(TokensLoaded(tokens, tokenPrices));
    } catch (e) {
      emit(TokensError(e.toString()));
    }
  }
}
