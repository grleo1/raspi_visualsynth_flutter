import 'package:flutter/material.dart';
import 'package:visual_synthesizer/pages/synthBoard.dart';
import 'util/mqttProvider.dart';
import 'package:provider/provider.dart';
import 'pages/testConnectionMQTT.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => MQTTProvider(),
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'raspi mqtt flutter schme',
      home: SynthBoard(),
    );
  }
}