import 'package:flutter/material.dart';
import 'pages/landing_page.dart'; // Import the Landing Page

void main() {
  runApp(PayKeeperApp());
}

class PayKeeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PayKeeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}
