import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_game/screens/loading_connection.dart';
import 'package:tic_tac_game/utils/colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: transColor));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LoadingConnection(),
    );
  }
}
