import 'package:medisafetrack_user/spash_screen.dart';

import 'constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MediSafeTrack User",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: staticBackgroundColor),
      home: const SplashScreen(),
    );
  }
}
