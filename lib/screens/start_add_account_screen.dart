import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/models/local_account.dart';
import 'package:solana_mobile_account_tracker/widgets/input.dart';

import '../widgets/gradient_button.dart';

class StartAddAccountScreen extends StatefulWidget {
  const StartAddAccountScreen({super.key});

  @override
  State<StartAddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<StartAddAccountScreen> {
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Add new account".toUpperCase(),
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                color: Colors.grey[900]!,
                letterSpacing: .1,
                fontSize: 20,
              ),
            ),
          ),
          Input(hintText: "Address", controller: addressController),
          Container(
            child: Center(
              child: GradientButton(
                onPressed: () {
                  context.read<AccountsCubit>().addAccount(
                        LocalAccount(addressController.text, "Wallet 1"),
                      );

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                text: "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
