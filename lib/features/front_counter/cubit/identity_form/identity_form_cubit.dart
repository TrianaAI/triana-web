import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:triana_web/features/front_counter/models/form.dart';
import 'package:triana_web/utils/utils.dart';
import 'package:triana_web/features/front_counter/cubit/serial_cubit/serial_cubit.dart';
import 'dart:async';
import 'dart:typed_data';

part 'identity_form_state.dart';

class IdentityFormCubit extends Cubit<IdentityFormState> {
  final SerialCubit serialCubit;
  StreamSubscription? _serialSubscription;
  Completer<double>? _temperatureCompleter;
  Completer<int>? _bpmCompleter;

  IdentityFormCubit({required this.serialCubit}) : super(IdentityFormInitial());

  void submitForm(IdentityFormModel form, BuildContext ctx) {
    emit(IdentityFormLoading());
    try {
      // Simulate form submission logic
      // Future.delayed(const Duration(seconds: 2), () {
      //   emit(IdentityFormSuccess());
      // });
      showOtpDialog(ctx, form);
    } catch (e) {
      emit(IdentityFormFailure(error: e.toString()));
    }
  }

  Future<void> getBodyTemp(
    BuildContext ctx,
    TextEditingController controller,
  ) async {
    // Show loading overlay
    LoadingOverlay.show(
      ctx,
      GestureDetector(
        onTap: () {
          // Allow manual dismissal but only if we haven't received temperature yet
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
      // Create a completer to wait for the temperature value
      _temperatureCompleter = Completer<double>();

      // Set up a listener for serial data
      _serialSubscription?.cancel();
      _serialSubscription = serialCubit.stream.listen((state) {
        if (state is SerialCubitDataReceived) {
          _handleTemperatureData(state.receivedData.last);
        }
      });

      // Send the command to start temperature reading
      serialCubit.writeToPort(Uint8List.fromList('start mlx\n'.codeUnits));

      // Wait for the temperature value with timeout
      final temperature = await _temperatureCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Temperature reading timed out');
        },
      );

      // Set the value to controller
      controller.text = temperature.toStringAsFixed(2);

      // Hide the overlay
      LoadingOverlay.hide();
    } catch (e) {
      LoadingOverlay.hide();
      // Optionally show error to user
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('Failed to read temperature: ${e.toString()}')),
      );
    } finally {
      _temperatureCompleter = null;
      _serialSubscription?.cancel();
    }
  }

  void _handleTemperatureData(Uint8List data) {
    if (_temperatureCompleter?.isCompleted == true) return;

    try {
      final message = String.fromCharCodes(data).trim();
      final temperature = double.tryParse(message);

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
    // Show loading overlay
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
      // Create a completer to wait for the BPM value
      _bpmCompleter = Completer<int>();
      emit(IdentityFormBPMReading());

      // Set up a listener for serial data
      _serialSubscription?.cancel();
      _serialSubscription = serialCubit.stream.listen((state) {
        if (state is SerialCubitDataReceived) {
          _handleBPMData(state.receivedData.last);
        }
      });

      // Send the command to start pulse reading
      serialCubit.writeToPort(Uint8List.fromList('start pulse\n'.codeUnits));

      // Wait for the BPM value with timeout
      final bpm = await _bpmCompleter!.future.timeout(
        const Duration(seconds: 30), // Longer timeout for BPM reading
        onTimeout: () => throw TimeoutException('Pulse reading timed out'),
      );

      // Set the value to controller
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
      _serialSubscription?.cancel();
    }
  }

  void _handleBPMData(Uint8List data) {
    if (_bpmCompleter?.isCompleted == true) return;

    try {
      final message = String.fromCharCodes(data).trim();
      final bpm = int.tryParse(message);

      if (bpm != null && bpm > 30 && bpm < 200) {
        // Validate reasonable BPM range
        if (!_bpmCompleter!.isCompleted) {
          _bpmCompleter!.complete(bpm);
        }
      }
    } catch (e) {
      if (!_bpmCompleter!.isCompleted) {
        _bpmCompleter!.completeError(e);
      }
    }
  }

  @override
  Future<void> close() {
    _serialSubscription?.cancel();
    _temperatureCompleter?.completeError('Cancelled');
    return super.close();
  }
}
