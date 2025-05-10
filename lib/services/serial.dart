part of 'services.dart';

class SerialService {
  SerialPort? _port;
  web.ReadableStreamDefaultReader? _reader;
  bool _keepReading = true;
  bool _isPortOpen = false;

  final List<Uint8List> _receivedMessages = [];
  final StreamController<List<Uint8List>> _messageController =
      StreamController.broadcast();

  // Buffer for accumulating data
  List<int> _dataBuffer = [];
  final String _delimiter = '\n'; // You can change this to '\r\n' if needed

  Stream<List<Uint8List>> get messageStream => _messageController.stream;

  Future<void> openPort({int baudRate = 115200}) async {
    if (_port != null) {
      await closePort();
    }

    try {
      _isPortOpen = true;
      _keepReading = true;
      _receivedMessages.clear();
      _dataBuffer.clear();

      final port = await web.window.navigator.serial.requestPort().toDart;
      await port.open(baudRate: baudRate).toDart;

      _port = port;
      _startReceiving(port);
    } catch (e) {
      _isPortOpen = false;
      rethrow;
    }
  }

  Future<void> writeToPort(Uint8List data) async {
    if (data.isEmpty || _port == null) return;

    final writer = _port?.writable?.getWriter();
    if (writer != null) {
      await writer.write(data.toJS).toDart;
      writer.releaseLock();
    }
  }

  Future<void> _startReceiving(SerialPort port) async {
    while (port.readable != null && _keepReading) {
      final reader =
          port.readable!.getReader() as web.ReadableStreamDefaultReader;
      _reader = reader;

      try {
        while (_keepReading) {
          final result = await reader.read().toDart;

          if (result.done) break;

          final value = result.value;
          if (value != null && value.isA<JSUint8Array>()) {
            final data = (value as JSUint8Array).toDart;
            _processIncomingData(data);
          }
        }
      } catch (e) {
        _messageController.addError(e);
      } finally {
        reader.releaseLock();
      }
    }
  }

  void _processIncomingData(Uint8List newData) {
    // Add new data to buffer
    _dataBuffer.addAll(newData);

    // Convert buffer to string for delimiter checking
    final bufferString = String.fromCharCodes(_dataBuffer);

    // Check for complete messages
    final delimiterIndex = bufferString.indexOf(_delimiter);
    if (delimiterIndex != -1) {
      // Extract complete message
      final message = _dataBuffer.sublist(0, delimiterIndex);
      _receivedMessages.add(Uint8List.fromList(message));
      _messageController.add(List.unmodifiable(_receivedMessages));

      // Remove processed message from buffer
      _dataBuffer = _dataBuffer.sublist(delimiterIndex + _delimiter.length);

      // Check if there are more complete messages in buffer
      if (_dataBuffer.isNotEmpty) {
        _processIncomingData(Uint8List(0)); // Process remaining data
      }
    }
    // If you want to handle incomplete messages after timeout, add that logic here
  }

  Future<void> closePort() async {
    if (_port == null) return;

    _isPortOpen = false;
    _keepReading = false;

    await _reader?.cancel().toDart;
    await _port?.close().toDart;

    _reader = null;
    _port = null;
    _dataBuffer.clear();
  }

  List<Uint8List> get receivedMessages => List.unmodifiable(_receivedMessages);
  SerialPort? get port => _port;
  bool get isPortOpen => _isPortOpen;
}
