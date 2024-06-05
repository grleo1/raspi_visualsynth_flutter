import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/mqttProvider.dart';
import 'package:audioplayers/audioplayers.dart';


class TestConnectionMQTT extends StatefulWidget {
  const TestConnectionMQTT({super.key});

  @override
  State<TestConnectionMQTT> createState() => _TestConnectionMQTTState();
}

class _TestConnectionMQTTState extends State<TestConnectionMQTT> {

  @override
  Widget build(BuildContext context) {

    MQTTProvider mqttProvider = Provider.of<MQTTProvider>(context);
    
    final AudioPlayer audioPlayer = AudioPlayer();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MQTT Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                mqttProvider.connect();
              },
              child: const Text('Connect'),
            ),
            ElevatedButton(
              onPressed: () {
                mqttProvider.publish('htlstp/4BHIF/led', 'Hallo Welt');
              },
              child: const Text('Publish to htlst/20220012/bla'),
            ),
            ElevatedButton(
              onPressed: () {
                mqttProvider.disconnect();
              },
              child: const Text('Disconnect'),
            ),
            ElevatedButton(
              onPressed: () async {
                await audioPlayer.setSource(AssetSource('/testSound2.wav'));
                audioPlayer.resume();
              },
              child: const Text('play Sound'),
            ),
          ],
        ),
      ),
    );
  }
}
