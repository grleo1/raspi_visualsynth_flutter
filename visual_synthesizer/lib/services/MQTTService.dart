import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MQTTService {
  final MqttBrowserClient client;
  final String broker = 'mqtt.htl.services';
  final int port = 443; // Default port for WSS
  final String username = 'htlstp';
  final String password = 'nopass2day!';
  final String clientIdentifier = 'your_client_identifier';

  MQTTService()
      : client = MqttBrowserClient('wss://mqtt.htl.services/htlstp/4BHIF/led', 'your_client_identifier') {
    client.port = port;
    client.keepAlivePeriod = 20;

    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.logging(on: false);

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .authenticateAs(username, password)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMess;

    connect();
  }

  // Verbindung herstellen
  Future<void> connect() async {
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      disconnect();
    }

    // Verbindung prüfen
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('MQTT Connected');
    } else {
      print('ERROR: MQTT Connection failed - disconnecting, state is ${client.connectionStatus?.state}');
      disconnect();
    }
  }

  // Trennen der Verbindung
  void disconnect() {
    client.disconnect();
    print('Disconnected');
  }

  // Abonnieren eines Themas
  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  // Nachrichten veröffentlichen
  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    // Stelle sicher, dass der Payload nicht null ist
    final payload = builder.payload!;
    client.publishMessage(topic, MqttQos.atMostOnce, payload);
  }

  // Callback-Funktionen
  void onConnected() {
    print('Connected');
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }
}
