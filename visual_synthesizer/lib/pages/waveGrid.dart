import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_synthesizer/util/gridProvider.dart';

import '../util/mqttProvider.dart';

class WaveGrid extends StatefulWidget {
  @override
  _WaveGridState createState() => _WaveGridState();
}

class _WaveGridState extends State<WaveGrid> {

  @override
  Widget build(BuildContext context) {


    MQTTProvider mqttProvider = Provider.of<MQTTProvider>(context);
    GridProvider gridProvider = Provider.of<GridProvider>(context);
    Random random = Random();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SynthBoard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                gridProvider.smiley();
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(gridProvider.gridSize, (x) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(gridProvider.gridSize, (y) {
                return GestureDetector(
                  onTap: () async {
                    for (int i = 0; i < gridProvider.waveCount; i++){
                      gridProvider.changeColorWave(x, y);
                      await Future.delayed(gridProvider.waveDuration * 2);

                      var field = y + 8 * x;
                      mqttProvider.publish('htlstp/4BHIF/led', '$field');

                      gridProvider.playSound(x, y);
                    }
                  },
                  onDoubleTap: () async {
                    var initialNum = gridProvider.colors[random.nextInt(gridProvider.colors.length)];
                    var waveNum = gridProvider.colors[random.nextInt(gridProvider.colors.length)];
                    while (initialNum == waveNum) {
                      waveNum = gridProvider.colors[random.nextInt(gridProvider.colors.length)];
                    }
                    gridProvider.initialColor = initialNum;
                    gridProvider.waveColor = waveNum;

                    gridProvider.changeColorWave(x, y);

                    var field = y + 8 * x;
                    mqttProvider.publish('htlstp/4BHIF/led', '$field');

                    gridProvider.playSound(x, y);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: gridProvider.gridColors[x][y],
                      border: Border.all(color: Colors.black12, width: 5),
                    ),
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.all(2),
                    //color: gridProvider.gridColors[x][y],
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}