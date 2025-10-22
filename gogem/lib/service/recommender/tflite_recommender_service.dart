import 'dart:developer' as developer;

import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteRecommenderService {
  late Interpreter _interpreter;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Load model TFLite dari assets
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'models/gogem_recommender.tflite',
      );
      _isInitialized = true;
      developer.log('✅ Model gogem_recommender.tflite berhasil dimuat');
    } catch (e) {
      developer.log('❌ Gagal memuat model: $e');
    }
  }

  /// Prediksi skor rekomendasi restoran berdasarkan input fitur
  double predict(List<double> inputFeatures) {
    if (!_isInitialized) {
      print('⚠️ Model belum diinisialisasi!');
      return 0.0;
    }

    final input = [inputFeatures];
    final output = List.filled(1, 0.0).reshape([1, 1]);

    _interpreter.run(input, output);
    return output[0][0];
  }

  void close() {
    _interpreter.close();
  }
}
