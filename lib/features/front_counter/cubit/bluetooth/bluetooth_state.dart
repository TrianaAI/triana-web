part of 'bluetooth_cubit.dart';

abstract class BluetoothState extends Equatable {
  const BluetoothState();
  @override
  List<Object> get props => [];
}

class BluetoothInitial extends BluetoothState {}

class BluetoothLoading extends BluetoothState {}

class BluetoothConnected extends BluetoothState {}

class BluetoothDisconnected extends BluetoothState {}

class BluetoothError extends BluetoothState {
  final String message;
  const BluetoothError(this.message);

  @override
  List<Object> get props => [message];
}

class BluetoothMessageSent extends BluetoothState {
  final String message;
  const BluetoothMessageSent(this.message);

  @override
  List<Object> get props => [message];
}

class BluetoothDataReceived extends BluetoothState {
  final List<_Message> messages;
  const BluetoothDataReceived(this.messages);

  @override
  List<Object> get props => [messages];
}

class _Message {
  final String text;
  final bool isSender;

  const _Message(this.text, this.isSender);

  @override
  String toString() => 'Message(sender: $isSender, text: $text)';
}
