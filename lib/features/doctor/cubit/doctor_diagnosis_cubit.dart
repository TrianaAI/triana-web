import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:triana_web/features/doctor/models/doctor_diagnosis_model.dart';

part 'doctor_diagnosis_state.dart';

class DoctorDiagnosisCubit extends Cubit<DoctorDiagnosisState> {
  DoctorDiagnosisCubit() : super(DoctorDiagnosisInitial());

  final Dio _dio = Dio();

  Future<void> fetchDiagnosis(String userId) async {
    emit(DoctorDiagnosisLoading());
    try {
      final response = await _dio.get(
        'https://apidev-triana.sportsnow.app/user/$userId',
      );

      final summary = Diagnosis.fromJson(response.data);

      emit(DoctorDiagnosisLoaded(summary));
    } catch (e) {
      emit(DoctorDiagnosisError('Failed to load doctor summary'));
    }
  }
}
