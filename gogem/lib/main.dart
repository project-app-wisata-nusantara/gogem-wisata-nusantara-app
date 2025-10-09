import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gogem/provider/category/category_provider.dart';
import 'package:gogem/provider/map/map_provider.dart';
import 'package:gogem/provider/profile/profile_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'provider/auth/auth_provider.dart';
import 'provider/home/home_provider.dart';

import 'screen/splash/splash_screen.dart';
import 'style/theme/gogem_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GoGemApp());
}

class GoGemApp extends StatelessWidget {
  const GoGemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => HomeProvider()),

        ChangeNotifierProvider(create: (_) => MapProvider()),

        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()..loadCategories()),
      ],
      child: MaterialApp(
        title: 'GoGem',
        debugShowCheckedModeBanner: false,
        theme: GogemTheme.lightTheme,
        darkTheme: GogemTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
