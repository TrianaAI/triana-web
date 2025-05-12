import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final List<Map<String, String>> _messages = [
    {'sender': 'Bot', 'message': 'Hi there! How can I help you today?'},
  ];

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  void initializeChat() {
    print('Initializing chat...');
    // Initialize the chat with the identity form data
    // _messages.add({
    //   'sender': 'User',
    //   'message': 'Hello, my name is ${identityForm.name}.',
    // });
    emit(ChatUpdated(List.unmodifiable(_messages)));
  }

  void loadMessages() {
    emit(ChatUpdated(List.unmodifiable(_messages)));
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      // Simulate a delay for loading state
      _messages.add({'sender': 'User', 'message': message});
      emit(ChatUpdated(List.unmodifiable(_messages)));
      Future.delayed(const Duration(seconds: 1), () {
        emit(ChatLoading(List.unmodifiable(_messages)));
        // TODO: Get a response from the bot
        emit(ChatUpdated(List.unmodifiable(_messages)));
      });
    }
  }
}
