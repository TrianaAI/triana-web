// filepath: /Users/dzin/Adzin/Program/triana-web/lib/features/front_counter/cubit/chat/chat_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:triana_web/features/front_counter/models/queue.dart';
import 'package:triana_web/services/network.dart';
import 'package:triana_web/utils/constants.dart';
import 'package:triana_web/utils/pallete.dart';

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
      final response = await networkService.post(
        '$kSessionUrl/$_session',
        data: {'new_message': 'Hello!'},
      );

      if (response.statusCode == 200 && response.data != null) {
        try {
          final data = QueueResponse.fromJson(response.data);
          if (data.reply != null) {
            _messages.add({'sender': 'Bot', 'message': data.reply!});
            emit(ChatUpdated(List.unmodifiable(_messages)));
          } else {
            emit(ChatError('No reply received from server'));
          }
        } catch (e) {
          emit(ChatError('Error parsing response: ${e.toString()}'));
        }
      } else {
        emit(
          ChatError('Failed to initialize chat: Status ${response.statusCode}'),
        );
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void loadMessages() {
    emit(ChatUpdated(List.unmodifiable(_messages)));
  }

  void sendMessage(BuildContext ctx, String message) {
    if (message.isNotEmpty) {
      // Add user message immediately
      _messages.add({'sender': 'User', 'message': message});
      emit(ChatUpdated(List.unmodifiable(_messages)));

      // Show typing indicator immediately
      emit(ChatLoading(List.unmodifiable(_messages)));

      networkService
          .post('$kSessionUrl/$_session', data: {'new_message': message})
          .then((response) {
            print('Response: ${response.data}');
            if (response.statusCode == 200 && response.data != null) {
              try {
                final data = QueueResponse.fromJson(response.data);
                if (data.reply != null) {
                  _messages.add({'sender': 'Bot', 'message': data.reply!});
                  emit(ChatUpdated(List.unmodifiable(_messages)));

                  if (data.nextAction.trim().toUpperCase() == "APPOINTMENT") {
                    // Ensure the dialog logic is triggered
                    print('Appointment action triggered');
                    showDialog(
                      context: ctx,
                      barrierDismissible:
                          false, // Prevent dismissing by tapping outside
                      builder: (BuildContext dialogContext) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 500, // Maximum width
                              minWidth: 300, // Minimum width
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Appointment Confirmed',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildDetailRow(
                                        icon: Icons.person,
                                        label: 'Doctor:',
                                        value:
                                            data.queue?.doctor?.name ?? 'N/A',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDetailRow(
                                        icon: Icons.meeting_room,
                                        label: 'Room:',
                                        value:
                                            data.queue?.doctor?.roomNo ?? 'N/A',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDetailRow(
                                        icon: Icons.confirmation_number,
                                        label: 'Queue Number:',
                                        value:
                                            data.queue?.number.toString() ??
                                            'N/A',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Please check your email for detailed confirmation',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      Navigator.pushNamedAndRemoveUntil(
                                        ctx,
                                        '/', // Navigate back to the splash screen
                                        (route) => false,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Okay, Got it!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  emit(ChatError('No reply received from server'));
                }
              } catch (e) {
                emit(ChatError('Error parsing response: ${e.toString()}'));
              }
            } else {
              emit(
                ChatError(
                  'Failed to send message: Status ${response.statusCode}',
                ),
              );
            }
          })
          .catchError((e) {
            emit(ChatError(e.toString()));
          });
    }
  }
}

Widget _buildDetailRow({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: Colors.grey[600]),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
