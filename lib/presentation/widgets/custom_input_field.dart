import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final FocusNode focusNode;
  final String hintText;

  const CustomInputField({
    super.key,
    required this.focusNode,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}