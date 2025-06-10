import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/chat_model.dart';

class ChatViewModel extends ChangeNotifier {
  List<ChatModel> messages = [];
  bool isLoading = false;

  final String OPENAI_API_KEY = dotenv.env['OPENAI_API_KEY'] ?? '';

  Future<void> sendMessage(String userMessage) async {
    messages.add(ChatModel(role: 'user', content: userMessage));
    isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        'Authorization': 'Bearer $OPENAI_API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": messages.map((msg) => {
          "role": msg.role,
          "content": msg.content,
        }).toList(),
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final reply = decoded['choices'][0]['message']['content'];
      messages.add(ChatModel(role: 'assistant', content: reply));
    } else {
      messages.add(ChatModel(role: 'assistant', content: 'Something went wrong!'));
      final error = jsonDecode(response.body);
      messages.add(ChatModel(
        role: 'assistant',
        content: 'Error: ${error['error']['message'] ?? 'Unknown error'}',
      ));
    }

    isLoading = false;
    notifyListeners();
  }
}
