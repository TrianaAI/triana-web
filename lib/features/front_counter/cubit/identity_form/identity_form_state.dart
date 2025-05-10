part of 'identity_form_cubit.dart';

sealed class IdentityFormState extends Equatable {
  const IdentityFormState();

  @override
  List<Object?> get props => [];
}

final class IdentityFormInitial extends IdentityFormState {}

final class IdentityFormLoading extends IdentityFormState {}

final class IdentityFormSuccess extends IdentityFormState {}

final class IdentityFormFailure extends IdentityFormState {
  final String error;

  const IdentityFormFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class IdentityFormBPMReading extends IdentityFormState {
  @override
  List<Object> get props => [];
}

class IdentityFormBPMSuccess extends IdentityFormState {
  final int bpm;

  const IdentityFormBPMSuccess(this.bpm);

  @override
  List<Object> get props => [bpm];
}

class IdentityFormBPMFailure extends IdentityFormState {
  final String error;

  const IdentityFormBPMFailure(this.error);

  @override
  List<Object> get props => [error];
}
