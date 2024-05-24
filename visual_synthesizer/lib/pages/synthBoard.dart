import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/mqttProvider.dart';

class SynthBoard extends StatefulWidget {
  const SynthBoard({super.key});

  @override
  State<SynthBoard> createState() => _SynthBoardState();
}

class _SynthBoardState extends State<SynthBoard> {
  @override
  Widget build(BuildContext context) {

    //MQTTProvider mqttProvider = Provider.of<MQTTProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Synth Board", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          const Text("features"),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      body: Text("Synth Board"),
    );
  }
}
