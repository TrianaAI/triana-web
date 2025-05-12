import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:triana_web/features/front_counter/cubit/bluetooth/bluetooth_cubit.dart';

class ConfigBlueView extends StatefulWidget {
  const ConfigBlueView({super.key});

  @override
  State<ConfigBlueView> createState() => _ConfigBlueViewState();
}

class _ConfigBlueViewState extends State<ConfigBlueView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Configuration'),
        centerTitle: true,
        actions: [
          BlocBuilder<BluetoothCubit, BluetoothState>(
            builder: (context, state) {
              final cubit = context.read<BluetoothCubit>();
              return IconButton(
                onPressed: cubit.connectToDevice,
                icon: const Icon(Icons.bluetooth),
                tooltip: 'Connect to Bluetooth Device',
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: BlocBuilder<BluetoothCubit, BluetoothState>(
              builder: (context, state) {
                if (state is BluetoothDataReceived) {
                  final messages = state.messages;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return BubbleSpecialOne(
                        text: msg.text,
                        isSender: msg.isSender,
                        color:
                            msg.isSender ? Colors.blue : Colors.grey.shade300,
                        textStyle: TextStyle(
                          color: msg.isSender ? Colors.white : Colors.black87,
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No data received yet.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      final cubit = context.read<BluetoothCubit>();
                      cubit.sendMessage(value);
                      _controller.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final cubit = context.read<BluetoothCubit>();
                    cubit.sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
