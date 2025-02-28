import 'package:flutter/material.dart';

void main() {
  runApp(HoomSoundApp());
}

class HoomSoundApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOOM_Sound',
      home: Scaffold(
        appBar: AppBar(
          title: Text('HOOM_Sound'),
        ),
        body: Center(
          child: Text('Bienvenue dans HOOM_Sound!'),
        ),
      ),
    );
  }
}
