class Personne {
  final int? personne_id;
  final String prenom;
  final String nom;
  final String sexe;
  final DateTime dateDeNaissance;
  final bool chefFamille;
  final String lienParente;
  final int famille_id;

  Personne({
    this.personne_id,
    required this.prenom,
    required this.nom,
    required this.sexe,
    required this.dateDeNaissance,
    required this.chefFamille,
    required this.lienParente,
    required this.famille_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'personne_id': personne_id,
      'prenom': prenom,
      'nom': nom,
      'sexe': sexe,
      'dateDeNaissance': dateDeNaissance.toIso8601String(),
      'chefFamille': chefFamille ? 1 : 0,
      'lienParente': lienParente,
      'famille_id': famille_id,
    };
  }

  factory Personne.fromMap(Map<String, dynamic> map) {
    return Personne(
      personne_id: map['personne_id'],
      prenom: map['prenom'],
      nom: map['nom'],
      sexe: map['sexe'],
      dateDeNaissance: DateTime.parse(map['dateDeNaissance']),
      chefFamille: map['chefFamille'] == 1 ? true : false,
      lienParente: map['lienParente'],
      famille_id: map['famille_id'],
    );
  }
}

