import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/model/destination_model.dart';

class CategoryProvider with ChangeNotifier {
  List<String> _categories = [];
  bool _isLoading = true;

  List<String> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/dataset.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      // Ubah JSON ke List<Destination>
      final List<Destination> destinations =
      jsonData.map((e) => Destination.fromJson(e)).toList();

      // Ambil kategori unik dari list destinasi
      final Set<String> uniqueCategories = destinations.map((d) => d.kategori).toSet();

      _categories = uniqueCategories.toList()..sort();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
