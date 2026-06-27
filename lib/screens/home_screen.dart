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
      body: Stack(
        children: [
          // AnimatedSwitcher with quick pop (fade + scale) transition
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: _tabs[_currentIndex],
              ),
            ),
          ),
          // Floating overlay column for audio player & floating navbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PersistentAudioPlayer(),
                  const SizedBox(height: 10),
                  Center(
                    child: CustomFloatingNavBar(
                      currentIndex: _currentIndex,
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFloatingNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomFloatingNavBar> createState() => _CustomFloatingNavBarState();
}

class _CustomFloatingNavBarState extends State<CustomFloatingNavBar> {
  double? _dragIndex;
  bool _isDragging = false;

  void _handleDrag(double localX) {
    setState(() {
      _isDragging = true;
      // Usable width is 324 (starts at 8.0, ends at 332.0 for container of width 340)
      final double x = (localX - 8.0).clamp(0.0, 324.0);
      _dragIndex = (x / 324.0) * 3.0;
    });
  }

  void _handleDragEnd() {
    if (_dragIndex == null) return;
    final int nearestPage = _dragIndex!.round();
    setState(() {
      _isDragging = false;
      _dragIndex = null;
    });
    widget.onTap(nearestPage);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Liquid glass translucent background (using gradients for liquid shine reflection)
    final List<Color> liquidColors = isDark
        ? [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.03),
          ]
        : [
            Colors.black.withValues(alpha: 0.06),
            Colors.black.withValues(alpha: 0.02),
          ];

    // Active pill background color with gradient border shine
    final activePillColor = isDark
        ? Colors.white.withValues(alpha: 0.16)
        : Theme.of(context).primaryColor.withValues(alpha: 0.10);

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

    final double pageIndex = _dragIndex ?? widget.currentIndex.toDouble();

    return GestureDetector(
      onHorizontalDragStart: (details) => _handleDrag(details.localPosition.dx),
      onHorizontalDragUpdate: (details) => _handleDrag(details.localPosition.dx),
      onHorizontalDragEnd: (details) => _handleDragEnd(),
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 340,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: liquidColors,
              ),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.16) // shinier glass edge
                    : Colors.black.withValues(alpha: 0.08),
                width: 1.0,
              ),
              boxShadow: [
                // Liquid glass drop shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                // Inner glow top reflection
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.white.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double totalWidth = constraints.maxWidth;
                final double itemWidth = totalWidth / 4;
                const double bubbleWidth = 76.0;
                const double bubbleHeight = 48.0;

                return Stack(
                  children: [
                    // Sliding Liquid Bubble Capsule with dynamic duration
                    AnimatedPositioned(
                      duration: _isDragging ? Duration.zero : const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      left: (pageIndex * itemWidth) + (itemWidth - bubbleWidth) / 2,
                      top: (constraints.maxHeight - bubbleHeight) / 2,
                      width: bubbleWidth,
                      height: bubbleHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: activePillColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : Theme.of(context).primaryColor.withValues(alpha: 0.15),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    // Items row overlay
                    Row(
                      children: List.generate(items.length, (index) {
                        final item = items[index];

                        // Smooth color interpolation based on distance to the scrolling bubble
                        final double distance = (index - pageIndex).abs();
                        final double activeWeight = (1.0 - distance).clamp(0.0, 1.0);
                        final Color itemColor = Color.lerp(inactiveColor, activeColor, activeWeight)!;
                        final bool isSelectIcon = activeWeight > 0.5;

                        return SizedBox(
                          width: itemWidth,
                          height: constraints.maxHeight,
                          child: GestureDetector(
                            onTap: () => widget.onTap(index),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isSelectIcon ? item['activeIcon'] as IconData : item['icon'] as IconData,
                                  color: itemColor,
                                  size: 22,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['label'] as String,
                                  style: GoogleFonts.poppins(
                                    color: itemColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
