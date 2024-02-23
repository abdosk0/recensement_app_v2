import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:recensement_app_test/models/personne.dart';
import 'package:recensement_app_test/pages/listFamille.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/databaseHelper.dart';
import '../models/famille.dart';
import '../widgets/customAppBar.dart';
import '../widgets/textFieldWidget.dart';

class ChildrenForm extends StatefulWidget {
  final int famille_id;
  final String fatherInfo;
  final String motherInfo;
  final int numberOfChildren;

  const ChildrenForm({
    Key? key,
    required this.famille_id,
    required this.fatherInfo,
    required this.motherInfo,
    required this.numberOfChildren,
  }) : super(key: key);

  @override
  _ChildrenFormState createState() => _ChildrenFormState();
}

class _ChildrenFormState extends State<ChildrenForm> {
  List<TextEditingController> _prenomControllers = [];
  List<TextEditingController> _nomControllers = [];
  List<TextEditingController> _sexeControllers = [];
  List<TextEditingController> _dateDeNaissanceControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers based on the number of children
    for (int i = 0; i < widget.numberOfChildren; i++) {
      _prenomControllers.add(TextEditingController());
      _nomControllers.add(TextEditingController(text: widget.fatherInfo));
      _sexeControllers.add(TextEditingController());
      _dateDeNaissanceControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Ajouter Enfants'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < widget.numberOfChildren; i++)
              _buildChildForm(i),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  saveChildren(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA1F0F2),
                  fixedSize: const Size(200, 50),
                ),
                child: const Text(
                  'Sauvegarder',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildForm(int index) {
    TextEditingController sexeController = _sexeControllers[index];
    TextEditingController dateDeNaissanceController =
        _dateDeNaissanceControllers[index];

    return Card(
      color: const Color(0xFFA1F0F2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enfant ${index + 1} :',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFieldWidget(
              controller: _prenomControllers[index],
              labelText: 'Prénom',
            ),
            TextFieldWidget(
              controller: _nomControllers[index],
              labelText: 'Nom',
              enabled: false,
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Homme',
                  groupValue: sexeController.text,
                  onChanged: (value) {
                    setState(() {
                      sexeController.text = value!;
                    });
                  },
                  activeColor: const Color(0xFF008A90),
                ),
                const Text('Homme'),
                Radio<String>(
                  value: 'Femme',
                  groupValue: sexeController.text,
                  onChanged: (value) {
                    setState(() {
                      sexeController.text = value!;
                    });
                  },
                  activeColor: const Color(0xFF008A90),
                ),
                const Text('Femme'),
              ],
            ),
            DateTimePicker(
              cursorColor: const Color(0xFF008A90),
              type: DateTimePickerType.date,
              controller: dateDeNaissanceController,
              dateMask: 'dd/MM/yyyy',
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              onChanged: (val) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Date de naissance',
                suffixIcon: Icon(Icons.event),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<List<Famille>> fetchFamiliesInMenage(int familleId) async {
    try {
      final database = await DatabaseHelper.database;
      List<Map<String, dynamic>> result = await database.rawQuery('''
      SELECT *
      FROM Famille
      WHERE menage_id = (
        SELECT menage_id
        FROM Famille
        WHERE id_famille = ?
      )
    ''', [familleId]);

      List<Famille> families =
          result.map((row) => Famille.fromMap(row)).toList();
      return families;
    } catch (e) {
      print('Error fetching families: $e');
      return [];
    }
  }

  void saveChildren(BuildContext context) async {
    List<Personne> childrenList = [];

    for (int i = 0; i < widget.numberOfChildren; i++) {
      if (_prenomControllers[i].text.isNotEmpty &&
          _nomControllers[i].text.isNotEmpty &&
          _sexeControllers[i].text.isNotEmpty &&
          _dateDeNaissanceControllers[i].text.isNotEmpty) {
        String prenom = _prenomControllers[i].text;
        String nom = _nomControllers[i].text;
        String sexe = _sexeControllers[i].text;
        String dateDeNaissance = _dateDeNaissanceControllers[i].text;

        Personne child = Personne(
          prenom: prenom,
          nom: nom,
          sexe: sexe,
          dateDeNaissance: DateTime.parse(dateDeNaissance),
          chefFamille: false,
          lienParente: 'Enfant',
          famille_id: widget.famille_id,
        );

        childrenList.add(child);
      } else {
        _showErrorDialog(context, "Aucun champ ne peut être vide.");
        return; // Stop execution if any field is empty
      }
    }

    final database = await DatabaseHelper.database;
    for (Personne child in childrenList) {
      await database.insert(
        'Personne',
        child.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await database.rawUpdate('''
    UPDATE Famille
    SET completed = 1
    WHERE id_famille = ?
  ''', [widget.famille_id]);

    _showSuccessDialog(context);
  }

  void _showSuccessDialog(BuildContext context) async {
    List<Famille> families = await fetchFamiliesInMenage(widget.famille_id);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Succès',
      desc: 'Les enfants ont été ajoutés avec succès.',
      btnOkText: 'OK',
      btnOkOnPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListFamille(families: families),
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
}
