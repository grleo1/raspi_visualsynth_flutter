import 'package:flutter/material.dart';
import 'package:visual_synthesizer/services/MQTTService.dart';

void main() {
  final mqttService = MQTTService();
  runApp(MyApp(mqttService));
}

class MyApp extends StatelessWidget {
  final MQTTService mqttService;

  MyApp(this.mqttService);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter MQTT Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  mqttService.connect();
                },
                child: Text('Connect'),
              ),
              ElevatedButton(
                onPressed: () {
                  mqttService.publish('htlstp/4BHIF/led', 'Hallo Welt');
                },
                child: Text('Publish to htlst/20220012/bla'),
              ),
              ElevatedButton(
                onPressed: () {
                  mqttService.disconnect();
                },
                child: Text('Disconnect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
