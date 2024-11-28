import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/position.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'https://cipmn-backend.onrender.com/api';
  final _storage = FlutterSecureStorage();

  Future<List<Position>> fetchPositions() async {
    String? token = await _storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/positions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> positionsJson = jsonDecode(response.body);
      return positionsJson.map((json) => Position.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load positions');
    }
  }
}
