class ValeurPossible {
  final int id;
  final String nomValeur;
  final bool requireSousIndicateur;

  ValeurPossible({
    required this.id,
    required this.nomValeur,
    required this.requireSousIndicateur,
  });

  factory ValeurPossible.fromJson(Map<String, dynamic> json) {
    return ValeurPossible(
      id: json['id'],
      nomValeur: json['nomValeur'],
      requireSousIndicateur: json['requireSousIndicateur'],
    );
  }
}