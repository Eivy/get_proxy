import 'dart:async';

import 'package:flutter/services.dart';

class GetProxy {
  static const MethodChannel _channel =
      const MethodChannel('get_proxy');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> proxyType(String url) async {
    final String type = await _channel.invokeMethod('getProxyType',
        <String, dynamic>{
          'url': url,
        });
    return type;
  }

  static Future<String> proxyAddress(String url) async {
    final String hostname = await _channel.invokeMethod('getProxyAddress',
        <String, dynamic>{
          'url': url,
        });
    return hostname;
  }

}
