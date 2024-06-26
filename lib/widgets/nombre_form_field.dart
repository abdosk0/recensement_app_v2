import 'package:flutter/material.dart';

class NombreFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Function(String)? onChanged;

  const NombreFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF008A90),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFA1F0F2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF008A90)),
            ),
            labelStyle: const TextStyle(color: Color(0xFFFFFFFF)),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          style: const TextStyle(color: Color(0xFFFFFFFF)),
        )
      ],
    );
  }
}
