import 'package:flutter/material.dart';

class DropdownFormField extends StatelessWidget {
  final String labelText;
  final List<String>? options;
  final String? selectedOption;
  final ValueChanged<String?>? onChanged;

  const DropdownFormField({
    Key? key,
    required this.labelText,
     this.options,
     this.selectedOption,
     this.onChanged, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedOption,
          onChanged: onChanged,
          items: options?.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFA1F0F2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xFFA1F0F2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xFF008A90)),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
