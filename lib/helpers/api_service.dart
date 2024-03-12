import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/campagne.dart';
import '../models/chapitre.dart';
import '../models/indicateur.dart';

class ApiService {
  final String baseUrl = "http://173.249.11.251:8080/recensement-1";

  Future<Campagne> fetchCampagne(int idQuestionnaire) async {
    final response =
        await http.get(Uri.parse('$baseUrl/questionnaire/$idQuestionnaire'));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> responseData = json.decode(decodedBody);
      return Campagne.fromJson(responseData['campagne']);
    } else {
      throw Exception('Failed to load campagne');
    }
  }

  Future<List<Chapitre>> fetchChapitres(int idQuestionnaire) async {
    final response =
        await http.get(Uri.parse('$baseUrl/questionnaire/$idQuestionnaire'));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> responseData = json.decode(decodedBody);
      final List<dynamic> chapitresData = responseData['chapitres'];
      return chapitresData
          .map((chapitre) => Chapitre.fromJson(chapitre))
          .toList();
    } else {
      throw Exception('Failed to load chapitres');
    }
  }

  Future<List<Indicateur>> fetchIndicateurs(int idQuestionnaire) async {
    final response =
        await http.get(Uri.parse('$baseUrl/questionnaire/$idQuestionnaire'));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> responseData = json.decode(decodedBody);
      final List<dynamic> indicateursData = responseData['indicateurs'];
      return indicateursData
          .map((indicateur) => Indicateur.fromJson(indicateur))
          .toList();
    } else {
      throw Exception('Failed to load indicateurs');
    }
  }
}
