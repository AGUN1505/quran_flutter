import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/settings_controller.dart';
import 'screens/splash_screen.dart';

void main() {
  // Ensure widget binding is initialized for SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = SettingsController();

    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Al-Quran Indonesia',
          debugShowCheckedModeBanner: false,
          themeMode: settingsController.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: const Color(0xFF0F5A47),
            scaffoldBackgroundColor: const Color(0xFFFAFAF7),
            cardColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F5A47),
              primary: const Color(0xFF0F5A47),
              secondary: const Color(0xFFE2B93B),
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF0F5A47),
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F5A47),
              primary: const Color(0xFF0F5A47),
              secondary: const Color(0xFFE2B93B),
              brightness: Brightness.dark,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
