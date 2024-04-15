import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/cubit/tokens_cubit.dart';
import 'package:solana_mobile_account_tracker/screens/home_screen.dart';
import 'package:solana_mobile_account_tracker/screens/onbording/onbording.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    context.read<AccountsCubit>().loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: MultiBlocListener(
        listeners: [
          BlocListener<AccountsCubit, AccountsState>(
            listener: (context, state) {
              if (state is AccountsLoaded) {
                if (state.accounts.isNotEmpty) {
                  context.read<TokensCubit>().loadTokens(
                        state.accounts
                            .whereType<SingleAccount>()
                            .map((e) => e.address)
                            .toList(),
                      );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Onbording(),
                    ),
                  );
                }
              }
            },
          ),
          BlocListener<TokensCubit, TokensState>(
            listener: (context, state) {
              if (state is TokensLoaded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              }
            },
          ),
        ],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to Solana Wallet",
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
