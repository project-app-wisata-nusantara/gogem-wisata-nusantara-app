// lib/screens/detail/widgets/chatbot_content.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/destination_model.dart';
import '../../../provider/detail/detail_provider.dart';
import 'chat_message_bubble.dart';
import 'chatbot_input_field.dart';

class ChatbotContent extends StatefulWidget {
  final Destination destination;

  const ChatbotContent({super.key, required this.destination});

  @override
  State<ChatbotContent> createState() => _ChatbotContentState();
}

class _ChatbotContentState extends State<ChatbotContent> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (context, detailProvider, child) {
        // Scroll ke bawah saat ada pesan baru
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return Container(
          color: const Color(0xFFFFF8E1),
          child: Column(
            children: [
              Expanded(
                child: detailProvider.messages.isEmpty
                    ? _buildInitialInfo(detailProvider)
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: detailProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = detailProvider.messages[index];
                    // Menggunakan ChatMessageBubble yang terpisah
                    return ChatMessageBubble(message: message);
                  },
                ),
              ),
              // Menggunakan ChatbotInputField yang terpisah
              ChatbotInputField(
                controller: _chatController,
                isLoading: detailProvider.isSendingMessage,
                onSend: () {
                  if (_chatController.text.trim().isNotEmpty) {
                    detailProvider.sendMessage(_chatController.text.trim());
                    _chatController.clear();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInitialInfo(DetailProvider detailProvider) {
    if (detailProvider.isGeneratingChatbotInfo) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
              SizedBox(height: 12),
              Text('Memuat informasi chatbot...',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade700, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    detailProvider.chatbotDescription ??
                        'Tanyakan informasi tentang ${widget.destination.nama}!',
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey[800], height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Contoh Pertanyaan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // Contoh pertanyaan (menggunakan widget helper jika perlu)
          _buildQuestionChip(
              context, 'Berapa harga tiket masuknya?'),
          _buildQuestionChip(
              context, 'Apa saja fasilitas yang tersedia di sini?'),
          _buildQuestionChip(
              context, 'Apa makanan khas di sekitar tempat wisata ini?'),
        ],
      ),
    );
  }

  Widget _buildQuestionChip(BuildContext context, String question) {
    final detailProvider = Provider.of<DetailProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ActionChip(
        label: Text(question, style: const TextStyle(fontSize: 13, color: Colors.blue)),
        backgroundColor: Colors.blue.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue.shade200),
        ),
        onPressed: () {
          // Kirim pesan saat chip diklik
          detailProvider.sendMessage(question);
        },
      ),
    );
  }
}