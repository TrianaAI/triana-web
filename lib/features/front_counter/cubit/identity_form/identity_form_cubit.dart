import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:triana_web/features/front_counter/models/form.dart';

part 'identity_form_state.dart';

class IdentityFormCubit extends Cubit<IdentityFormState> {
  IdentityFormCubit() : super(IdentityFormInitial());

  void submitForm(IdentityFormModel form) {
    emit(IdentityFormLoading());
    try {
      // Simulate form submission logic
      Future.delayed(const Duration(seconds: 2), () {
        emit(IdentityFormSuccess());
      });
    } catch (e) {
      emit(IdentityFormFailure(error: e.toString()));
    }
  }
}
