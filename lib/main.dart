import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

/// Providers
import 'provider/auth/auth_provider.dart';
import 'provider/home/home_provider.dart';
import 'provider/map/map_provider.dart';
import 'provider/profile/profile_provider.dart';
import 'provider/detail/detail_provider.dart';
import 'provider/category/category_provider.dart';
import 'provider/gemini/gemini_provider.dart';
import 'provider/favorite/favorite_provider.dart'; // Tambahkan ini jika belum

/// Screens & Styles
import 'screen/splash/splash_screen.dart';
import 'style/theme/gogem_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Jika menggunakan dotenv (misal untuk API_KEY), aktifkan ini:
  // await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        ChangeNotifierProvider(create: (_) => DetailProvider()),
        ChangeNotifierProvider(create: (_) => GeminiProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()), // <- Penting
        ChangeNotifierProvider(
          create: (_) => CategoryProvider()..loadCategories(),
        ),
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
