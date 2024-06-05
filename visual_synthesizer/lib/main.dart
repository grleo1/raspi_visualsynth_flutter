import 'package:flutter/material.dart';
import 'package:visual_synthesizer/pages/synthBoard.dart';
import 'package:visual_synthesizer/pages/waveGrid.dart';
import 'pages/home.dart';
import 'util/gridProvider.dart';
import 'util/mqttProvider.dart';
import 'package:provider/provider.dart';
import 'pages/testConnectionMQTT.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MQTTProvider()),
      ChangeNotifierProvider(create: (context) => GridProvider()),
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'raspi mqtt flutter schme',
      home: Home(),
    );
  }
}