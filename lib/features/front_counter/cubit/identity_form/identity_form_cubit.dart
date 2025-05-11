import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:triana_web/features/front_counter/cubit/bluetooth/bluetooth_cubit.dart';
import 'package:triana_web/features/front_counter/models/form.dart';
import 'package:triana_web/services/network.dart';
import 'package:triana_web/utils/constants.dart';
import 'package:triana_web/utils/utils.dart';
import 'package:triana_web/features/front_counter/cubit/serial_cubit/serial_cubit.dart';
import 'dart:async';
import 'dart:typed_data';

part 'identity_form_state.dart';

class IdentityFormCubit extends Cubit<IdentityFormState> {
  final BluetoothCubit bluetoothCubit;
  StreamSubscription? _bluetoothSubscription;
  Completer<double>? _temperatureCompleter;
  Completer<int>? _bpmCompleter;
  NetworkService networkService = NetworkService();

  IdentityFormCubit({required this.bluetoothCubit})
    : super(IdentityFormInitial());

  void submitForm(IdentityFormModel form, BuildContext ctx) async {
    emit(IdentityFormLoading());
    try {
      final response = await networkService.post(
        kRegisterUrl,
        data: form.toJson(),
      );
      if (response.statusCode == 200) {
        emit(IdentityFormSuccess());
        showOtpDialog(ctx, form);
      } else {
        emit(IdentityFormFailure(error: 'Failed to submit form'));
      }
    } catch (e) {
      emit(IdentityFormFailure(error: e.toString()));
    }
  }

  Future<void> getBodyTemp(
    BuildContext ctx,
    TextEditingController controller,
  ) async {
    LoadingOverlay.show(
      ctx,
      GestureDetector(
        onTap: () {
          if (_temperatureCompleter?.isCompleted == false) {
            _temperatureCompleter?.completeError('User cancelled');
            LoadingOverlay.hide();
          }
        },
        child: Container(
          width: 400,
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text('Place your finger at the front of the sensor'),
          ),
        ),
      ),
    );

    try {
      _temperatureCompleter = Completer<double>();

      _bluetoothSubscription?.cancel();
      _bluetoothSubscription = bluetoothCubit.stream.listen((state) {
        if (state is BluetoothDataReceived) {
          if (state.messages.isNotEmpty) {
            _handleTemperatureData(state.messages.last.text);
          }
        }
      });

      bluetoothCubit.sendMessage('start mlx');

      final temperature = await _temperatureCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout:
            () => throw TimeoutException('Temperature reading timed out'),
      );

      controller.text = temperature.toStringAsFixed(2);
      LoadingOverlay.hide();
    } catch (e) {
      LoadingOverlay.hide();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('Failed to read temperature: ${e.toString()}')),
      );
    } finally {
      _temperatureCompleter = null;
      _bluetoothSubscription?.cancel();
    }
  }

  void _handleTemperatureData(String message) {
    if (_temperatureCompleter?.isCompleted == true) return;

    try {
      final temperature = double.tryParse(message.trim());
      if (temperature != null && !_temperatureCompleter!.isCompleted) {
        _temperatureCompleter!.complete(temperature);
      }
    } catch (e) {
      if (!_temperatureCompleter!.isCompleted) {
        _temperatureCompleter!.completeError(e);
      }
    }
  }

  Future<void> getBPM(
    BuildContext ctx,
    TextEditingController controller,
  ) async {
    final overlay = LoadingOverlay.show(
      ctx,
      GestureDetector(
        onTap: () {
          if (_bpmCompleter?.isCompleted == false) {
            _bpmCompleter?.completeError('User cancelled');
            LoadingOverlay.hide();
          }
        },
        child: Container(
          width: 400,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Place your finger on the pulse sensor'),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );

    try {
      _bpmCompleter = Completer<int>();
      emit(IdentityFormBPMReading());

      _bluetoothSubscription?.cancel();
      _bluetoothSubscription = bluetoothCubit.stream.listen((state) {
        if (state is BluetoothDataReceived) {
          if (state.messages.isNotEmpty) {
            _handleBPMData(state.messages.last.text);
          }
        }
      });

      bluetoothCubit.sendMessage('start pulse');

      final bpm = await _bpmCompleter!.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Pulse reading timed out'),
      );

      controller.text = bpm.toString();
      emit(IdentityFormBPMSuccess(bpm));
    } catch (e) {
      emit(IdentityFormBPMFailure(e.toString()));
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('Failed to read pulse: ${e.toString()}')),
      );
    } finally {
      LoadingOverlay.hide();
      _bpmCompleter = null;
      _bluetoothSubscription?.cancel();
    }
  }

  void _handleBPMData(String message) {
    if (_bpmCompleter?.isCompleted == true) return;

    try {
      final bpm = int.tryParse(message.trim());
      if (bpm != null && bpm > 30 && bpm < 200 && !_bpmCompleter!.isCompleted) {
        _bpmCompleter!.complete(bpm);
      }
    } catch (e) {
      if (!_bpmCompleter!.isCompleted) {
        _bpmCompleter!.completeError(e);
      }
    }
  }

  @override
  Future<void> close() {
    _bluetoothSubscription?.cancel();
    _temperatureCompleter?.completeError('Cancelled');
    _bpmCompleter?.completeError('Cancelled');
    return super.close();
  }
}
