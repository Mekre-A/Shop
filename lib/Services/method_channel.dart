import 'package:flutter/services.dart';

class MethodChannelNotification{

  static const platform = const MethodChannel('platformchannel.notification.example.com');


  static Future<String> notify() async{
    try{
      String deviceInfo = await platform.invokeMethod('notify');
      return deviceInfo;
    }
    catch(e){
      print(e);
      return "false";
    }

  }
}