class Menage {
  final int? id_menage;
  final String nom;
  final String adresse;
  final String quartier;
  final String ville;
  final int nombre_familles;

  Menage({
    this.id_menage,
    required this.nom,
    required this.adresse,
    required this.quartier,
    required this.ville,
    required this.nombre_familles,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_menage': id_menage,
      'nom': nom,
      'adresse': adresse,
      'quartier': quartier,
      'ville': ville,
      'nombre_familles': nombre_familles,
    };
  }

}