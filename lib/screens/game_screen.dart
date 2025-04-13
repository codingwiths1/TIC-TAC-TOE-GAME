import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tic_tac_game/utils/colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List matchedBoxes = [];
  int attempt = 0;
  void resetTimer() => seconds = maxSeconds;

  void stopTimer() {
    timer?.cancel();
    resetTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  Widget buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: AlwaysStoppedAnimation(whiteColor),
                  strokeWidth: 8,
                  backgroundColor: accentColor,
                ),
                Center(
                  child: Text(
                    "$seconds",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: whiteColor),
                  ),
                )
              ],
            ),
          )
        : InkWell(
            onTap: () {
              attempt++;
              startTimer();
              _clearBoard();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: whiteColor),
              child: Text(
                attempt == 0 ? "Start" : "Play Again!",
                style: TextStyle(
                    fontSize: 25,
                    color: blackColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
  }

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;
  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = "";
      }
      resultDeclaration = "";
    });
    fillBoxes = 0;
  }

  bool winnerFound = false;
  void _updateScore(String winner) {
    if (winner == "O") {
      oScore++;
    } else if (winner == "X") {
      xScore++;
    }
    winnerFound = true;
  }

  int oScore = 0;
  int xScore = 0;
  int fillBoxes = 0;
  String resultDeclaration = "";
  bool oTurn = true;
  List displayXO = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  late BannerAd bannerAd;
  bool? isLoaded;

  /// Loads a banner ad.
  loadAd() {
    bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('ad is loaded.');

          setState(() {
            isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    );
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: isLoaded == true
            ? SizedBox(
                height: bannerAd.size.height.toDouble(),
                width: bannerAd.size.width.toDouble(),
                child: AdWidget(ad: bannerAd),
              )
            : SizedBox(),
        backgroundColor: primaryColor,
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Player O",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: whiteColor,
                                  fontFamily: "Coiny"),
                            ),
                            Text(
                              oScore.toString(),
                              style: TextStyle(
                                  fontSize: 30,
                                  color: whiteColor,
                                  fontFamily: "Coiny"),
                            )
                          ],
                        ),
                        SizedBox(width: 40),
                        Column(
                          children: [
                            Text(
                              "Player X",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: whiteColor,
                                  fontFamily: "Coiny"),
                            ),
                            Text(
                              xScore.toString(),
                              style: TextStyle(
                                  fontSize: 30,
                                  color: whiteColor,
                                  fontFamily: "Coiny"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 3,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(25.0),
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) => InkWell(
                    onTap: () {
                      _tapped(index);
                    },
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: transColor,
                    enableFeedback: false,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 5),
                          color: accentColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(displayXO[index],
                            style: TextStyle(
                                fontSize: 64,
                                color: primaryColor,
                                fontFamily: "Coiny")),
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(resultDeclaration,
                      style: TextStyle(
                          fontSize: 35,
                          color: whiteColor,
                          fontFamily: "Coiny")),
                  SizedBox(height: 40),
                  buildTimer()
                ],
              ),
            )
          ],
        ));
  }

  void _tapped(index) {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == "") {
          displayXO[index] = "O";
          fillBoxes++;
        } else if (!oTurn && displayXO[index] == "") {
          displayXO[index] = "X";
          fillBoxes++;
        }
        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // 1st roll
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != "") {
      setState(() {
        resultDeclaration = 'player ${displayXO[0]} wins';
        matchedBoxes.addAll([0, 1, 2]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }
    // 2nd roll

    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != "") {
      setState(() {
        resultDeclaration = 'player ${displayXO[3]} wins';
        matchedBoxes.addAll([3, 4, 5]);
        stopTimer();
        _updateScore(displayXO[3]);
      });
    }
    // 3rd roll

    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != "") {
      setState(() {
        resultDeclaration = 'player  ${displayXO[6]} wins';
        matchedBoxes.addAll([6, 7, 8]);
        stopTimer();
        _updateScore(displayXO[6]);
      });
    }

    // 1st column

    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != "") {
      setState(() {
        resultDeclaration = 'player ${displayXO[0]} wins';
        matchedBoxes.addAll([0, 3, 6]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    // 2nd column

    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != "") {
      setState(() {
        resultDeclaration = 'player ${displayXO[1]} wins';
        matchedBoxes.addAll([1, 4, 7]);
        stopTimer();
        _updateScore(displayXO[1]);
      });
    }

    // 3rd column
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != "") {
      setState(() {
        resultDeclaration = 'player ${displayXO[2]} wins';
        matchedBoxes.addAll([2, 5, 8]);
        stopTimer();
        _updateScore(displayXO[2]);
      });
    }

    //1st diagonal

    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != "") {
      setState(() {
        resultDeclaration = 'player ${displayXO[0]} wins';
        matchedBoxes.addAll([0, 4, 8]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }
    if (winnerFound == false && fillBoxes == 9) {
      setState(() {
        resultDeclaration = "Nobody Wins";
        stopTimer();
      });
    }
    if (displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6] &&
        displayXO[2] != "") {
      setState(() {
        resultDeclaration = 'player ${displayXO[2]} wins';
        matchedBoxes.addAll([2, 4, 6]);
        stopTimer();
        _updateScore(displayXO[6]);
      });
    }
  }
}
