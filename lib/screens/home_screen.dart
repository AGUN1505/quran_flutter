import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';
import '../widgets/persistent_audio_player.dart';
import '../widgets/surat_tab.dart';
import '../widgets/juz_tab.dart';
import '../widgets/bookmark_tab.dart';
import '../widgets/sholat_tab.dart';
import 'settings_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SettingsController _settingsController = SettingsController();
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const SuratTab(),
    JuzTab(),
    BookmarkTab(),
    SholatTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        title: Text(
          'Al-Qur\'an',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Cari Terjemahan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    settingsController: _settingsController,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),
          ),
          const PersistentAudioPlayer(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: CustomFloatingNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

class CustomFloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Elegant dark capsule color
    const backgroundColor = Color(0xFF1C1C1E);
    // Translucent light active item background
    const activePillColor = Color(0xFF2C2C2E);

    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.menu_book_outlined,
        'activeIcon': Icons.menu_book,
        'label': 'Surat',
      },
      {
        'icon': Icons.format_list_numbered_outlined,
        'activeIcon': Icons.format_list_numbered,
        'label': 'Juz',
      },
      {
        'icon': Icons.bookmark_border,
        'activeIcon': Icons.bookmark,
        'label': 'Simpan',
      },
      {
        'icon': Icons.mosque_outlined,
        'activeIcon': Icons.mosque,
        'label': 'Sholat',
      },
    ];

    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? activePillColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item['activeIcon'] as IconData : item['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
                        size: 22,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          item['label'] as String,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
