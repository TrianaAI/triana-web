import 'package:flutter/material.dart';
import 'package:triana_web/features/front_counter/models/form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:triana_web/features/front_counter/cubit/chat/chat_cubit.dart';

class ChatView extends StatefulWidget {
  final IdentityFormModel? identityForm;
  const ChatView({super.key, this.identityForm});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the chat with the identity form data if available
    if (widget.identityForm != null) {
      context.read<ChatCubit>().initializeChat(widget.identityForm!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Triana')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatUpdated) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          state.messages[state.messages.length - 1 - index];
                      final isUser = message['sender'] == 'User';
                      return Align(
                        alignment:
                            isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
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
                  );
                }
                return const Center(child: CircularProgressIndicator());
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
                      context.read<ChatCubit>().sendMessage(value);
                      _messageController.clear();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    context.read<ChatCubit>().sendMessage(
                      _messageController.text,
                    );
                    _messageController.clear();
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
