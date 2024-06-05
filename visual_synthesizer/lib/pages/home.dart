import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_synthesizer/pages/waveGrid.dart';
import 'package:visual_synthesizer/util/gridProvider.dart';
import 'package:visual_synthesizer/util/mqttProvider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    MQTTProvider mqttProvider = Provider.of<MQTTProvider>(context);
    GridProvider gridProvider = Provider.of<GridProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Synthesizer', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent[100],
              border: Border.all(color: Colors.black12, width: 10),
            ),
            height: 600,
            width: 500,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //spacer
                const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Wave speed: ${gridProvider.waveDuration.inMilliseconds}ms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
                Slider(
                  value: gridProvider.waveDuration.inMilliseconds.toDouble(),
                  min: 50,
                  max: 500,
                  divisions: 18,
                  label: gridProvider.waveDuration.inMilliseconds.toDouble().round().toString(),
                  onChanged: (double value) {
                      gridProvider.waveDuration = Duration(milliseconds: value.toInt());
                  },
                ),
                const SizedBox(height: 20),


                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Wave color: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                        decoration: BoxDecoration(
                          color: gridProvider.waveColor,
                          border: Border.all(color: Colors.black12, width: 2),
                        ),
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: gridProvider.colors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        gridProvider.waveColor = color;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(color: Colors.black12, width: 2),
                        ),
                        width: 30,
                        height: 30,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),


                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Initial color: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                        decoration: BoxDecoration(
                          color: gridProvider.initialColor,
                          border: Border.all(color: Colors.black12, width: 2),
                        ),
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: gridProvider.colors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        gridProvider.initialColor = color;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(color: Colors.black12, width: 2),
                        ),
                        width: 30,
                        height: 30,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Wave count: ${gridProvider.waveCount}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Slider(
                  value: gridProvider.waveCount.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: gridProvider.waveCount.toString(),
                  onChanged: (double value) {
                    gridProvider.waveCount = value.toInt();
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return WaveGrid();
                            },
                          ));
                    },
                    child: Text("To SynthBoard"))
              ],
            ),
        ),
      ),
    );
  }
}
