import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/screens/home_screen.dart';
import 'package:solana_mobile_account_tracker/screens/start_add_account_screen.dart';

import '../widgets/gradient_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    context.read<AccountsCubit>().loadAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: BlocBuilder<AccountsCubit, AccountsState>(
        builder: (context, state) {
          if (state is AccountsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AccountsLoaded) {
            print("Accounts: ${state.accounts}");
            if (state.accounts.isNotEmpty) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              );
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: Text(
                  "Welcome to Solana Wallet",
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: GradientButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartAddAccountScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    text: "Next",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
