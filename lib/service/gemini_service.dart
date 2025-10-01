import 'dart:io';

import 'package:chatbot_app/env/env.dart';
import 'package:chatbot_app/model/chat.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

// todo-02-service-01: create a service and setup
class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    final apiKey = Env.geminiApiKey;
    model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  }

  // todo-02-service-02: create a function helper to generate a content
  List<DataPart> _convertPathsIntoDataparts(List<String> path) =>
      path.map((path) {
        return DataPart(lookupMimeType(path)!, File(path).readAsBytesSync());
      }).toList();

  List<Content> _convertChatsIntoContent(List<Chat> chats) =>
      chats.map((chat) {
        return chat.isMyChat
            ? Content.multi([
              TextPart(chat.text),
              if (chat.paths != null)
                ..._convertPathsIntoDataparts(chat.paths!),
            ])
            : Content.model([TextPart(chat.text)]);
      }).toList();

  // todo-02-service-03: create a funciton to send message to Gemini
  Future<String> sendMessage(
    String message,
    List<Chat> chats, [
    List<String>? paths,
  ]) async {
    final chat = model.startChat(history: _convertChatsIntoContent(chats));
    var content = Content.multi([
      TextPart(message),
      if (paths != null) ..._convertPathsIntoDataparts(paths),
    ]);
    var response = await chat.sendMessage(content);
    return response.text!;
  }
}
