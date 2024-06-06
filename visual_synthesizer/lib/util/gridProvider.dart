import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class GridProvider extends ChangeNotifier {
  int _gridSize = 8;
  Duration _waveDuration = const Duration(milliseconds: 100);

  Color _initialColor = Colors.grey;
  Color _waveColor = Colors.blue;
  int _waveCount = 1;

  List<List<Color>> _gridColors = [];
  
  List<List<int>> _audioInfo = [];

  final AudioPlayer audioPlayerLove = AudioPlayer();


  GridProvider() {
    _gridColors = List.generate(
      _gridSize,
      (i) => List.generate(_gridSize, (j) => _initialColor),
    );
    _audioInfo = List.generate(
      _gridSize,
          (i) => List.generate(_gridSize, (j) => 0),
    );
    for (int i = 0; i < _audioInfo.length; i++) {
      for (int j = 0; j < _audioInfo[i].length; j++) {
        int sound = (i * _audioInfo.length + j) % 16 + 1;
        _audioInfo[i][j] = sound;
      }
    }
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

  void changeColorCross(int x, int y) async {

    for (int i = 0; i < _gridSize; i++) {
      _gridColors[x][i] = _waveColor;
      _gridColors[i][y] = _waveColor;
    }
    notifyListeners();
    await Future.delayed(_waveDuration*10);
    for (int i = 0; i < _gridSize; i++) {
      _gridColors[x][i] = _initialColor;
      _gridColors[i][y] = _initialColor;
    }
    notifyListeners();
  }

  void changeColorWave(int x, int y) async {
    _gridColors[x][y] = _waveColor;
    notifyListeners();

    await Future.delayed(_waveDuration);
    _gridColors[x][y] = _initialColor;
    notifyListeners();

    for (int i = 1; i < _gridSize * 2; i++) { // gridSize*2 -> welle über ganzes Grid
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

  void playSound(x, y) async {
    AudioPlayer audioPlayer = AudioPlayer();
    int number = _audioInfo[x][y];

    await audioPlayer.setSource(AssetSource('/$number.wav'));
    await audioPlayer.resume();
  }

  void smiley() async{
    await audioPlayerLove.setSource(AssetSource('/love.wav'));
    await audioPlayerLove.resume();

    _initialColor = Colors.yellow;
    _waveColor = Colors.red;
    changeColorWave(4, 4);

    await Future.delayed(const Duration(milliseconds: 1200));
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
    await Future.delayed(const Duration(seconds: 10));
    audioPlayerLove.stop();
    notifyListeners();
  }

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
