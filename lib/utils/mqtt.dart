import 'package:flutter/foundation.dart';
import 'package:mqtt5_client/mqtt5_browser_client.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
// import 'package:mqtt_client/mqtt_browser_client.dart';
// import 'package:mqtt_client/mqtt_client.dart';

class MqttService {
  late MqttClient client;

  Future<void> connect() async {
    // client = MqttBrowserClient('ws://broker.emqx.io', '');
    // // client.setProtocolV311();
    // client.port = 8083; // Correct port for WSS

    client = MqttBrowserClient.withPort(
      'ws://test.mosquitto.org',
      'triana-web',
      8080,
    );
    client.websocketProtocols = ['mqtt'];
    // client.setProtocolV311();

    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onAutoReconnect = autoReconnect;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    // client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(
          'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
        )
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
    final builder = MqttPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void onConnected() {
    print('Connected to the broker');
  }

  void onDisconnected() {
    print('Disconnected from the broker');
  }

  // void onSubscribed(String topic) {
  //   print('Subscribed to topic: $topic');
  // }

  void onSubscribed(MqttSubscription subscription) {
    print(
      'EXAMPLE::Subscription confirmed for topic ${subscription.topic.rawTopic}',
    );
  }

  void onMessageReceived(String topic, MqttMessage message) {
    // Handle incoming messages here
    print('Message received on topic $topic: ${message.toString()}');
  }

  void autoReconnect() {
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      print('Attempting to reconnect...');
      connect();
    }
  }
}
