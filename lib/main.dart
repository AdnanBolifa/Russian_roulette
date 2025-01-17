import 'package:flutter/material.dart';
import 'pages/game_page_old.dart';

void main() {
  runApp(const RussianRouletteApp());
}

class RussianRouletteApp extends StatelessWidget {
  const RussianRouletteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Russian Roulette',
      theme: ThemeData.dark(),
      home: const GamePage(),
    );
  }
}
