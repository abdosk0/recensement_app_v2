import 'package:flutter/material.dart';
import 'package:recensement_app_test/widgets/customMainAppbar.dart';

import '../widgets/cardMenu.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomMainAppBar(title: "Menu"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardMenu(
              text: 'Nouvel Enregistrement',
              icon: Icons.add_home,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("menage");
              },
            ),
            const SizedBox(height: 20),
            CardMenu(
              text: 'Prêt à Envoyé',
              icon: Icons.send,
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            CardMenu(
              text: 'Envoyés',
              icon: Icons.send,
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            CardMenu(
              text: 'Infos Générales',
              icon: Icons.info,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
