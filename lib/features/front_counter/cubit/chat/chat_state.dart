part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatUpdated extends ChatState {
  final List<Map<String, String>> messages;

  const ChatUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}

final class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object> get props => [error];
}
