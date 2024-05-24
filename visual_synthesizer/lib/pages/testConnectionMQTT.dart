import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/mqttProvider.dart';

class TestConnectionMQTT extends StatefulWidget {
  const TestConnectionMQTT({super.key});

  @override
  State<TestConnectionMQTT> createState() => _TestConnectionMQTTState();
}

class _TestConnectionMQTTState extends State<TestConnectionMQTT> {

  @override
  Widget build(BuildContext context) {

    MQTTProvider mqttProvider = Provider.of<MQTTProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter MQTT Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                mqttProvider.connect();
              },
              child: Text('Connect'),
            ),
            ElevatedButton(
              onPressed: () {
                mqttProvider.publish('htlstp/4BHIF/led', 'Hallo Welt');
              },
              child: Text('Publish to htlst/20220012/bla'),
            ),
            ElevatedButton(
              onPressed: () {
                mqttProvider.disconnect();
              },
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
