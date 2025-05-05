part of 'queue_cubit.dart';

sealed class QueueState extends Equatable {
  const QueueState();

  @override
  List<Object> get props => [];
}

final class QueueInitial extends QueueState {}

final class QueueUpdated extends QueueState {
  final int queueNumber;

  const QueueUpdated(this.queueNumber);

  @override
  List<Object> get props => [queueNumber];
}
