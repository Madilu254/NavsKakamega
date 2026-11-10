import 'package:flutter/material.dart';
import 'data/navs_repository.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize repository with offline resilient cache and Firebase sync
  final repo = NavsRepository();
  await repo.initialize();

  runApp(const NavsKakamegaApp());
}

class NavsKakamegaApp extends StatelessWidget {
  const NavsKakamegaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navs Kakamega',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
