import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/position.dart';
import '../models/candidate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // Base URL of your backend. Replace with your actual API's URL.
  final String baseUrl = 'https://cipmn-backend.onrender.com/api';

  // flutter_secure_storage to access the stored token.
  final _storage = FlutterSecureStorage();

  // Fetch the list of positions from the API.
  // Returns a List<Position>.
  Future<List<Position>> fetchPositions() async {
    // Read the stored auth token.
    String? token = await _storage.read(key: 'auth_token');

    // Make a GET request to `GET /positions`
    final response = await http.get(
      Uri.parse('$baseUrl/positions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // If the server responded with 200 (OK), parse the JSON.
    if (response.statusCode == 200) {
      // Decode JSON into a dynamic list
      List<dynamic> positionsJson = jsonDecode(response.body);
      // Map each item in positionsJson to a Position object
      return positionsJson.map((json) => Position.fromJson(json)).toList();
    } else {
      // If not 200, throw an exception
      throw Exception('Failed to load positions');
    }
  }

  // Fetch candidates for a given position by its ID.
  Future<List<Candidate>> fetchCandidates(int positionId) async {
    String? token = await _storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/candidates/position/$positionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> candidatesJson = jsonDecode(response.body);
      // Convert each item to Candidate model
      return candidatesJson.map((json) => Candidate.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load candidates');
    }
  }

  // Submit a vote for a candidate by their ID.
  Future<void> submitVote(int candidateId) async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/votes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'candidate_id': candidateId}),
    );

    if (response.statusCode == 200) {
      // success
      return;
    } else if (response.statusCode == 401) {
      // Token invalid or expired
      throw UnauthorizedException('Token is not valid');
    } else {
      // Other errors
      throw Exception('Failed to submit vote: ${response.body}');
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}
