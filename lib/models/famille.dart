class Famille {
  final int? id_famille;
  final String nom;
  final int menage_id;
  final bool completed;

  Famille({
    this.id_famille,
    required this.nom,
    required this.menage_id,
    this.completed = false,
  });

  Famille.withId({
    required this.id_famille,
    required this.nom,
    required this.menage_id,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_famille': id_famille,
      'nom': nom,
      'menage_id': menage_id,
      'completed': completed ? 1 : 0,
    };
  }
  factory Famille.fromMap(Map<String, dynamic> map) {
    return Famille(
      id_famille: map['id_famille'],
      nom: map['nom'],
      menage_id: map['menage_id'],
      completed: map['completed'] == 1,
    );
  }
}
