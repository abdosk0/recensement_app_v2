class Indicateur {
  final int id;
  final String codeIndicateur;
  final String nomIndicateur;
  final int ordreIndicateur;
  final String description;
  final String type;
  final bool obligatoire;
  final String objectIndicateur;

  Indicateur({
    required this.id,
    required this.codeIndicateur,
    required this.nomIndicateur,
    required this.ordreIndicateur,
    required this.description,
    required this.type,
    required this.obligatoire,
    required this.objectIndicateur,
  });

  factory Indicateur.fromJson(Map<String, dynamic> json) {
    return Indicateur(
      id: json['id'],
      codeIndicateur: json['codeIndicateur'],
      nomIndicateur: json['nomIndicateur'],
      ordreIndicateur: json['ordreIndicateur'],
      description: json['description'],
      type: json['type'],
      obligatoire: json['obligatoire'],
      objectIndicateur: json['objectIndicateur'],
    );
  }
}
