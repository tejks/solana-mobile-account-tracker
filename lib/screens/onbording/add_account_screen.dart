import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/screens/splash_screen.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final addressController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Column(
          children: [
            const Text("Add Account"),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: "Enter Address",
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Enter Name",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AccountsCubit>().addAccount(
                    SingleAccount(addressController.text, nameController.text));

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()));
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
