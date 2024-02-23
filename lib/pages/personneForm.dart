import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:recensement_app_test/models/personne.dart';
import 'package:sqflite/sqflite.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../helpers/databaseHelper.dart';
import '../models/famille.dart';
import '../widgets/customAppBar.dart';
import '../widgets/textFieldWidget.dart';
import 'childrenForm.dart';
import 'listFamille.dart';

class PersonneForm extends StatefulWidget {
  final int familleId;
  final String fatherNom;

  const PersonneForm({
    super.key,
    required this.familleId,
    required this.fatherNom,
  });

  @override
  State<PersonneForm> createState() => _PersonneFormState();
}

class _PersonneFormState extends State<PersonneForm> {
  late TextEditingController _motherPrenomController = TextEditingController();
  late TextEditingController _motherNomController = TextEditingController();
  late TextEditingController _fatherPrenomController = TextEditingController();
  late TextEditingController _fatherNomController = TextEditingController();
  late TextEditingController _numberOfChildrenController =
      TextEditingController();

  late DateTime _motherDateDeNaissance = DateTime.now();
  late DateTime _fatherDateDeNaissance = DateTime.now();
  bool _isFatherChef = false;
  bool _isMotherChef = false;

  @override
  void initState() {
    super.initState();
    _fatherNomController = TextEditingController(
        text: widget.fatherNom); // Initialize with family name
    _fatherNomController
      ..text = widget.fatherNom
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _fatherNomController.text.length)); // Set cursor at the end
    _fatherNomController.selection = TextSelection.fromPosition(
        TextPosition(offset: _fatherNomController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Ajouter Personnes'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFFA1F0F2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Père',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFieldWidget(
                      controller: _fatherPrenomController,
                      labelText: 'Prénom',
                    ),
                    TextFieldWidget(
                      controller: _fatherNomController,
                      labelText: 'Nom',
                      enabled: false,
                    ),
                    DateTimePicker(
                      type: DateTimePickerType.date,
                      initialValue: _fatherDateDeNaissance.toString(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      onChanged: (val) {
                        setState(() {
                          _fatherDateDeNaissance = DateTime.parse(val);
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Date de naissance'),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _isFatherChef,
                          onChanged: (value) {
                            setState(() {
                              _isFatherChef = value!;
                              if (_isFatherChef) {
                                _isMotherChef = false;
                              }
                            });
                          },
                        ),
                        const Text('Chef de famille'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFFA1F0F2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mère',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFieldWidget(
                      controller: _motherPrenomController,
                      labelText: 'Prénom',
                    ),
                    TextFieldWidget(
                      controller: _motherNomController,
                      labelText: 'Nom',
                    ),
                    DateTimePicker(
                      type: DateTimePickerType.date,
                      initialValue: _motherDateDeNaissance.toString(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      onChanged: (val) {
                        setState(() {
                          _motherDateDeNaissance = DateTime.parse(val);
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Date de naissance'),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _isMotherChef,
                          onChanged: (value) {
                            setState(() {
                              _isMotherChef = value!;
                              if (_isMotherChef) {
                                _isFatherChef = false;
                              }
                            });
                          },
                        ),
                        const Text('Chef de famille'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: _numberOfChildrenController,
              labelText: 'Nombre d\'enfants',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveParents(context);
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

  Future<List<Famille>> fetchFamiliesInMenage(int famille_id) async {
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
    ''', [famille_id]);

      List<Famille> families =
          result.map((row) => Famille.fromMap(row)).toList();
      return families;
    } catch (e) {
      print('Error fetching families: $e');
      return [];
    }
  }

  void _saveParents(BuildContext context) async {
    if (_fatherPrenomController.text.isNotEmpty &&
        _motherPrenomController.text.isNotEmpty &&
        _motherNomController.text.isNotEmpty &&
        _numberOfChildrenController.text.isNotEmpty &&
        (_isFatherChef || _isMotherChef)) {
      final database = await DatabaseHelper.database;
      int numberOfChildren =
          int.tryParse(_numberOfChildrenController.text) ?? 0;

      if (_isFatherChef && _isMotherChef) {
        _showErrorDialog(context,
            'Une seule personne peut être désignée comme chef de famille.');
        return;
      }

      final father = Personne(
        prenom: _fatherPrenomController.text,
        nom: widget.fatherNom,
        sexe: 'Homme',
        dateDeNaissance: _fatherDateDeNaissance,
        chefFamille: _isFatherChef,
        lienParente: 'Père',
        famille_id: widget.familleId,
      );
      final mother = Personne(
        prenom: _motherPrenomController.text,
        nom: _motherNomController.text,
        sexe: 'Femme',
        dateDeNaissance: _motherDateDeNaissance,
        chefFamille: _isMotherChef,
        lienParente: 'Mère',
        famille_id: widget.familleId,
      );

      try {
        await database.insert(
          'Personne',
          father.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await database.insert(
          'Personne',
          mother.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        if (numberOfChildren != 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildrenForm(
                famille_id: widget.familleId,
                fatherInfo: widget.fatherNom,
                motherInfo: _motherPrenomController.text,
                numberOfChildren: numberOfChildren,
              ),
            ),
          );
        } else {
          await database.rawUpdate('''
          UPDATE Famille
          SET completed = 1
          WHERE id_famille = ?
        ''', [widget.familleId]);
          List<Famille> families =
              await fetchFamiliesInMenage(widget.familleId);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListFamille(families: families),
            ),
          );
        }

        _showSuccessDialog(context);
      } catch (e) {
        print('Error saving parents: $e');
        _showErrorDialog(
            context, 'Une erreur est survenue lors de la sauvegarde.');
      }
    } else {
      _showErrorDialog(context, 'Aucun champ ne peut être vide.');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Succès',
      desc: 'La famille a été ajoutée avec succès.',
      btnOkText: 'OK',
      btnOkOnPress: () {},
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
