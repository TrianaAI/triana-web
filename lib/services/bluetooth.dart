part of 'services.dart';

const serviceUuid = '12345678-1234-1234-1234-123456789abc';
const characteristicUuid = '87654321-4321-4321-4321-cba987654321';

class BluetoothService {
  BlueDevice? _device;
  BlueRemoteGATTService? _service;
  BlueRemoteGATTCharacteristic? _characteristic;

  Future<void> connectToDevice() async {
    _device = await blue.requestDevice(
      RequestOptions(
        optionalServices: [BlueUUID.getService(serviceUuid)],
        acceptAllDevices: true,
      ),
    );
    await _device!.gatt.connect();

    _service = await _device!.gatt.getPrimaryService(
      BlueUUID.getService(serviceUuid),
    );
    _characteristic = await _service!.getCharacteristic(
      BlueUUID.getCharacteristic(characteristicUuid),
    );

    await _characteristic!.startNotifications();
  }

  void subscribeToNotifications(Function(String) onDataReceived) {
    if (_characteristic == null) return;

    _characteristic!.subscribeValueChanged((event) {
      final BlueRemoteGATTCharacteristic char = BlueRemoteGATTCharacteristic(
        event.target!,
      );
      final data = String.fromCharCodes(char.value.buffer.asUint8List());
      onDataReceived(data);
    });
  }

  Future<void> sendMessage(String text) async {
    if (_characteristic == null || text.isEmpty) return;

    final bytes = Uint8List.fromList(text.codeUnits);
    await _characteristic!.writeValueWithResponse(bytes);
  }

  Future<void> disconnect() async {
    _device?.gatt.disconnect();
    _device = null;
    _service = null;
    _characteristic = null;
  }

  get device => _device;
  get service => _service;
  get characteristic => _characteristic;
}
