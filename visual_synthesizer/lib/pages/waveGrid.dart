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

    return Scaffold(
      appBar: AppBar(
        title: Text('Wave Grid'),
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

                      final AudioPlayer audioPlayer = AudioPlayer();
                      await audioPlayer.setSource(AssetSource('/testSound2.wav'));
                      await audioPlayer.resume();
                    }
                  },
                  onDoubleTap: () async {
                    gridProvider.initialColor = Colors.green;
                    gridProvider.waveColor = Colors.red;

                    gridProvider.changeColorWave(x, y);
                    var field = y + 8 * x;
                    mqttProvider.publish('htlstp/4BHIF/led', '$field');

                    final AudioPlayer audioPlayer = AudioPlayer();
                    await audioPlayer.setSource(AssetSource('/testSound2.wav'));
                    await audioPlayer.resume();
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.all(2),
                    color: gridProvider.gridColors[x][y],
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