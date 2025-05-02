import 'package:flutter/material.dart';
import 'package:triana_web/features/front_counter/models/form.dart';

class ChatView extends StatefulWidget {
  final IdentityFormModel? identityForm;
  const ChatView({super.key, this.identityForm});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messageController = TextEditingController();
  final List<Map<String, String>> messages = [
    {'sender': 'User', 'message': 'Hello!'},
    {'sender': 'Bot', 'message': 'Hi there! How can I help you today?'},
    {'sender': 'User', 'message': 'I need some assistance with my account.'},
    {
      'sender': 'Bot',
      'message':
          'Sure, I can help with that. Could you please provide more details?',
    },
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({'sender': 'User', 'message': _messageController.text});
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Triana')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Reverse the list to start from the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message =
                    messages[messages.length -
                        1 -
                        index]; // Adjust index to match reversed order
                final isUser = message['sender'] == 'User';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['message']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (value) {
                      _sendMessage();
                      _messageController
                          .clear(); // Clear the text field after sending
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    maxLines: null, // Allow the text to wrap into new lines
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                    _messageController
                        .clear(); // Clear the text field after sending
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
