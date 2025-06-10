import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../viewmodel/chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  static String routeName = "/chat";

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text("Chat"),
              titleTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.messages.length,
                      itemBuilder: (context, index) {
                        final message = viewModel.messages[index];
                        return ListTile(
                          title: Align(
                            alignment: message.role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: message.role == 'user' ? kPrimaryShadowColor : kPrimaryBodyColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(message.content),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (viewModel.isLoading) const LinearProgressIndicator(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Ask Something....',
                            hintStyle: const TextStyle(
                                fontSize: 12
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.brown),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.brown),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.brown),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_controller.text.trim().isNotEmpty) {
                            viewModel.sendMessage(_controller.text.trim());
                            _controller.clear();
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
