

// D E L E T E   T H I S





/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../util/mqttProvider.dart';

class SynthBoard extends StatefulWidget {
  const SynthBoard({super.key});

  @override
  State<SynthBoard> createState() => _SynthBoardState();
}

class _SynthBoardState extends State<SynthBoard> {
  @override
  Widget build(BuildContext context) {

    MQTTProvider mqttProvider = Provider.of<MQTTProvider>(context);
    final AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setSource(AssetSource('/testSound2.wav'));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Synth Board", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          const Text("for Navigation"),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      //ein SynthBoard ist ein Grid mit 8x8 Buttons (64 Buttons)
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 2.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          return ElevatedButton(
            //onHover -> Farbe ändern
            onHover: (value) {
              if (value) {
                print('hover -> $index');
              }
            },

            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.green; // the color when the button is hovered over
                    }
                    return Colors.grey; // the default color
                  },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            onPressed: () {
              audioPlayer.resume();
              mqttProvider.publish('htlstp/4BHIF/led', '$index');
              print('pressed -> $index');
              //mqttProvider.publish('htlstp/4BHIF/led', 'Hallo Welt');
            },
            child: const Text(''),
          );
        },
      ),
    );
  }
}
 */