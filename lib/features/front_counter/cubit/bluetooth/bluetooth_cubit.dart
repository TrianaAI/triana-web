import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:triana_web/services/services.dart';

part 'bluetooth_state.dart';

class BluetoothCubit extends Cubit<BluetoothState> {
  final BluetoothService _bluetoothService;
  final List<_Message> _messages = [];

  BluetoothCubit(this._bluetoothService) : super(BluetoothInitial());

  Future<void> connectToDevice() async {
    try {
      emit(BluetoothLoading());
      await _bluetoothService.connectToDevice();
      emit(BluetoothConnected());
      subscribeToNotifications(); // Auto-subscribe on connect
    } catch (e) {
      emit(BluetoothError(e.toString()));
    }
  }

  void subscribeToNotifications() {
    try {
      _bluetoothService.subscribeToNotifications((data) {
        _messages.add(_Message(data, false));
        emit(BluetoothDataReceived(List.from(_messages)));
      });
    } catch (e) {
      emit(BluetoothError(e.toString()));
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _messages.add(_Message(message, true)); // Add message immediately
    emit(
      BluetoothDataReceived(List.from(_messages)),
    ); // Update UI before sending

    try {
      await _bluetoothService.sendMessage(message);
    } catch (e) {
      emit(BluetoothError(e.toString()));
    }
  }

  Future<void> disconnect() async {
    try {
      emit(BluetoothLoading());
      await _bluetoothService.disconnect();
      emit(BluetoothDisconnected());
    } catch (e) {
      emit(BluetoothError(e.toString()));
    }
  }

  bool get isConnected => _bluetoothService.isConnected;
}
