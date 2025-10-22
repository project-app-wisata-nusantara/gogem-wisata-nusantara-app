import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/model/destination_model.dart';
import 'package:flutter/services.dart';

class DestinationProvider with ChangeNotifier {
  List<Destination> _destinations = [];
  bool _isLoading = true;

  List<Destination> get destinations => _destinations;
  bool get isLoading => _isLoading;

  Future<void> loadDestinations() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/dataset.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      _destinations = jsonData.map((e) => Destination.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading destinations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
