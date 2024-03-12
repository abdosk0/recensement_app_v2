import 'package:flutter/material.dart';

class RadioFormField extends StatelessWidget {
  final String label;
  final List<String>? options;
  final ValueChanged<String?>? onChanged;
  final String? selectedOption;

  const RadioFormField({
    Key? key,
    required this.label,
     this.options,
     this.onChanged,
     this.selectedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 8),
        Column(
          children: options!.map((option) {
            return RadioListTile<String>(
              title: Text(
                option,
                style: TextStyle(color: Colors.black),
              ),
              value: option,
              groupValue: selectedOption,
              onChanged: onChanged,
              activeColor: Color(0xFFA1F0F2),
            );
          }).toList(),
        ),
      ],
    );
  }
}
