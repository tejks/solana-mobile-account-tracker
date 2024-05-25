import 'package:flutter/material.dart';
import 'package:solana_mobile_account_tracker/widgets/text_input.dart';

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
    return Padding(
      padding: const EdgeInsets.all(40.0),
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
            ),
          ],
        ),
      ),
    );
  }
}

// context.read<AccountsCubit>().addAccount(
//         SingleAccount(addressController.text, nameController.text));