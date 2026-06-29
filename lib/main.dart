import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/settings_controller.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

// Fungsi utama untuk menjalankan aplikasi Flutter Al-Quran Indonesia
void main() async {
  // Ensure widget binding is initialized for SharedPreferences and notifications
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize local notifications and timezone data
  await NotificationService.initialize();
  runApp(const QuranApp());
}

// Widget utama root aplikasi QuranApp
class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  // Membangun MaterialApp dengan tema terang/gelap serta lokalisasi font Poppins
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
            primaryColor: const Color(0xFF004132),
            scaffoldBackgroundColor: const Color(0xFFFCF9F8),
            cardColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF004132),
              primary: const Color(0xFF004132),
              primaryContainer: const Color(0xFF0F5A47),
              secondary: const Color(0xFFE2B93B),
              brightness: Brightness.light,
              onSurface: const Color(0xFF1C1B1B),
              onSurfaceVariant: const Color(0xFF3F4945),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF82D0B9),
            scaffoldBackgroundColor: const Color(0xFF121615),
            cardColor: const Color(0xFF1A201E),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF82D0B9),
              primary: const Color(0xFF82D0B9),
              primaryContainer: const Color(0xFF1E3A32),
              secondary: const Color(0xFFF1D279),
              brightness: Brightness.dark,
              onSurface: const Color(0xFFE0E6E3),
              onSurfaceVariant: const Color(0xFFA6B3AE),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
