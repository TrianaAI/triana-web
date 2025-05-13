part of 'doctor_diagnosis_cubit.dart';

abstract class DoctorDiagnosisState {}

class DoctorDiagnosisInitial extends DoctorDiagnosisState {}

class DoctorDiagnosisLoading extends DoctorDiagnosisState {}

class DoctorDiagnosisLoaded extends DoctorDiagnosisState {
  final Diagnosis diagnosis;
  DoctorDiagnosisLoaded(this.diagnosis);
}

class DoctorDiagnosisError extends DoctorDiagnosisState {
  final String message;
  DoctorDiagnosisError(this.message);
}
