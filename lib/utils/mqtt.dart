import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MqttService {
  late MqttClient client;

  Future<void> connect() async {
    if (kIsWeb) {
      client = MqttBrowserClient(
        'wss://broker.emqx.io:8083/mqtt',
        'flutter_client',
      );
    } else {
      client = MqttServerClient('broker.emqx.io', 'flutter_client');
      client.port = 1883;
    }

    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Connection failed: $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('MQTT client connected');
    } else {
      print(
        'MQTT client connection failed - status: ${client.connectionStatus}',
      );
      client.disconnect();
    }
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void onConnected() {
    print('Connected to the broker');
  }

  void onDisconnected() {
    print('Disconnected from the broker');
  }

  void onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }
}
