import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:recensement_app_test/pages/listFamille.dart';
import 'package:recensement_app_test/widgets/customAppBar.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/databaseHelper.dart';
import '../models/famille.dart';
import '../widgets/textFieldWidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class FamilleForm extends StatefulWidget {
  final int menageId;
  final int numberOfFamilies;

  const FamilleForm({
    super.key,
    required this.menageId,
    required this.numberOfFamilies,
  });

  @override
  _FamilleFormState createState() => _FamilleFormState();
}

class _FamilleFormState extends State<FamilleForm> {
  List<String> _familyNames = [];
  List<Famille> _families = [];
  final TextEditingController _nomFamilleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _families = []; // Initialize _families list
  }

  void _addFamilyName() {
    if (_familyNames.length < widget.numberOfFamilies) {
      if (_nomFamilleController.text.isNotEmpty) {
        final familyName = _nomFamilleController.text;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: 'Nom de famille ajouter !',
              contentType: ContentType.success,
            ),
          ),
        );
        if (!_familyNames.contains(familyName)) {
          // Check if the name already exists
          _familyNames.add(familyName);
          _nomFamilleController.clear();
          setState(() {});
        } else {
          // Show error message for duplicate name
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Nom de famille déjà ajouté',
            desc: 'Le nom de famille "$familyName" a déjà été ajouté.',
            btnOkText: 'OK',
            btnOkOnPress: () {},
          ).show();
        }
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Nombre maximum de familles atteintes',
        desc: 'Vous avez atteint le nombre maximum de familles autorisées.',
        btnOkText: 'OK',
        btnOkOnPress: () {},
      ).show();
    }
  }

  void _saveFamilies(BuildContext context) async {
    if (_familyNames.length < widget.numberOfFamilies) {
      _showErrorDialog(context,
          'Vous devez entrer au moins ${widget.numberOfFamilies} noms de famille.');
      return;
    }

    if (_familyNames.length > widget.numberOfFamilies) {
      _showErrorDialog(context,
          'Vous avez entré plus de ${widget.numberOfFamilies} noms de famille.');
      return;
    }

    try {
      final database = await DatabaseHelper.database;
      _familyNames.forEach((familyName) async {
        final famille = Famille(
          nom: familyName,
          menage_id: widget.menageId,
        );
        final id = await database.insert(
          'Famille',
          famille.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        final familleWithId = Famille.withId(
          id_famille: id,
          nom: famille.nom,
          menage_id: famille.menage_id,
        );
        _families.add(familleWithId); // Add the Famille object to the list
      });
      _showSuccessDialog(context);
    } catch (e) {
      _showErrorDialog(
          context, 'Erreur lors de l\'enregistrement des familles');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Succès',
      desc: 'Les familles ont été ajoutées avec succès.',
      btnOkText: 'OK',
      btnOkOnPress: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListFamille(
              families: _families,
            ),
          ),
        );
      },
      dismissOnTouchOutside: false,
    ).show();
  }

  void _showErrorDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Erreur',
      desc: message,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Nom de famille"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFieldWidget(
              controller: _nomFamilleController,
              labelText: 'Entrer le(s) nom(s) de famille(s)',
            ),
          ),
          ElevatedButton(
            onPressed: _addFamilyName,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA1F0F2),
              fixedSize: Size(200, 50),
            ),
            child: const Text(
              'Ajouter nom de famille',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _saveFamilies(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA1F0F2),
              fixedSize: Size(200, 50),
            ),
            child: const Text(
              'Sauvegarder les familles',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
