import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_proxy/get_proxy.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _hostname = 'Unknown';
  String _type = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String hostname;
    String type;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetProxy.platformVersion;
      type = await GetProxy.proxyType("https://www.google.co.jp");
      hostname = await GetProxy.proxyAddress("https://www.google.co.jp");
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _hostname = hostname;
			_type = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            Text('Running on: $_platformVersion\n'),
            Text('type : $_type\n'),
            Text('hostname : $_hostname\n'),
          ]
        ),
      ),
    );
  }
}
