import 'position.dart';
import 'voting_year.dart';

class Candidate {
  final int id;
  final String title;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? photo;
  final int positionId;
  final int votingYearId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Position position; // Nested Position object
  final VotingYear votingYear; // Nested VotingYear object

  Candidate({
    required this.id,
    required this.title,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.photo,
    required this.positionId,
    required this.votingYearId,
    required this.createdAt,
    required this.updatedAt,
    required this.position,
    required this.votingYear,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    // Note: we have to parse the dates from strings to DateTime.
    // We also assume `Position` and `VotingYear` classes have their own `fromJson`.

    return Candidate(
        id: json['id'],
        title: json['title'] ?? '',
        firstName: json['first_name'] ?? '',
        middleName: json['middle_name'],
        lastName: json['last_name'] ?? '',
        photo: json['photo'],
        positionId: json['position_id'],
        votingYearId: json['voting_year_id'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        position: Position.fromJson(json['Position']), // Parse nested Position
        votingYear:
            VotingYear.fromJson(json['VotingYear']) // Parse nested VotingYear
        );
  }
}
