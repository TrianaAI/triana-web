import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:triana_web/features/front_counter/cubit/serial_cubit/serial_cubit.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        centerTitle: true,
        actions: [
          BlocBuilder<SerialCubit, SerialState>(
            builder: (context, state) {
              final cubit = context.read<SerialCubit>();
              return Row(
                children: [
                  IconButton(
                    onPressed: cubit.openPort,
                    icon: const Icon(Icons.device_hub),
                    tooltip: 'Open Serial Port',
                  ),
                  IconButton(
                    onPressed:
                        state is SerialCubitPortOpened ? cubit.closePort : null,
                    icon: const Icon(Icons.close),
                    tooltip: 'Close Serial Port',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: BlocBuilder<SerialCubit, SerialState>(
                  builder: (context, state) {
                    if (state is SerialCubitDataReceived) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(4),
                        itemCount: state.receivedData.length,
                        itemBuilder: (context, index) {
                          final data = state.receivedData[index];
                          final text = String.fromCharCodes(data);
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(text),
                          );
                        },
                      );
                    } else if (state is SerialCubitError) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is SerialCubitLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Center(child: Text('No data received yet.'));
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Message to send',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    child: const Text('Send'),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        final cubit = context.read<SerialCubit>();
                        cubit.writeToPort(
                          Uint8List.fromList(_controller.text.codeUnits),
                        );
                        _controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
