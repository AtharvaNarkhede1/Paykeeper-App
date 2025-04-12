import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool showIntro = true;
  bool fadeInIntro = true;
  bool showWallet = false;
  bool showText = false;
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        fadeInIntro = false; // Start fading out
      });

      Future.delayed(Duration(seconds: 1), () { // Keep text visible for 1 sec
        setState(() {
          showIntro = false; // Hide intro text completely
        });

        Future.delayed(Duration(milliseconds: 500), () { // Delay before wallet icon appears
          setState(() {
            showWallet = true;
          });

          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              showText = true;
            });

            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                showButton = true;
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIntro)
              AnimatedOpacity(
                opacity: fadeInIntro ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Text(
                  "Developed by Atharva Narkhede",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            if (!showIntro) ...[
              AnimatedOpacity(
                opacity: showWallet ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                opacity: showText ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Column(
                  children: [
                    Text(
                      "PayKeeper",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Your Smart Expense Manager!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              AnimatedOpacity(
                opacity: showButton ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text("Get Started", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
