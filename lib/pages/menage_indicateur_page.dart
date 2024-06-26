import 'package:flutter/material.dart';
import 'package:recensement_app_test/widgets/customAppbar.dart';
import 'package:lottie/lottie.dart';
import '../helpers/api_service.dart';
import '../models/indicateur.dart';
import '../widgets/dynamic_indicator.dart';
import 'familleForm.dart';

class MenageIndicatorPage extends StatefulWidget {
  final int menageId;
  final int numberOfFamilies;

  const MenageIndicatorPage({
    super.key,
    required this.menageId,
    required this.numberOfFamilies,
  });

  @override
  _MenageIndicatorPageState createState() => _MenageIndicatorPageState();
}

class _MenageIndicatorPageState extends State<MenageIndicatorPage> {
  final ApiService _apiService = ApiService();
  late List<Indicateur> _menageIndicators = [];

  @override
  void initState() {
    super.initState();
    _fetchMenageIndicators();
  }

  Future<void> _fetchMenageIndicators() async {
    try {
      // Simulating a delay for demonstration purposes
      await Future.delayed(const Duration(seconds: 2));

      final List<Indicateur> indicators = await _apiService.fetchIndicateurs(1);
      setState(() {
        _menageIndicators = indicators
            .where((indicateur) => indicateur.objectIndicateur == 'Ménage')
            .toList();
      });
    } catch (e) {
      print('Error fetching Menage indicators: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Indicateurs Menage',
      ),
      body: _menageIndicators.isEmpty
          ? Center(
              child: Lottie.asset(
                'assets/animations/loading_indicator.json', // Path to the animation
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          : ListView.builder(
              itemCount: _menageIndicators.length,
              itemBuilder: (context, index) {
                final indicateur = _menageIndicators[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DynamicIndicatorItem(indicateur: indicateur),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final menageId = widget.menageId;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FamilleForm(
                menageId: menageId,
                numberOfFamilies: widget.numberOfFamilies,
              ),
            ),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
