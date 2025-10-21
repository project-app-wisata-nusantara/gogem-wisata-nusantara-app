import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../data/model/destination_model.dart';
import '../../service/recommender/tflite_recommender_service.dart';

class RecommenderProvider extends ChangeNotifier {
  final TFLiteRecommenderService _tfliteService = TFLiteRecommenderService();
  List<Destination> _destinations = [];
  bool _isLoading = true;

  List<Destination> get destinations => _destinations;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await _tfliteService.loadModel();
    await _loadDataset();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadDataset() async {
    final String jsonString = await rootBundle.loadString('assets/data/dataset.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    _destinations = jsonData.map((e) => Destination.fromJson(e)).toList();

    // Jalankan prediksi awal
    for (var d in _destinations) {
      final input = [
        d.kategoriEnc.toDouble(),
        d.preferensiEnc.toDouble(),
        d.kabupatenEnc.toDouble(),
        d.ratingNorm
      ];
      d.predictedScore = _tfliteService.predict(input);
    }
  }

  /// Ambil Top N restoran terbaik dari hasil prediksi
  List<Destination> getTopRecommendations({int topN = 10}) {
    final sorted = List<Destination>.from(_destinations)
      ..sort((a, b) => b.predictedScore.compareTo(a.predictedScore));
    return sorted.take(topN).toList();
  }

  /// Ambil rekomendasi serupa berdasarkan kategori/preferensi
  List<Destination> getSimilarRecommendations(Destination current) {
    final similar = _destinations.where((d) =>
    d.kategori == current.kategori ||
        d.preferensi == current.preferensi ||
        d.kabupatenKota == current.kabupatenKota
    ).toList();

    similar.sort((a, b) => b.predictedScore.compareTo(a.predictedScore));
    return similar.take(8).toList();
  }
}
