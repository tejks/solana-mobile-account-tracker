import 'package:flutter/material.dart';
import 'package:solana_mobile_account_tracker/widgets/gradient_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientText(
            'ST',
            style: TextStyle(
              fontSize: 180,
              fontWeight: FontWeight.w500,
            ),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 134, 71, 177),
                Color.fromARGB(255, 72, 19, 107),
              ],
            ),
          ),
          Text(
            'Welcome to Solana Tracker',
            style: TextStyle(
              color: Color.fromARGB(255, 83, 83, 83),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
