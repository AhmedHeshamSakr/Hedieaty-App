import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final FocusNode focusNode;
  final String hintText;
  final Function(String)? onChanged;  // Add this line


  const CustomInputField({
    super.key,
    required this.focusNode,
    required this.hintText, this.onChanged,
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
        onChanged: onChanged,  // Add this line
      ),
    );
  }
}