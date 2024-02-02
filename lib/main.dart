import 'package:flutter/material.dart';
import 'package:hyperhire_app/bindings/bindings.dart';
import 'package:hyperhire_app/chat_screen.dart';
import 'package:hyperhire_app/utils/theme.dart';

void main() {
  intBinding();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const ChatScreen(),
    );
  }
}
