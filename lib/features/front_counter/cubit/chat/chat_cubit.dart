import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:triana_web/features/front_counter/models/queue.dart';
import 'package:triana_web/services/network.dart';
import 'package:triana_web/utils/constants.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final NetworkService networkService;
  ChatCubit(this.networkService) : super(ChatInitial());

  String? _session;

  final List<Map<String, String>> _messages = [
    {'sender': 'User', 'message': 'Hello!'},
  ];

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  void setSession(String session) {
    if (_session == null) {
      _session = session;
    } else if (_session != session) {
      _session = session;
      _messages.retainWhere(
        (message) =>
            message['sender'] == 'User' && message['message'] == 'Hello!',
      );
    }
  }

  Future<void> initializeChat(String session) async {
    setSession(session);
    emit(ChatLoading(messages));
    try {
      final response = await networkService
          .post('$kSessionUrl/$_session', data: {'new_message': 'Hello!'})
          .then((response) {
            if (response.statusCode == 200) {
              final data = QueueResponse.fromJson(response.data);
              if (data.reply != null) {
                _messages.add({'sender': 'Bot', 'message': data.reply!});
                emit(ChatUpdated(List.unmodifiable(_messages)));
              } else {
                emit(ChatError('Failed to initialize chat'));
              }
            } else {
              emit(ChatError('Failed to initialize chat'));
            }
          });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
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
        networkService
            .post('$kSessionUrl/$_session', data: {'new_message': message})
            .then((response) {
              print(response);
              if (response.statusCode == 200) {
                final data = QueueResponse.fromJson(response.data);
                if (data.reply != null) {
                  _messages.add({'sender': 'Bot', 'message': data.reply!});
                  emit(ChatUpdated(List.unmodifiable(_messages)));
                } else {
                  emit(ChatError('Failed to send message'));
                }
              } else {
                emit(ChatError('Failed to send message'));
              }
            })
            .catchError((e) {
              emit(ChatError(e.toString()));
            });
      });
    }
  }
}
