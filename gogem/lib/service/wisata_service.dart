import 'package:flutter/services.dart';
import 'dart:convert';
import '../data/models/wisata_model.dart';

class WisataService {
  static const String _dataPath = 'assets/data/dataset.json';

  // Singleton pattern
  static final WisataService _instance = WisataService._internal();
  factory WisataService() => _instance;
  WisataService._internal();

  List<WisataModel>? _cachedData;

  /// Load semua data wisata dari JSON
  Future<List<WisataModel>> loadAllWisata() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String response = await rootBundle.loadString(_dataPath);
      final List<dynamic> jsonData = json.decode(response);
      
      _cachedData = jsonData
          .map((json) => WisataModel.fromJson(json))
          .toList();
      
      return _cachedData!;
    } catch (e) {
      throw Exception('Gagal memuat data wisata: $e');
    }
  }

  /// Dapatkan wisata populer (rating >= 4.5)
  Future<List<WisataModel>> getPopularWisata({int limit = 10}) async {
    final allWisata = await loadAllWisata();
    return allWisata
        .where((wisata) => wisata.isHighRated)
        .take(limit)
        .toList();
  }

  /// Dapatkan wisata new hits (rating 4.0-4.5)
  Future<List<WisataModel>> getNewHitsWisata({int limit = 8}) async {
    final allWisata = await loadAllWisata();
    return allWisata
        .where((wisata) => wisata.rating >= 4.0 && wisata.rating < 4.5)
        .take(limit)
        .toList();
  }

  /// Dapatkan wisata featured (budaya dengan rating tinggi dan gambar valid)
  Future<WisataModel?> getFeaturedWisata() async {
    final allWisata = await loadAllWisata();
    try {
      return allWisata
          .where((wisata) => 
              wisata.isCulturalSite && 
              wisata.rating >= 4.6 &&
              wisata.hasValidImage)
          .first;
    } catch (e) {
      // Jika tidak ada yang memenuhi kriteria, ambil yang rating tertinggi
      return allWisata
          .where((wisata) => wisata.hasValidImage)
          .reduce((a, b) => a.rating > b.rating ? a : b);
    }
  }

  /// Cari wisata berdasarkan nama
  Future<List<WisataModel>> searchWisata(String query) async {
    if (query.isEmpty) return [];
    
    final allWisata = await loadAllWisata();
    final lowerQuery = query.toLowerCase();
    
    return allWisata
        .where((wisata) => 
            wisata.nama.toLowerCase().contains(lowerQuery) ||
            wisata.kabupatenKota.toLowerCase().contains(lowerQuery) ||
            wisata.kategori.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Filter wisata berdasarkan kategori
  Future<List<WisataModel>> getWisataByCategory(String category) async {
    final allWisata = await loadAllWisata();
    return allWisata
        .where((wisata) => wisata.kategori.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Dapatkan wisata berdasarkan rating minimum
  Future<List<WisataModel>> getWisataByMinRating(double minRating) async {
    final allWisata = await loadAllWisata();
    return allWisata
        .where((wisata) => wisata.rating >= minRating)
        .toList();
  }

  /// Dapatkan semua kategori yang tersedia
  Future<List<String>> getAvailableCategories() async {
    final allWisata = await loadAllWisata();
    return allWisata
        .map((wisata) => wisata.kategori)
        .toSet()
        .toList()
      ..sort();
  }

  /// Dapatkan semua kabupaten/kota yang tersedia
  Future<List<String>> getAvailableLocations() async {
    final allWisata = await loadAllWisata();
    return allWisata
        .map((wisata) => wisata.kabupatenKota)
        .toSet()
        .toList()
      ..sort();
  }

  /// Clear cache (untuk refresh data)
  void clearCache() {
    _cachedData = null;
  }
}
