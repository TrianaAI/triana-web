import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:triana_web/features/front_counter/cubit/chat/chat_cubit.dart';
import 'package:triana_web/utils/pallete.dart';

class ChatView extends StatefulWidget {
  final String session;
  const ChatView({super.key, required this.session});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().initializeChat(widget.session);
  }

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(context, text);
      _messageController.clear();

      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button navigation
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Triana'),
          centerTitle: true,
          automaticallyImplyLeading: false, // Removes the back button
          actions: [
            TextButton.icon(
              onPressed: () {
                Modular.to.navigate('/');
              },
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text(
                'End Session',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatUpdated) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            state.messages[state.messages.length - 1 - index];
                        final isUser = message['sender'] == 'User';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: BubbleSpecialOne(
                            text: message['message']!,
                            isSender: isUser,
                            color:
                                isUser ? kPrimaryColor : Colors.grey.shade300,
                            textStyle: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is ChatLoading) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      reverse: true,
                      itemCount:
                          state.previousMessages.length +
                          1, // Add 1 for the loading indicator
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Create an improved typing indicator
                          return Container(
                            margin: const EdgeInsets.only(
                              left: 20,
                              bottom: 16,
                              top: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildDot(Colors.grey.shade400),
                                const SizedBox(width: 5),
                                _buildDot(Colors.grey.shade500),
                                const SizedBox(width: 5),
                                _buildDot(Colors.grey.shade600),
                                const SizedBox(width: 10),
                                Text(
                                  'Typing...',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        final message =
                            state.previousMessages[state
                                    .previousMessages
                                    .length -
                                index];
                        final isUser = message['sender'] == 'User';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: BubbleSpecialOne(
                            text: message['message']!,
                            isSender: isUser,
                            color:
                                isUser ? kPrimaryColor : Colors.grey.shade300,
                            textStyle: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is ChatError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.error,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChatCubit>().initializeChat(
                                widget.session,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatUpdated && state.messages.length >= 4) {
                        return Container(
                          height: 40,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(2),
                          alignment: Alignment.center, // Center the button
                          child: GestureDetector(
                            onTap: () => _sendMessage("Done"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Enough (Cukup)", // Updated text
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          // Remove onSubmitted to prevent auto-send
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          // Change from TextInputAction.send to TextInputAction.newline
                          textInputAction: TextInputAction.newline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed:
                              () => _sendMessage(_messageController.text),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create typing indicator dots
  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
