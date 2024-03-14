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

  const DynamicIndicatorItem({Key? key, required this.indicateur})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        final firstOption = indicateur.valeursPossibles.isNotEmpty
            ? indicateur.valeursPossibles.first.nomValeur
            : null;
        return DropdownFormField(
          label: indicateur.nomIndicateur,
          selectedOption: firstOption,
          onChanged: (String? value) {
            // Handle dropdown value change here
          },
          valeursPossibles: indicateur.valeursPossibles,
        );
      case 'Radio':
        final firstOption = indicateur.valeursPossibles.isNotEmpty
            ? indicateur.valeursPossibles.first.nomValeur
            : null;
        return RadioFormField(
          label: indicateur.nomIndicateur,
          selectedOption: firstOption,
          onChanged: (String? value) {
            // Handle radio button value change here
          },
          valeursPossibles: indicateur.valeursPossibles,
        );
      case 'Date':
        return DateFormField(
          label: indicateur.nomIndicateur,
          controller: TextEditingController(),
        );
      case 'Multiselection':
        return MultiSelectionFormField(
          label: indicateur.nomIndicateur,
          selectedOptions: [], // Provide initial selected options here
          onChanged: (List<String> value) {
            // Handle multi-selection value change here
          },
          valeursPossibles: indicateur.valeursPossibles,
        );
      default:
        return Container(); // Placeholder for unsupported types
    }
  }
}
