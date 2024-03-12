import 'package:flutter/material.dart';

class MultiSelectionFormField extends StatefulWidget {
  final String label;
  final List<String>? options;
  final List<String>? selectedOptions;
  final ValueChanged<List<String>>? onChanged;

  const MultiSelectionFormField({
    Key? key,
    required this.label,
     this.options,
     this.selectedOptions,
     this.onChanged,
  }) : super(key: key);

  @override
  _MultiSelectionFormFieldState createState() => _MultiSelectionFormFieldState();
}

class _MultiSelectionFormFieldState extends State<MultiSelectionFormField> {
  List<String> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.options!.map((option) {
            return FilterChip(
              label: Text(option),
              selected: _selectedOptions.contains(option),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedOptions.add(option);
                  } else {
                    _selectedOptions.remove(option);
                  }
                  widget.onChanged!(_selectedOptions);
                });
              },
              selectedColor: Color(0xFFA1F0F2),
              backgroundColor: Color(0xFF008A90),
              labelStyle: TextStyle(color: Colors.black),
              checkmarkColor: Colors.black,
            );
          }).toList(),
        ),
      ],
    );
  }
}
