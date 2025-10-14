import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gogem/data/model/destination_model.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  List<Destination> _destinations = [];
  bool _isLoading = false;

  int get selectedIndex => _selectedIndex;
  List<Destination> get destinations => _destinations;
  bool get isLoading => _isLoading;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> loadDestinations() async {
    try {
      _isLoading = true;
      notifyListeners();

      final String jsonString = await rootBundle.loadString(
        'assets/data/dataset.json',
      );
      final List jsonData = json.decode(jsonString) as List;

      _destinations = jsonData
          .map((item) => Destination.fromJson(item))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Gagal memuat destinasi: $e");
      _isLoading = false;
      notifyListeners();
    }
  }
}
