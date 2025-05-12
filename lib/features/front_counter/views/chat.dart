import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:triana_web/features/front_counter/cubit/chat/chat_cubit.dart';

class ChatView extends StatefulWidget {
  final String session;
  const ChatView({super.key, required this.session});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().initializeChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Triana'), centerTitle: true),
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
                      return BubbleSpecialOne(
                        text: message['message']!,
                        isSender: isUser,
                        color: isUser ? Colors.blue : Colors.grey.shade300,
                        textStyle: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      );
                    },
                  );
                }
                if (state is ChatLoading) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: state.previousMessages.length,
                          itemBuilder: (context, index) {
                            final message = state.previousMessages[index];
                            final isUser = message['sender'] == 'User';
                            return BubbleSpecialOne(
                              text: message['message']!,
                              isSender: isUser,
                              color:
                                  isUser ? Colors.blue : Colors.grey.shade300,
                              textStyle: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                fontSize: 26,
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const CircularProgressIndicator(strokeWidth: 2),
                            const SizedBox(width: 10),
                            Text(
                              'Typing...',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Column(
              children: [
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state is ChatUpdated && state.messages.length >= 4) {
                      return Container(
                        height: 40,
                        margin: const EdgeInsets.only(bottom: 8, top: 8),
                        padding: const EdgeInsets.all(2),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<ChatCubit>().sendMessage("Done");
                                _messageController.clear();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Done/selesai",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Row(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
