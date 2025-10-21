import 'package:google_generative_ai/google_generative_ai.dart';
import '../../env/env.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: Env.geminiApiKey,
    );
  }

  Future<String> generateDestinationSummary({
    required String destinationName,
    required String location,
    required String category,
  }) async {
    try {
      print('🔧 GeminiService: Preparing prompt for $destinationName');
      final prompt = '''
Buatkan ringkasan singkat tentang destinasi wisata berikut:
Nama: $destinationName
Lokasi: $location
Kategori: $category

Buatkan deskripsi menarik dalam bahasa Indonesia (150-200 kata) yang mencakup:
1. Gambaran umum destinasi
2. Keunikan atau daya tarik utama
3. Aktivitas yang bisa dilakukan
4. Informasi singkat tentang lokasi

Format: Langsung tulis deskripsinya tanpa judul atau label tambahan.
''';

      print('📤 Sending request to Gemini API...');
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      print('📥 Response received from Gemini API');
      final result = response.text ?? 'Tidak dapat menghasilkan ringkasan.';
      print('✨ Result length: ${result.length} characters');
      
      return result;
    } catch (e) {
      print('💥 Error in GeminiService: $e');
      throw Exception('Gagal menghasilkan ringkasan: $e');
    }
  }

  Future<String> generateChatbotDescription({
    required String destinationName,
    required String location,
  }) async {
    try {
      print('🔧 GeminiService: Preparing chatbot info for $destinationName');
      final prompt = '''
Buatkan deskripsi singkat (maksimal 50 kata) tentang destinasi wisata $destinationName di $location.

Jelaskan bahwa pengguna dapat bertanya melalui chatbot tentang:
1. Rekomendasi web/aplikasi untuk membeli tiket masuk
2. Estimasi perjalanan dari lokasi pengguna ke lokasi wisata
3. Jadwal buka dan tutup wisata

Format: Tulis dalam bahasa Indonesia yang ramah dan informatif, langsung ke inti tanpa judul atau label tambahan.
''';

      print('📤 Sending chatbot info request to Gemini API...');
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      print('📥 Chatbot info response received from Gemini API');
      final result = response.text ?? 'Tanyakan informasi tentang $destinationName!';
      print('✨ Chatbot info length: ${result.length} characters');
      
      return result;
    } catch (e) {
      print('💥 Error in GeminiService (chatbot info): $e');
      throw Exception('Gagal menghasilkan info chatbot: $e');
    }
  }

  Future<String> generateChatResponse(String prompt) async {
    try {
      print('🔧 GeminiService: Generating chat response');
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      print('📥 Chat response received');
      final result = response.text ?? 'Maaf, saya tidak dapat memproses permintaan Anda.';
      
      return result;
    } catch (e) {
      print('💥 Error in GeminiService (chat response): $e');
      throw Exception('Gagal menghasilkan response: $e');
    }
  }
}
