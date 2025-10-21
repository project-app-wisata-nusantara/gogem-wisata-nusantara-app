import 'package:flutter/material.dart';
import '../../service/gemini/gemini_service.dart';

class GeminiProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  bool _isGenerating = false;
  String? _generatedSummary;
  String? _errorMessage;

  bool get isGenerating => _isGenerating;
  String? get generatedSummary => _generatedSummary;
  String? get errorMessage => _errorMessage;

  Future<void> generateSummary({
    required String destinationName,
    required String location,
    required String category,
  }) async {
    print('🚀 Starting generate summary for: $destinationName');
    _isGenerating = true;
    _errorMessage = null;
    _generatedSummary = null;
    notifyListeners();

    try {
      print('📡 Calling Gemini API...');
      _generatedSummary = await _geminiService.generateDestinationSummary(
        destinationName: destinationName,
        location: location,
        category: category,
      );
      print('✅ Summary generated successfully: ${_generatedSummary?.substring(0, 50)}...');
      _isGenerating = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error generating summary: $e');
      _isGenerating = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<String> generateChatbotInfo({
    required String destinationName,
    required String location,
  }) async {
    print('🤖 Starting generate chatbot info for: $destinationName');
    try {
      final result = await _geminiService.generateChatbotDescription(
        destinationName: destinationName,
        location: location,
      );
      print('✅ Chatbot info generated successfully');
      return result;
    } catch (e) {
      print('❌ Error generating chatbot info: $e');
      throw e;
    }
  }

  void clearSummary() {
    _generatedSummary = null;
    _errorMessage = null;
    notifyListeners();
  }
}
