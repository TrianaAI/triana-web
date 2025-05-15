part of 'doctor_diagnosis_cubit.dart';

abstract class DoctorDiagnosisState {}

class DoctorDiagnosisInitial extends DoctorDiagnosisState {}

class DoctorDiagnosisLoading extends DoctorDiagnosisState {}

class DoctorDiagnosisLoaded extends DoctorDiagnosisState {
  final Diagnosis diagnosis;
  final String doctorId;
  DoctorDiagnosisLoaded(this.diagnosis, this.doctorId);
}

class DoctorDiagnosisError extends DoctorDiagnosisState {
  final String message;
  DoctorDiagnosisError(this.message);
}
