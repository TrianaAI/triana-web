import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:triana_web/features/front_counter/models/form.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final List<Map<String, String>> _messages = [
    {'sender': 'User', 'message': 'Hello!'},
    {'sender': 'Bot', 'message': 'Hi there! How can I help you today?'},
    {'sender': 'User', 'message': 'I need some assistance with my account.'},
    {
      'sender': 'Bot',
      'message':
          'Sure, I can help with that. Could you please provide more details?',
    },
  ];

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  void initializeChat(IdentityFormModel identityForm) {
    // Initialize the chat with the identity form data
    _messages.add({
      'sender': 'User',
      'message': 'Hello, my name is ${identityForm.name}.',
    });
    emit(ChatUpdated(List.unmodifiable(_messages)));
  }

  void loadMessages() {
    emit(ChatUpdated(List.unmodifiable(_messages)));
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      emit(ChatLoading());
      // Simulate a delay for loading state
      Future.delayed(const Duration(seconds: 1), () {
        _messages.add({'sender': 'User', 'message': message});
        emit(ChatUpdated(List.unmodifiable(_messages)));
      });
      // In a real application, you would send the message to the server here
      // and wait for a response before updating the chat.
      // For example:
      // mqttService.publish('triana/device/1/bloodrate', message);
      // mqttService.subscribe('triana/device/1/bloodrate');
      // mqttService.onMessageReceived.listen((response) {
      //   _messages.add({'sender': 'Bot', 'message': response});
      //   emit(ChatUpdated(List.unmodifiable(_messages)));
      // });
      _messages.add({'sender': 'User', 'message': message});
      emit(ChatUpdated(List.unmodifiable(_messages)));
    }
  }
}
