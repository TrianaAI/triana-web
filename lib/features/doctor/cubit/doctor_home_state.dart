part of 'doctor_home_cubit.dart';

abstract class DoctorHomeState {}

class DoctorHomeInitial extends DoctorHomeState {}

class DoctorHomeLoading extends DoctorHomeState {}

class DoctorHomeLoaded extends DoctorHomeState {
  final Doctor doctor;
  DoctorHomeLoaded(this.doctor);
}

class DoctorHomeError extends DoctorHomeState {
  final String message;
  DoctorHomeError(this.message);
}
