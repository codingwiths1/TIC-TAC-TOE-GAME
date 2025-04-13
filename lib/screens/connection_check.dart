import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../utils/colors.dart';
import 'game_screen.dart';

class ConnectionCheck extends StatefulWidget {
  const ConnectionCheck({super.key});

  @override
  State<ConnectionCheck> createState() => _ConnectionCheckState();
}

class _ConnectionCheckState extends State<ConnectionCheck> {
  bool? isConnected;

  StreamSubscription? internetConnectionStreamSubscription;
  @override
  void initState() {
    super.initState();
    internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnected = false;
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    internetConnectionStreamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      GameScreen(),
      if (isConnected == false)
        Scaffold(
          backgroundColor: Colors.black54,
          body: CupertinoAlertDialog(
            content: Column(
              children: [
                Icon(Icons.wifi_off, size: 70, color: greyColor.shade600),
                Text(
                  "No internet connection",
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
          ),
        ),
    ]));
  }
}
