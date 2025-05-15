import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:triana_web/features/doctor/models/doctor_home_model.dart';

part 'doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState> {
  DoctorHomeCubit() : super(DoctorHomeInitial());

  final Dio _dio = Dio();

  Future<void> fetchDoctor(String doctorId) async {
    emit(DoctorHomeLoading());
    if (doctorId.isEmpty) {
      emit(DoctorHomeError('Invalid doctor ID'));
      return;
    }
    try {
      final response = await _dio.get(
        'https://apidev-triana.sportsnow.app/doctor/$doctorId',
      );

      print(
        'API Response: ${response.data}',
      ); // Debug log to inspect the API response

      final summary = Doctor.fromJson(response.data);

      emit(DoctorHomeLoaded(summary));
      emit(DoctorHomeLoaded(summary)); // Re-emit the state to ensure UI refresh
    } catch (e) {
      print('Error: $e'); // Debug log for errors
      emit(DoctorHomeError('Failed to load doctor summary'));
    }
  }
}
