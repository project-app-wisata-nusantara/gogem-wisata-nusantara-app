import 'package:flutter/material.dart';
import 'screen/splash/splash_screen.dart';
import 'style/theme/gogem_theme.dart';

void main() {
  runApp(const GoGemApp());
}

class GoGemApp extends StatelessWidget {
  const GoGemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoGem',
      debugShowCheckedModeBanner: false,
      theme: GogemTheme.lightTheme,
      darkTheme: GogemTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
