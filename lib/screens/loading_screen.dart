import 'package:flutter/material.dart';

import '../utils/colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.234),
        child: Stack(
          children: [
            Align(
                alignment: Alignment(0, -0.45),
                child: Image.asset("fonts/Dice.png")),
            Align(
              alignment: Alignment(0, 0.45),
              child: Text("Loading...",
                  style: TextStyle(fontFamily: "Coiny", fontSize: 17)),
            ),
            Align(
              alignment: Alignment(0, 0.5),
              child: LinearProgressIndicator(
                backgroundColor: secondaryColor,
                valueColor: AlwaysStoppedAnimation(whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
