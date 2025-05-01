import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'front_counter_state.dart';

class FrontCounterCubit extends Cubit<FrontCounterState> {
  FrontCounterCubit() : super(FrontCounterInitial());
}
