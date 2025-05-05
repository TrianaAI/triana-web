import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  QueueCubit() : super(QueueInitial());

  int _queueNumber = 0;

  int get queueNumber => _queueNumber;

  void updateQueueNumber(int newQueueNumber) {
    _queueNumber = newQueueNumber;
    emit(QueueUpdated(newQueueNumber));
  }
}
