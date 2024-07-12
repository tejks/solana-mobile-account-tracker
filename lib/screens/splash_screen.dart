import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/cubit/tokens_cubit.dart';
import 'package:solana_mobile_account_tracker/screens/home_screen.dart';
import 'package:solana_mobile_account_tracker/screens/onbording/onbording.dart';
import 'package:solana_mobile_account_tracker/widgets/gradient_text.dart';

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
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AccountsCubit, AccountsState>(
            listener: (context, state) async {
              if (state is AccountsLoaded) {
                if (state.accounts.isNotEmpty) {
                  context.read<TokensCubit>().loadTokens(
                        state.accounts
                            .whereType<SingleAccount>()
                            .map((e) => e.address)
                            .toList(),
                      );
                } else {
                  await Future.delayed(const Duration(seconds: 2));

                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientText(
                'ST',
                style: TextStyle(
                  fontSize: 190,
                  fontWeight: FontWeight.w500,
                ),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 134, 71, 177),
                    Color.fromARGB(255, 72, 19, 107),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
