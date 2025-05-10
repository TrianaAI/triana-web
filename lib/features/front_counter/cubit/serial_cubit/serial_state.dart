import 'package:equatable/equatable.dart';
import 'dart:typed_data';

part of 'serial_cubit.dart';

abstract class SerialState extends Equatable {
  const SerialState();

  @override
  List<Object> get props => [];
}

class SerialCubitInitial extends SerialState {}

class SerialCubitLoading extends SerialState {}

class SerialCubitPortOpened extends SerialState {}

class SerialCubitPortClosed extends SerialState {}

class SerialCubitDataWritten extends SerialState {}

class SerialCubitDataReceived extends SerialState {
  final List<Uint8List> receivedData;
  
  const SerialCubitDataReceived(this.receivedData);

  @override
  List<Object> get props => [receivedData];
}

class SerialCubitError extends SerialState {
  final String message;
  
  const SerialCubitError(this.message);

  @override
  List<Object> get props => [message];
}