import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Color.fromARGB(255, 84, 93, 95),
        fontSize: 13,
      ),
      decoration: InputDecoration(
        // hintText: hintText,
        label: Text(hintText),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 84, 93, 95),
          fontSize: 13,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 84, 93, 95),
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 112, 37, 161),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
