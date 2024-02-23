import 'package:flutter/material.dart';
import 'package:recensement_app_test/models/famille.dart';
import 'package:recensement_app_test/pages/personneForm.dart';
import 'package:recensement_app_test/widgets/customAppBar.dart';

class ListFamille extends StatelessWidget {
  final List<Famille> families;

  const ListFamille({Key? key, required this.families}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if all families have completed set to true
    bool allCompleted = families.every((family) => family.completed);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Liste des Familles',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: families.length,
              itemBuilder: (context, index) {
                final family = families[index];
                final cardColor = family.completed ? Colors.green : Colors.red;
                final icon =
                    family.completed ? Icons.check : Icons.close_rounded;
                return GestureDetector(
                  onTap: family.completed
                      ? null
                      : () {
                          if (family.id_famille != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PersonneForm(
                                  familleId: family.id_famille!,
                                  fatherNom: family.nom,
                                ),
                              ),
                            );
                          } else {
                            print('Error: id_famille is null');
                          }
                        },
                  child: Card(
                    color: cardColor,
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              family.nom,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Icon(
                            icon,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Conditionally show the button if all families are completed
          if (allCompleted)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the Menu
                  Navigator.pushReplacementNamed(context, 'menu');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA1F0F2),
                  fixedSize: const Size(200, 50),
                ),
                child: const Text(
                  'Retourner au Menu',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
