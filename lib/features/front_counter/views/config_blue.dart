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
  final ScrollController _scrollController = ScrollController();

  // List of valid commands for validation
  final List<String> validCommands = [
    'start mlx',
    'stop mlx',
    'start heart',
    'stop heart',
    'status',
    'help',
  ];

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final cubit = context.read<BluetoothCubit>();
    final isConnected = cubit.isConnected;

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please connect to a device first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check if command is valid and provide feedback
    final isValidCommand = validCommands.contains(text.trim().toLowerCase());
    if (!isValidCommand) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"$text" may not be a valid command. Sending anyway...',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    cubit.sendMessage(text);
    _controller.clear();

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

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
              final isConnected =
                  state is BluetoothConnected || state is BluetoothDataReceived;

              return Row(
                children: [
                  // Connection status indicator
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                  ),

                  IconButton(
                    onPressed:
                        isConnected ? cubit.disconnect : cubit.connectToDevice,
                    icon: Icon(
                      isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                    ),
                    tooltip:
                        isConnected
                            ? 'Disconnect'
                            : 'Connect to Bluetooth Device',
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
          // Command help section
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Valid Commands:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final cmd in validCommands)
                      Chip(
                        label: Text(cmd),
                        backgroundColor: Colors.blue[50],
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[800],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Connection status
          BlocBuilder<BluetoothCubit, BluetoothState>(
            builder: (context, state) {
              if (state is BluetoothLoading) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  color: Colors.amber[100],
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Connecting...'),
                    ],
                  ),
                );
              } else if (state is BluetoothError) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  color: Colors.red[100],
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          Expanded(
            child: BlocConsumer<BluetoothCubit, BluetoothState>(
              listener: (context, state) {
                if (state is BluetoothDataReceived) {
                  // Auto-scroll to bottom when new message arrives
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _scrollToBottom(),
                  );
                }
              },
              builder: (context, state) {
                if (state is BluetoothDataReceived) {
                  final messages = state.messages;
                  return messages.isEmpty
                      ? const Center(child: Text('No messages yet.'))
                      : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          return BubbleSpecialOne(
                            text: msg.text,
                            isSender: msg.isSender,
                            color:
                                msg.isSender
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                            textStyle: TextStyle(
                              color:
                                  msg.isSender ? Colors.white : Colors.black87,
                            ),
                          );
                        },
                      );
                } else if (state is BluetoothConnected) {
                  return const Center(
                    child: Text(
                      'Connected! Try sending a command.',
                      style: TextStyle(color: Colors.green),
                    ),
                  );
                } else if (state is BluetoothError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Connection Error: ${state.message}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth_disabled,
                          color: Colors.grey,
                          size: 48,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Not connected to any device\nTap the Bluetooth icon to connect',
                          textAlign: TextAlign.center,
                        ),
                      ],
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
                      hintText: 'Type a command...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
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
    _scrollController.dispose();
    super.dispose();
  }
}
