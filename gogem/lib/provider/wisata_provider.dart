import 'package:flutter/material.dart';
import '../data/models/wisata_model.dart';
import '../service/wisata_service.dart';
import '../screen/detail/detail_screen.dart';

class WisataProvider extends ChangeNotifier {
  final WisataService _wisataService = WisataService();

  // State management
  List<WisataModel> _popularPlaces = [];
  List<WisataModel> _newHits = [];
  WisataModel? _featuredPlace;
  List<WisataModel> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';
  String? _errorMessage;

  // Getters
  List<WisataModel> get popularPlaces => _popularPlaces;
  List<WisataModel> get newHits => _newHits;
  WisataModel? get featuredPlace => _featuredPlace;
  List<WisataModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Constructor - automatically initialize data
  WisataProvider() {
    initializeWisataData();
  }

  /// Initialize semua data wisata
  Future<void> initializeWisataData() async {
    try {
      print('WisataProvider: Starting initialization...');
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load semua data secara parallel
      final futures = await Future.wait([
        _wisataService.getPopularWisata(),
        _wisataService.getNewHitsWisata(),
        _wisataService.getFeaturedWisata(),
      ]);

      _popularPlaces = futures[0] as List<WisataModel>;
      _newHits = futures[1] as List<WisataModel>;
      _featuredPlace = futures[2] as WisataModel?;

      print('WisataProvider: Data loaded successfully');
      print('Popular places: ${_popularPlaces.length}');
      print('New hits: ${_newHits.length}');
      print('Featured place: ${_featuredPlace?.nama ?? "null"}');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('WisataProvider: Error during initialization: $e');
      _errorMessage = 'Gagal memuat data wisata: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search wisata berdasarkan query
  Future<void> searchWisata(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    try {
      _isSearching = true;
      notifyListeners();

      _searchResults = await _wisataService.searchWisata(query);
      
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal mencari wisata: $e';
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Clear search results
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  /// Filter wisata berdasarkan kategori
  Future<List<WisataModel>> getWisataByCategory(String category) async {
    try {
      return await _wisataService.getWisataByCategory(category);
    } catch (e) {
      _errorMessage = 'Gagal memuat wisata kategori $category: $e';
      notifyListeners();
      return [];
    }
  }

  /// Navigate ke detail screen
  void navigateToDetail(BuildContext context, WisataModel wisata) {
    final placeDetail = PlaceDetailModel.fromWisataModel(wisata);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(place: placeDetail),
      ),
    );
  }

  /// Refresh semua data
  Future<void> refreshData() async {
    _wisataService.clearCache();
    await initializeWisataData();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get available categories
  Future<List<String>> getAvailableCategories() async {
    try {
      return await _wisataService.getAvailableCategories();
    } catch (e) {
      return [];
    }
  }

  /// Get available locations
  Future<List<String>> getAvailableLocations() async {
    try {
      return await _wisataService.getAvailableLocations();
    } catch (e) {
      return [];
    }
  }
}

// Provider untuk bottom navigation
class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
