import 'package:flutter/material.dart';
import '../models/position.dart';
import '../services/api_service.dart';

class PositionProvider with ChangeNotifier {
  List<Position> _positions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Position> get positions => _positions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> fetchPositions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _positions = await _apiService.fetchPositions();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
