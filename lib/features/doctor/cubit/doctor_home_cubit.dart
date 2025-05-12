import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:triana_web/features/doctor/models/doctor_home_model.dart';

part 'doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState> {
  DoctorHomeCubit() : super(DoctorHomeInitial());

  final Dio _dio = Dio();

  Future<void> fetchDoctor(String doctorId) async {
    emit(DoctorHomeLoading());
    try {
      final response = await _dio.get(
        'https://your-api.com/doctor/$doctorId/home',
      );
      final summary = Doctor.fromJson(response.data);
      emit(DoctorHomeLoaded(summary));
    } catch (e) {
      emit(DoctorHomeError('Failed to load doctor summary'));
    }
  }
}
