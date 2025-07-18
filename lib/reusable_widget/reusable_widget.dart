import 'package:flutter/material.dart';

TextField reusableTextField(
  String text,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller,
) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: const Color.fromARGB(255, 0, 0, 0),
    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0).withAlpha(150)),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: const Color.fromARGB(179, 0, 0, 0)),
      labelText: text,
      labelStyle: TextStyle(
        color: const Color.fromARGB(255, 0, 0, 0).withAlpha(150),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: const Color.fromARGB(154, 213, 209, 209).withAlpha(77),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
