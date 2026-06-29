import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';
import '../widgets/persistent_audio_player.dart';
import '../widgets/surat_tab.dart';
import '../widgets/juz_tab.dart';
import '../widgets/bookmark_tab.dart';
import '../widgets/sholat_tab.dart';
import '../widgets/qiblah_compass_tab.dart';
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
    const QiblahCompassTab(),
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

class _CustomFloatingNavBarState extends State<CustomFloatingNavBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _previousIndex;
  late double _targetIndex;
  double? _dragIndex;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex.toDouble();
    _targetIndex = widget.currentIndex.toDouble();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {});
    });
    // Start at fully completed transition
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(CustomFloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _previousIndex = _targetIndex;
      _targetIndex = widget.currentIndex.toDouble();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDrag(double localX) {
    setState(() {
      _isDragging = true;
      // Usable width is 324 (starts at 8.0, ends at 332.0 for container of width 340)
      final double x = (localX - 8.0).clamp(0.0, 324.0);
      _dragIndex = (x / 324.0) * 4.0;
      _targetIndex = _dragIndex!;
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

    // High-fidelity frosted glass translucent gradient
    final List<Color> liquidColors = isDark
        ? [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.01),
          ]
        : [
            Colors.white.withValues(alpha: 0.35),
            Colors.white.withValues(alpha: 0.10),
          ];

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
      {
        'icon': Icons.explore_outlined,
        'activeIcon': Icons.explore,
        'label': 'Kiblat',
      },
    ];

    final double displayIndex = _dragIndex ?? widget.currentIndex.toDouble();
    const double outerHeight = 84.0;
    const double navbarHeight = 68.0;

    return GestureDetector(
      onHorizontalDragStart: (details) => _handleDrag(details.localPosition.dx),
      onHorizontalDragUpdate: (details) => _handleDrag(details.localPosition.dx),
      onHorizontalDragEnd: (details) => _handleDragEnd(),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 340,
        height: outerHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // 1. Frosted Glass Background
            Positioned(
              top: (outerHeight - navbarHeight) / 2,
              child: RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                    child: Container(
                      width: 340,
                      height: navbarHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: liquidColors,
                        ),
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.35) // more visible glass outline
                              : Colors.white.withValues(alpha: 0.55),
                          width: 1.5,
                        ),
                        boxShadow: [
                          // Liquid glass drop shadow
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                          // Inner glow top reflection (light reflection hit)
                          BoxShadow(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.18)
                                : Colors.white.withValues(alpha: 0.60),
                            blurRadius: 12,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 2. Sliding Capsule & Row (using LayoutBuilder to know the exact width of the navbar container)
            Positioned(
              top: 0,
              bottom: 0,
              left: 8,
              right: 8,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double totalWidth = constraints.maxWidth;
                  final double itemWidth = totalWidth / 5;
                  const double bubbleWidth = 58.0;
                  
                  // Normal height 46, expands up to 72 (exceeding 68)
                  const double normalHeight = 46.0;
                  const double maxExpansion = 26.0;

                  double leftEdge;
                  double rightEdge;
                  double currentHeight;

                  if (_isDragging) {
                    leftEdge = (displayIndex * itemWidth) + (itemWidth - bubbleWidth) / 2;
                    rightEdge = leftEdge + bubbleWidth;
                    currentHeight = normalHeight + maxExpansion; // pop up when dragged
                  } else {
                    // Directional Liquid Stretch Calculations using linear raw t for organic curves
                    final double t = _controller.value;

                    final double prevLeft = (_previousIndex * itemWidth) + (itemWidth - bubbleWidth) / 2;
                    final double prevRight = prevLeft + bubbleWidth;

                    final double targetLeft = (_targetIndex * itemWidth) + (itemWidth - bubbleWidth) / 2;
                    final double targetRight = targetLeft + bubbleWidth;

                    // Transforming t directly to prevent jerky double-curve acceleration
                    final double tEaseIn = const Cubic(0.5, 0.0, 0.8, 0.25).transform(t);
                    final double tEaseOut = const Cubic(0.2, 0.75, 0.5, 1.0).transform(t);

                    if (_targetIndex > _previousIndex) {
                      // Moving Right (Stretch right edge first)
                      leftEdge = prevLeft + (targetLeft - prevLeft) * tEaseIn;
                      rightEdge = prevRight + (targetRight - prevRight) * tEaseOut;
                    } else {
                      // Moving Left (Stretch left edge first)
                      leftEdge = prevLeft + (targetLeft - prevLeft) * tEaseOut;
                      rightEdge = prevRight + (targetRight - prevRight) * tEaseIn;
                    }

                    // Height expansions on transition midpoint using raw linear t for buttery arc
                    currentHeight = normalHeight + (maxExpansion * math.sin(t * math.pi));
                  }

                  final double currentWidth = rightEdge - leftEdge;
                  final double currentRadius = currentHeight / 2; // Always keep a perfect capsule stadium shape

                  // Specular reflection sweep from left (-0.2) to right (1.2) for true liquid glass shine
                  final double activeT = _isDragging ? 1.0 : _controller.value;
                  final double sweep = -0.2 + (1.4 * activeT);
                  
                  final List<Color> capsuleColors = isDark
                      ? [
                          Colors.white.withValues(alpha: 0.22),
                          Colors.white.withValues(alpha: 0.48), // liquid specular flash
                          Colors.white.withValues(alpha: 0.08),
                        ]
                      : [
                          Theme.of(context).primaryColor.withValues(alpha: 0.16),
                          Theme.of(context).primaryColor.withValues(alpha: 0.38), // liquid specular flash
                          Theme.of(context).primaryColor.withValues(alpha: 0.04),
                        ];

                  final List<double> stops = [
                    (sweep - 0.25).clamp(0.0, 1.0),
                    sweep.clamp(0.0, 1.0),
                    (sweep + 0.25).clamp(0.0, 1.0),
                  ];

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Sliding Liquid Stretch Bubble Capsule (exceeds navbar height)
                      Positioned(
                        left: leftEdge,
                        top: (constraints.maxHeight - currentHeight) / 2,
                        width: currentWidth,
                        height: currentHeight,
                        child: RepaintBoundary(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: capsuleColors,
                                stops: stops,
                              ),
                              borderRadius: BorderRadius.circular(currentRadius),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.48) // super glossy border
                                    : Theme.of(context).primaryColor.withValues(alpha: 0.40),
                                width: 1.2,
                              ),
                              boxShadow: [
                                // Glass glow shadow
                                BoxShadow(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.12)
                                      : Theme.of(context).primaryColor.withValues(alpha: 0.16),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                                // Deep 3D drop shadow
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.18),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(currentRadius),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // deeper refraction blur
                                child: const SizedBox.expand(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Items row overlay
                      Positioned(
                        left: 0,
                        right: 0,
                        top: (constraints.maxHeight - 68) / 2,
                        height: 68,
                        child: Row(
                          children: List.generate(items.length, (index) {
                            final item = items[index];
                            final double distance = (index - displayIndex).abs();
                            final double activeWeight = (1.0 - distance).clamp(0.0, 1.0);
                            final Color itemColor = Color.lerp(inactiveColor, activeColor, activeWeight)!;
                            final bool isActive = index == widget.currentIndex;

                            return SizedBox(
                              width: itemWidth,
                              child: GestureDetector(
                                onTap: () => widget.onTap(index),
                                behavior: HitTestBehavior.opaque,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _NavBarIcon(
                                      icon: item['icon'] as IconData,
                                      activeIcon: item['activeIcon'] as IconData,
                                      isActive: isActive,
                                      color: itemColor,
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final Color color;

  const _NavBarIcon({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.color,
  });

  @override
  State<_NavBarIcon> createState() => _NavBarIconState();
}

class _NavBarIconState extends State<_NavBarIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.25).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.25, end: 0.92).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 40.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.92, end: 1.0).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30.0,
      ),
    ]).animate(_controller);

    if (widget.isActive) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_NavBarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward(from: 0.0);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        widget.isActive ? widget.activeIcon : widget.icon,
        color: widget.color,
        size: 22,
      ),
    );
  }
}
