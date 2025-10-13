import 'package:flutter/material.dart';
import '../../data/ticketing_data.dart';
import '../../service/gemini/gemini_service.dart';

// Model untuk chat message
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class DetailProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  // State untuk expand/collapse deskripsi
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  // State untuk chatbot info
  String? _chatbotDescription;
  bool _isGeneratingChatbotInfo = false;
  bool _hasTriedToGenerateChatbotInfo = false;

  String? get chatbotDescription => _chatbotDescription;
  bool get isGeneratingChatbotInfo => _isGeneratingChatbotInfo;

  // State untuk chat messages
  List<ChatMessage> _messages = [];
  bool _isSendingMessage = false;
  String? _currentDestinationContext;

  List<ChatMessage> get messages => _messages;
  bool get isSendingMessage => _isSendingMessage;

  // Toggle expand/collapse
  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  // Reset state ketika pindah destinasi
  void resetState() {
    _isExpanded = false;
    _chatbotDescription = null;
    _isGeneratingChatbotInfo = false;
    _hasTriedToGenerateChatbotInfo = false;
    _messages = [];
    _isSendingMessage = false;
    _currentDestinationContext = null;
    notifyListeners();
  }

  // Set context destinasi untuk chatbot
  void setDestinationContext(String destinationName, String location) {
    _currentDestinationContext =
        '''
Konteks: Saya adalah asisten untuk destinasi wisata "$destinationName" di $location.
Saya dapat membantu menjawab pertanyaan tentang:
1. Rekomendasi web/aplikasi untuk membeli tiket
2. Estimasi perjalanan dari lokasi pengguna
3. Jadwal buka dan tutup wisata

Jawab dengan singkat, jelas, dan informatif dalam bahasa Indonesia.
''';
  }

  // Generate chatbot info
  Future<void> generateChatbotInfo({
    required String destinationName,
    required String location,
  }) async {
    if (_hasTriedToGenerateChatbotInfo) return;

    _hasTriedToGenerateChatbotInfo = true;
    _isGeneratingChatbotInfo = true;
    notifyListeners();

    try {
      print('🤖 DetailProvider: Generating chatbot info for $destinationName');
      final result = await _geminiService.generateChatbotDescription(
        destinationName: destinationName,
        location: location,
      );

      _chatbotDescription = result;
      _isGeneratingChatbotInfo = false;
      notifyListeners();
      print('✅ DetailProvider: Chatbot info generated successfully');
    } catch (e) {
      print('❌ DetailProvider: Error generating chatbot info: $e');
      _chatbotDescription =
          'Tanyakan informasi tentang $destinationName seperti rekomendasi tiket, estimasi perjalanan, atau jadwal operasional!';
      _isGeneratingChatbotInfo = false;
      notifyListeners();
    }
  }

  // Check apakah pertanyaan tentang tiket
  bool _isTicketQuestion(String message) {
    final lowerMessage = message.toLowerCase();
    final keywords = [
      'tiket',
      'ticket',
      'beli tiket',
      'booking',
      'book',
      'web',
      'website',
      'aplikasi',
      'app',
      'platform',
      'online',
      'pesan tiket',
      'order tiket',
    ];

    return keywords.any((keyword) => lowerMessage.contains(keyword));
  }

  // Kirim pesan ke chatbot
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Tambahkan pesan user
    _messages.add(
      ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()),
    );
    _isSendingMessage = true;
    notifyListeners();

    try {
      print('💬 Sending message to chatbot: $userMessage');

      String response;

      // Cek apakah pertanyaan tentang tiket/booking
      if (_isTicketQuestion(userMessage)) {
        print('🎫 Detected ticket question - using pre-defined data');
        response = TicketingData.getRecommendationText();
      } else {
        // Buat prompt dengan context destinasi untuk pertanyaan lainnya
        final prompt =
            '''
$_currentDestinationContext

Pertanyaan pengguna: $userMessage

Berikan jawaban yang membantu dan relevan. Jika tentang jadwal/jam operasional, sarankan untuk mengecek website resmi atau menghubungi langsung. Jika tentang estimasi perjalanan, sarankan menggunakan Google Maps.
''';

        response = await _geminiService.generateChatResponse(prompt);
      }

      // Tambahkan response dari bot
      _messages.add(
        ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
      );

      print('✅ Chatbot response received');
    } catch (e) {
      print('❌ Error sending message: $e');
      // Tambahkan error message
      _messages.add(
        ChatMessage(
          text: 'Maaf, terjadi kesalahan. Silakan coba lagi.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      _isSendingMessage = false;
      notifyListeners();
    }
  }
}
