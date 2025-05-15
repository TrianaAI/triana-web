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
        // Process all responses from device, not just those containing 'Triana'
        String processedData = data.trim();

        // Try to parse as number to identify sensor readings
        double? numValue = double.tryParse(processedData);
        if (numValue != null) {
          // This is likely a temperature or heart rate reading, format it accordingly
          String lastCommand = _getLastCommand();
          if (lastCommand.contains('mlx')) {
            processedData = "Temperature: ${numValue.toStringAsFixed(1)}°C";
          } else if (lastCommand.contains('pulse')) {
            processedData = "Heart Rate: ${numValue.toInt()} BPM";
          }
        }

        _messages.add(_Message(processedData, false));
        emit(BluetoothDataReceived(List.from(_messages)));
      });
    } catch (e) {
      emit(BluetoothError(e.toString()));
    }
  }

  String _getLastCommand() {
    // Find the last command sent by the user
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].isSender) {
        return _messages[i].text.toLowerCase();
      }
    }
    return "";
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

  // Add a message as if it came from the device
  void addDeviceMessage(String message) {
    if (message.trim().isEmpty) return;

    _messages.add(_Message(message, false));
    emit(BluetoothDataReceived(List.from(_messages)));
  }

  bool get isConnected => _bluetoothService.isConnected;
}
