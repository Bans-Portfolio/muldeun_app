import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../canvas/screens/canvas_screen.dart';
import '../../diary/screens/diary_screen.dart';
import '../../palette/screens/palette_screen.dart';
import '../../record/screens/camera_screen.dart';
import 'home_screen.dart';

/// 메인 스카폴드 — 5개 탭
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();

  static void goToCamera(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainScaffoldState>();
    state?._setIndex(2);
  }

  static void goToDiary(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainScaffoldState>();
    state?._setIndex(1);
  }

  static void goToPalette(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainScaffoldState>();
    state?._setIndex(4);
  }
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  void _setIndex(int index) {
    setState(() => _currentIndex = index);
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    DiaryScreen(),
    CameraScreen(),
    CanvasScreen(),
    PaletteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _setIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: '다이어리',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              activeIcon: Icon(Icons.camera_alt),
              label: '카메라',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.brush_outlined),
              activeIcon: Icon(Icons.brush),
              label: '캔버스',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.palette_outlined),
              activeIcon: Icon(Icons.palette),
              label: '팔레트',
            ),
          ],
        ),
      ),
    );
  }
}
