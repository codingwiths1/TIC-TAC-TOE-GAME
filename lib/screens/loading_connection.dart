import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../utils/colors.dart';
import 'connection_check.dart';
import 'loading_screen.dart';

class LoadingConnection extends StatefulWidget {
  const LoadingConnection({super.key});

  @override
  State<LoadingConnection> createState() => _LoadingConnectionState();
}

class _LoadingConnectionState extends State<LoadingConnection> {
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
            loadAd();
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

  navigating() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ConnectionCheck()));
  }

  //Open Ads
  AppOpenAd? _appOpenAd;
  bool isAdLoaded = false;
  loadAd() {
    AppOpenAd.load(
      adUnitId: "ca-app-pub-3940256099942544/9257395921",
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          isAdLoaded = true;
          _appOpenAd = ad;
          _appOpenAd!.show();
          navigating();
        },
        onAdFailedToLoad: (error) {
          isAdLoaded = false;
          _appOpenAd!.dispose();
          loadAd();
          // print('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      LoadingScreen(),
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
