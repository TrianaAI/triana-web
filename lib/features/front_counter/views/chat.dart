import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:triana_web/features/front_counter/cubit/chat/chat_cubit.dart';
import 'dart:async';

import 'package:triana_web/utils/pallete.dart';

class ChatView extends StatefulWidget {
  final String session;
  const ChatView({super.key, required this.session});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messageController = TextEditingController();
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().initializeChat(widget.session);
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 1), () {
      if (mounted) {
        Modular.to.navigate('/');
      }
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetInactivityTimer,
      child: Scaffold(
        appBar: AppBar(title: const Text('Triana'), centerTitle: true),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatUpdated) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            state.messages[state.messages.length - 1 - index];
                        final isUser = message['sender'] == 'User';
                        return BubbleSpecialOne(
                          text: message['message']!,
                          isSender: isUser,
                          color: isUser ? kPrimaryColor : Colors.grey.shade300,
                          textStyle: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                          ),
                        );
                      },
                    );
                  }
                  if (state is ChatLoading) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      reverse: true,
                      itemCount:
                          state.previousMessages.length +
                          1, // Add 1 for the loading indicator
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Align(
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
                          );
                        }
                        final message =
                            state.previousMessages[state
                                    .previousMessages
                                    .length -
                                index];
                        final isUser = message['sender'] == 'User';
                        return BubbleSpecialOne(
                          text: message['message']!,
                          isSender: isUser,
                          color: isUser ? kPrimaryColor : Colors.grey.shade300,
                          textStyle: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                          ),
                        );
                      },
                    );
                  }
                  if (state is ChatError) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      'No messages yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
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
                  // BlocBuilder<ChatCubit, ChatState>(
                  //   builder: (context, state) {
                  //     if (state is ChatUpdated && state.messages.length >= 4) {
                  //       return Container(
                  //         height: 40,
                  //         margin: const EdgeInsets.only(bottom: 8, top: 8),
                  //         padding: const EdgeInsets.all(2),
                  //         child: ListView(
                  //           scrollDirection: Axis.horizontal,
                  //           children: [
                  //             GestureDetector(
                  //               onTap: () {
                  //                 context.read<ChatCubit>().sendMessage("Done");
                  //                 _messageController.clear();
                  //               },
                  //               child: Container(
                  //                 margin: const EdgeInsets.only(right: 8),
                  //                 padding: const EdgeInsets.all(8),
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.blue[100],
                  //                   borderRadius: BorderRadius.circular(10),
                  //                 ),
                  //                 child: Center(
                  //                   child: Text(
                  //                     "Done/selesai",
                  //                     style: const TextStyle(fontSize: 16),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }
                  //     return const SizedBox.shrink();
                  //   },
                  // ),
                  BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatUpdated && state.messages.length >= 4) {
                        return Container(
                          height: 40,
                          width: 180,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: () {
                              context.read<ChatCubit>().sendMessage(
                                context,
                                "Done",
                                // widget.session,
                              );
                              _messageController.clear();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Done/selesai",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
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
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          onSubmitted: (value) {
                            _resetInactivityTimer();
                            context.read<ChatCubit>().sendMessage(
                              context,
                              value,
                              // widget.session,
                            );
                            _messageController.clear();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          _resetInactivityTimer();
                          context.read<ChatCubit>().sendMessage(
                            context,
                            _messageController.text,
                            // widget.session,
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
      ),
    );
  }
}
