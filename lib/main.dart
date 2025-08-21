import 'package:flutter/material.dart';
import 'widgets/shogi_board.dart';

void main() {
  runApp(const ShogiBoardApp());
}

class ShogiBoardApp extends StatelessWidget {
  const ShogiBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '将棋マスターズ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const ShogiBoardPage(),
    );
  }
}

class ShogiBoardPage extends StatelessWidget {
  const ShogiBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('将棋マスターズ'),
      ),
      body: const Center(
        child: ShogiBoard(),
      ),
    );
  }
}
