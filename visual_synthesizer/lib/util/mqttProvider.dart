import 'package:flutter/cupertino.dart';
import '../services/MQTTService.dart';

class MQTTProvider extends ChangeNotifier{

  final MQTTService _mqttService = MQTTService();

  MQTTService get mqttService => _mqttService;

  void connect(){
    _mqttService.connect();
    notifyListeners();
  }
  void disconnect(){
    _mqttService.disconnect();
    notifyListeners();
  }
  void publish(String topic, String message){
    _mqttService.publish(topic, message);
    notifyListeners();
  }
}