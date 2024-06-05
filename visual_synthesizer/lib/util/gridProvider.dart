import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridProvider extends ChangeNotifier {
  int _gridSize = 8;
  Duration _waveDuration = Duration(milliseconds: 100);
  AudioPlayer _audioPlayer = AudioPlayer();

  Color _initialColor = Colors.grey;
  Color _waveColor = Colors.blue;
  int _waveCount = 1;

  List<List<Color>> _gridColors = [];

  GridProvider() {
    _gridColors = List.generate(
      _gridSize,
      (i) => List.generate(_gridSize, (j) => _initialColor),
    );
    _audioPlayer.setSource(AssetSource('/testSound2.wav'));
  }

  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];


  List<Color> get colors => _colors;

  void changeColorWave(int x, int y) async {
    _gridColors[x][y] = _waveColor;
    notifyListeners();

    await Future.delayed(_waveDuration);
    _gridColors[x][y] = _initialColor;
    notifyListeners();

    for (int i = 1; i < _gridSize * 2; i++) {
      // gridSize*2 -> welle über ganzes Grid
      bool anyChanges = false;
      for (int dx = -i; dx <= i; dx++) {
        for (int dy = -i; dy <= i; dy++) {
          if (dx.abs() + dy.abs() == i) {
            int newX = x + dx;
            int newY = y + dy;
            if (newX >= 0 && newX < _gridSize && newY >= 0 && newY < _gridSize) {
              _gridColors[newX][newY] = _waveColor;
              notifyListeners();

              anyChanges = true;
            }
          }
        }
      }
      if (anyChanges) {
        await Future.delayed(_waveDuration);
        for (int dx = -i; dx <= i; dx++) {
          for (int dy = -i; dy <= i; dy++) {
            if (dx.abs() + dy.abs() == i) {
              int newX = x + dx;
              int newY = y + dy;
              if (newX >= 0 && newX < _gridSize && newY >= 0 && newY < _gridSize) {
                _gridColors[newX][newY] = _initialColor;
                notifyListeners();
              }
            }
          }
        }
      }
    }
  }

  void smiley() async{
    _initialColor = Colors.yellow;
    _waveColor = Colors.black;
    changeColorWave(4, 4);
    await Future.delayed(const Duration(milliseconds: 900));
    _gridColors = [
      [Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,],
      [Colors.red,Colors.yellow,Colors.red,Colors.yellow,Colors.yellow,Colors.red,Colors.yellow,Colors.red,],
      [Colors.red,Colors.red,Colors.red,Colors.yellow,Colors.yellow,Colors.red,Colors.red,Colors.red,],
      [Colors.yellow,Colors.red,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.red,Colors.yellow,],
      [Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,],
      [Colors.redAccent.shade100,Colors.yellow,Colors.black,Colors.white,Colors.white,Colors.black,Colors.redAccent.shade100,Colors.yellow,],
      [Colors.yellow,Colors.redAccent.shade100,Colors.yellow,Colors.black,Colors.black,Colors.yellow,Colors.yellow,Colors.redAccent.shade100],
      [Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,Colors.yellow,]
    ];
    notifyListeners();
  }
  AudioPlayer get audioPlayer => _audioPlayer;

  Duration get waveDuration => _waveDuration;

  Color get initialColor => _initialColor;

  Color get waveColor => _waveColor;

  List<List<Color>> get gridColors => _gridColors;

  int get gridSize => _gridSize;

  int get waveCount => _waveCount;

  set initialColor(Color value) {
    _initialColor = value;
    notifyListeners();
  }
  set waveColor(Color value) {
    _waveColor = value;
    notifyListeners();
  }
  set gridSize(int value) {
    _gridSize = value;
  }
  set waveCount(int value) {
    _waveCount = value;
    notifyListeners();
  }
  set waveDuration(Duration value) {
    _waveDuration = value;
    notifyListeners();
  }

  set gridColors(List<List<Color>> value) {
    _gridColors = value;
  }
}
