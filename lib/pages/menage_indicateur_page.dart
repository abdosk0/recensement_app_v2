import 'package:flutter/material.dart';
import '../helpers/api_service.dart';
import '../models/indicateur.dart';
import '../widgets/dynamic_indicator.dart';
import 'familleForm.dart';

class MenageIndicatorPage extends StatefulWidget {
  final int menageId;
  final int numberOfFamilies;

  const MenageIndicatorPage({super.key, required this.menageId, required this.numberOfFamilies});
  
  @override
  _MenageIndicatorPageState createState() => _MenageIndicatorPageState();
}

class _MenageIndicatorPageState extends State<MenageIndicatorPage> {
  final ApiService _apiService = ApiService(); // Instantiate ApiService
  late List<Indicateur> _menageIndicators = []; // List to hold Menage indicators

  @override
  void initState() {
    super.initState();
    _fetchMenageIndicators(); // Fetch Menage indicators when page initializes
  }

  Future<void> _fetchMenageIndicators() async {
  try {
    print('Fetching indicators...');
    final List<Indicateur> indicators = await _apiService.fetchIndicateurs(1);
    print('Received indicators: $indicators');
    setState(() {
      _menageIndicators = indicators.where((indicateur) => indicateur.objectIndicateur == 'Ménage').toList();
    });
  } catch (e) {
    // Handle errors
    print('Error fetching Menage indicators: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menage Indicators'),
      ),
      body: ListView.builder(
        itemCount: _menageIndicators.length,
        itemBuilder: (context, index) {
          final indicateur = _menageIndicators[index];
          return DynamicIndicatorItem(indicateur: indicateur);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final menageId = widget.menageId; // Retrieve menageId
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
