import 'package:flutter/material.dart';
import 'package:gogem/data/model/destination_model.dart';
import 'package:gogem/service/database/db_helper.dart';

class FavoriteProvider extends ChangeNotifier {
  final DbHelper dbHelper = DbHelper();

  List<Destination> _favorites = [];
  bool _isLoading = false;

  List<Destination> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await dbHelper.getFavorites();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    return await dbHelper.isFavorite(id);
  }

  Future<void> toggleFavorite(Destination destination) async {
    final exists = await dbHelper.isFavorite(destination.id);

    if (exists) {
      await dbHelper.removeFavorite(destination.id);
      _favorites.removeWhere((d) => d.id == destination.id);
    } else {
      await dbHelper.insertFavorite(destination);
      _favorites.add(destination);
    }
    notifyListeners();
  }
}
