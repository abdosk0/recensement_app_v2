import 'package:flutter/material.dart';
import 'package:recensement_app_test/widgets/date_form_field.dart';
import 'package:recensement_app_test/widgets/dropdown_form_field.dart';
import 'package:recensement_app_test/widgets/multi_selection_form_field.dart';
import 'package:recensement_app_test/widgets/nombre_form_field.dart';
import 'package:recensement_app_test/widgets/radio_form_field.dart';
import 'package:recensement_app_test/widgets/textFieldWidget.dart';
import '../models/indicateur.dart';
// Import other custom widgets for different types as needed

class DynamicIndicatorItem extends StatelessWidget {
  final Indicateur indicateur;

  const DynamicIndicatorItem({super.key, required this.indicateur});

  @override
  Widget build(BuildContext context) {
    if (indicateur.objectIndicateur == 'Ménage') {
      switch (indicateur.type) {
        case 'Text':
          return TextFieldWidget(
            labelText: indicateur.nomIndicateur,
            controller: TextEditingController(),
          );
        case 'Nombre':
          return NombreFormField(
            labelText: indicateur.nomIndicateur,
            controller: TextEditingController(),
          );
        case 'Dropdown':
          return DropdownFormField(labelText: indicateur.nomIndicateur);
        case 'Radio':
          return RadioFormField(label: indicateur.nomIndicateur);
        case 'Date':
          return DateFormField(
            label: indicateur.nomIndicateur,
            controller: TextEditingController(),
          );
        case 'Multiselection':
          return MultiSelectionFormField(label: indicateur.nomIndicateur);
        default:
          return Container(); // Placeholder for unsupported types
      }
    } else {
      return Container(); // Placeholder for indicators not related to "Menage"
    }
  }
}
