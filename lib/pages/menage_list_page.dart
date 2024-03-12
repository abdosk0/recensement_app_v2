import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:recensement_app_test/pages/menage_details_page.dart';
import 'package:recensement_app_test/pages/menage_update_form.dart';
import 'package:recensement_app_test/widgets/customAppbar.dart';
import 'package:sqflite/sqflite.dart';

import '../models/menage.dart';

class MenageListPage extends StatefulWidget {
  @override
  _MenageListPageState createState() => _MenageListPageState();
}

class _MenageListPageState extends State<MenageListPage> {
  late List<Map<String, dynamic>> _menages = [];

  @override
  void initState() {
    super.initState();
    _loadMenages();
  }

  Future<void> _loadMenages() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'recensement_database.db'),
    );
    final List<Map<String, dynamic>> menages = await database.query('Menage');
    setState(() {
      _menages = menages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'List des Menages',
        showBackButton: true,
      ),
      body: ListView.builder(
        itemCount: _menages.length,
        itemBuilder: (context, index) {
          final menage = _menages[index];
          return GestureDetector(
            onTap: () {
              _showOptionsDialog(context, menage);
            },
            child: Card(
              color: const Color(0xFFA1F0F2),
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(menage['nom']),
                subtitle: Row(
                  children: [
                    Text('${menage['nombre_familles']} families'),
                    SizedBox(width: 8.0),
                    Icon(Icons.family_restroom),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOptionsDialog(
      BuildContext context, Map<String, dynamic> menageData) {
    Menage menage = Menage(
      id_menage: menageData['id_menage'],
      nom: menageData['nom'],
      adresse: menageData['adresse'],
      quartier: menageData['quartier'],
      ville: menageData['ville'],
      nombre_familles: menageData['nombre_familles'],
    );

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Options',
      desc: 'Choose an option',
      btnCancelText: 'Modifier le Menage',
      btnOkColor: Color(0xFF008A90),
      btnCancelColor: Color(0xFF008A90),
      btnCancelOnPress: () async {
        // Navigate to update form
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenageUpdateForm(menage: menage)),
        );

        // Check if the result is true (indicating a successful update)
        if (result == true) {
          // Refresh the list here (call a method to fetch updated data)
          _loadMenages(); 
        }
      },
      btnOkText: 'Voir les familles',
      btnOkOnPress: () {
        // Navigate to details page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenageDetailsPage(
                    menage: menageData,
                  )),
        );
      },
    ).show();
  }
}
