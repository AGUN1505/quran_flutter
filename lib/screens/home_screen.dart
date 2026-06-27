import 'dart:ui';
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
  late final PageController _pageController;

  final List<Widget> _tabs = [
    const SuratTab(),
    JuzTab(),
    BookmarkTab(),
    SholatTab(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
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
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Glassmorphic translucent background
    final backgroundColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.04);

    // Active pill background color
    final activePillColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Theme.of(context).primaryColor.withValues(alpha: 0.08);

    // Dynamic colors for selected/unselected items
    final activeColor = isDark ? Colors.white : Theme.of(context).primaryColor;
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : Colors.black.withValues(alpha: 0.45);

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
              width: 1.0,
            ),
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
                            color: isSelected ? activeColor : inactiveColor,
                            size: 22,
                          ),
                          ClipRect(
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isSelected ? 1.0 : 0.0,
                                curve: Curves.easeInOut,
                                child: isSelected
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(width: 8),
                                          Text(
                                            item['label'] as String,
                                            style: GoogleFonts.poppins(
                                              color: activeColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
