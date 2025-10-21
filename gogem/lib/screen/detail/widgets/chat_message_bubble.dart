// lib/screens/detail/widgets/chat_message_bubble.dart

import 'package:flutter/material.dart';
import '../../../provider/detail/detail_provider.dart' show ChatMessage, MessageSender;

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser ? Colors.blue : Colors.orange.shade100;
    final textColor = isUser ? Colors.white : Colors.black;

    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment:
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
                bottomLeft: Radius.circular(isUser ? 12.0 : 0.0),
                bottomRight: Radius.circular(isUser ? 0.0 : 12.0),
              ),
              boxShadow: isUser
                  ? null
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
          if (message.isLoading)
            Padding(
              padding: EdgeInsets.only(
                top: 4.0,
                right: isUser ? 0 : 8.0,
                left: isUser ? 8.0 : 0,
              ),
              child: const SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
            ),
        ],
      ),
    );
  }
}