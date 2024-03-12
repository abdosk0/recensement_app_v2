import 'package:flutter/material.dart';
import 'package:recensement_app_test/widgets/customAppbar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MenageDetailsPage extends StatefulWidget {
  final Map<String, dynamic> menage;

  MenageDetailsPage({required this.menage});

  @override
  _MenageDetailsPageState createState() => _MenageDetailsPageState();
}

class _MenageDetailsPageState extends State<MenageDetailsPage> {
  List<Map<String, dynamic>> _families = [];
  List<Map<String, dynamic>> _personnes = [];

  @override
  void initState() {
    super.initState();
    _loadFamiliesAndPersonnes();
  }

  Future<void> _loadFamiliesAndPersonnes() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'recensement_database.db'),
    );
    final List<Map<String, dynamic>> families = await database.query(
      'Famille',
      where: 'menage_id = ?',
      whereArgs: [widget.menage['id_menage']],
    );
    final List<Map<String, dynamic>> personnes = await database.query(
      'Personne',
      where:
          'famille_id IN (${families.map((f) => f['id_famille']).join(',')})',
    );

    setState(() {
      _families = families;
      _personnes = personnes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Details Menage',
        showBackButton: true,
      ),
      body: ListView.builder(
        itemCount: _families.length,
        itemBuilder: (context, index) {
          final family = _families[index];
          final personnesForFamily = _personnes
              .where(
                  (personne) => personne['famille_id'] == family['id_famille'])
              .toList();

          return Card(
            color: const Color(0xFFA1F0F2),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(family['nom']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${personnesForFamily.length} Personnes'),
                  for (var personne in personnesForFamily)
                    Text('${personne['prenom']} ${personne['nom']}'),
                ],
              ),
              onTap: () {
                // Navigate to family details page
              },
            ),
          );
        },
      ),
    );
  }
}
