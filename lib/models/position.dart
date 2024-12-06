class Position {
  final int id;
  final String name;
  final int votingYearId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Position({
    required this.id,
    required this.name,
    required this.votingYearId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'],
      name: json['name'] ?? '',
      votingYearId: json['voting_year_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
