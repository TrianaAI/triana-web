import 'package:flutter/material.dart';
import 'package:triana_web/features/front_counter/cubit/queue/queue_cubit.dart';
import 'package:triana_web/features/front_counter/models/queue.dart';
import 'package:triana_web/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QueueNumber extends StatefulWidget {
  final QueueData queueData;
  const QueueNumber({super.key, required this.queueData});

  @override
  State<QueueNumber> createState() => _QueueNumberState();
}

class _QueueNumberState extends State<QueueNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<QueueCubit, QueueState>(
        builder: (context, state) {
          int queueNumber = 0;
          if (state is QueueUpdated) {
            queueNumber = state.queueNumber;
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dr. Ali', style: TextStyle(fontSize: 32)),
                spacerHeight(20),
                const Text('Room 101', style: TextStyle(fontSize: 24)),
                spacerHeight(20),
                const Text(
                  'Your Queue Number is',
                  style: TextStyle(fontSize: 24),
                ),
                spacerHeight(20),
                Text(
                  queueNumber.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                spacerHeight(20),
                const Text(
                  'Please wait for your turn',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
