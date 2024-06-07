import 'dart:math';

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
        leading: Image.asset('assets/icon.png'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          IconButton(
              onPressed: () {
                gridProvider.smiley();
                mqttProvider.publish('htlstp/4BHIF/smile', 'smile');
              },
              icon: const Icon(Icons.add)),
          Switch(
            value: gridProvider.sensorColors, onChanged: (value) {
              gridProvider.sensorColors = value;
              mqttProvider.publish('htlstp/4BHIF/data', gridProvider.sensorColors?'1':'0');
            },

          )
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
                      await Future.delayed(gridProvider.waveDuration);

                      var field = y + 8 * x;
                      mqttProvider.publish('htlstp/4BHIF/led', '$field');
                    if(gridProvider.sensorColors == false){
                      mqttProvider.publish('htlstp/4BHIF/colorWave', gridProvider.colors.entries.firstWhere((entry) => entry.value == gridProvider.waveColor).key);
                      mqttProvider.publish('htlstp/4BHIF/colorInit', gridProvider.colors.entries.firstWhere((entry) => entry.value == gridProvider.initialColor).key);
                    }
                    else{
                      mqttProvider.publish('htlstp/4BHIF/colorWave', gridProvider.colors.keys.elementAt(random.nextInt(9)));
                      mqttProvider.publish('htlstp/4BHIF/colorInit', gridProvider.colors.keys.elementAt(random.nextInt(9)));
                    }
                      gridProvider.playSound(x, y);
                    }
                  },
                  onDoubleTap: () async {
                    var initialNum = gridProvider.colors.values.elementAt(random.nextInt(gridProvider.colors.length));
                    var waveNum = gridProvider.colors.values.elementAt(random.nextInt(gridProvider.colors.length));
                    while (initialNum == waveNum) {
                      waveNum = gridProvider.colors.values.elementAt(random.nextInt(gridProvider.colors.length));
                    }
                    gridProvider.initialColor = initialNum;
                    gridProvider.waveColor = waveNum;

                    gridProvider.changeColorWave(x, y);

                    var field = y + 8 * x;
                    mqttProvider.publish('htlstp/4BHIF/led', '$field');

                    if(gridProvider.sensorColors == false){
                      mqttProvider.publish('htlstp/4BHIF/colorWave', gridProvider.colors.entries.firstWhere((entry) => entry.value == gridProvider.waveColor).key);
                      mqttProvider.publish('htlstp/4BHIF/colorInit', gridProvider.colors.entries.firstWhere((entry) => entry.value == gridProvider.initialColor).key);
                    }
                    else{
                      mqttProvider.publish('htlstp/4BHIF/colorWave', gridProvider.colors.keys.elementAt(random.nextInt(9)));
                      mqttProvider.publish('htlstp/4BHIF/colorInit', gridProvider.colors.keys.elementAt(random.nextInt(9)));
                    }

                    gridProvider.playSound(x, y);
                  },
                  onLongPress: () {
                    gridProvider.changeColorCross(x, y);


                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: gridProvider.gridColors[x][y],
                      border: Border.all(color: Colors.black12, width: 5),
                    ),
                    width: 70, // 45 für handy | 70 für web
                    height: 70,// 45 für handy | 70 für web
                    margin: EdgeInsets.all(2),
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