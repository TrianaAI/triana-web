import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:triana_web/services/services.dart';

part 'serial_state.dart';

class SerialCubit extends Cubit<SerialState> {
  final SerialService _serialService;
  StreamSubscription<List<Uint8List>>? _dataSubscription;

  SerialCubit(this._serialService) : super(SerialCubitInitial()) {
    _setupDataListener();
  }

  void _setupDataListener() {
    _dataSubscription?.cancel();
    _dataSubscription = _serialService.messageStream.listen(
      (data) {
        emit(SerialCubitDataReceived(data));
      },
      onError: (error) {
        emit(SerialCubitError(error.toString()));
      },
    );
  }

  Future<void> openPort({int baudRate = 115200}) async {
    try {
      emit(SerialCubitLoading());
      await _serialService.openPort(baudRate: baudRate);
      _setupDataListener(); // Re-setup listener when port is reopened
      emit(SerialCubitPortOpened());
    } catch (e) {
      emit(SerialCubitError(e.toString()));
    }
  }

  Future<void> writeToPort(Uint8List data) async {
    try {
      emit(SerialCubitLoading());
      await _serialService.writeToPort(data);
      // emit(SerialCubitDataWritten());
    } catch (e) {
      emit(SerialCubitError(e.toString()));
    }
  }

  Future<void> closePort() async {
    try {
      emit(SerialCubitLoading());
      await _serialService.closePort();
      emit(SerialCubitPortClosed());
    } catch (e) {
      emit(SerialCubitError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    return super.close();
  }
}
