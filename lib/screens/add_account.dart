import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/screens/splash_screen.dart';
import 'package:solana_mobile_account_tracker/widgets/text_input.dart';

class AddAccountScreen2 extends StatefulWidget {
  const AddAccountScreen2({super.key});

  @override
  State<AddAccountScreen2> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen2> {
  final addressController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Account",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.diamond,
                size: 100,
                color: Color.fromARGB(255, 112, 37, 161),
              ),
              const SizedBox(height: 40),
              const Text("Import your wallet", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              TextInput(
                hintText: "Wallet name",
                controller: nameController,
              ),
              const SizedBox(height: 25),
              TextInput(
                hintText: "Wallet address",
                controller: addressController,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 206, 205, 205),
                ),
                onPressed: () {
                  context.read<AccountsCubit>().addAccount(
                        SingleAccount(
                          addressController.text,
                          nameController.text,
                        ),
                      );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                },
                child: const Text("Import"),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
