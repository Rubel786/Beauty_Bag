import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../model/chat_model.dart';

class ChatViewModel extends ChangeNotifier {
  final String apiKey = 'AIzaSyBzzVBCdZ-Sh2wOHlNJ2BXcGW9TR5JWvtY';
  final List<ChatMessage> messages = [];
  late final GenerativeModel _model;
  late final ChatSession _chat;
  bool isLoading = false;

  ChatViewModel() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
  }

  Future<void> sendMessage(String userMessage) async {
    messages.add(ChatMessage(role: 'user', content: userMessage));
    isLoading = true;
    notifyListeners();

    try {
      final response = await _chat.sendMessage(Content.text(userMessage));
      final reply = response.text ?? 'No response from Gemini.';
      messages.add(ChatMessage(role: 'model', content: reply));
    } catch (e) {
      messages.add(ChatMessage(
        role: 'model',
        content: 'Error: ${e.toString()}',
      ));
    }

    isLoading = false;
    notifyListeners();
  }
}
