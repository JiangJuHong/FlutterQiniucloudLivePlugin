import 'dart:async';

import 'package:flutter/services.dart';

class FlutterQiniucloudLivePlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_qiniucloud_live_plugin');

  static Future<String> get platformVersion async {
    return await _channel.invokeMethod('init');
  }
}
