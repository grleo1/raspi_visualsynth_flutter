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

    MQTTProvider mqttProvider = Provider.of<MQTTProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Synth Board", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          const Text("features"),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
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
                      return Colors
                          .green; // the color when the button is hovered over
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
              mqttProvider.publish('htlstp/4BHIF/led', '$index');
              print('pressed -> $index');
              //mqttProvider.publish('htlstp/4BHIF/led', 'Hallo Welt');
            },
            child: Text(''),
          );
        },
      ),
    );
  }
}
