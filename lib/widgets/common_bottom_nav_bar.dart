import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

//================================================================================
// 2. [신규] 일관성을 위한 공통 하단 네비게이션 바 위젯
// 파일 경로: lib/widgets/common_bottom_nav_bar.dart
//================================================================================
// 2-1. 공통 상단 앱바
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: showBackButton ? 120 : 100,
      leading: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          else
            const SizedBox(width: 16), // 뒤로가기 버튼 없을 때 여백

          const Icon(Icons.maps_home_work_outlined, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          const Text(
            "MATZIP",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // fontSize: 18,
                fontFamily: 'Pretendard Variable'),
          ),
        ],
      ),
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () { /* 알림 처리 */ },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () { /* 프로필 처리 */ },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


// 2-2. 공통 하단 네비게이션 바
class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      if (index == currentIndex) return;

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/apartment-data');
          break;
        case 2:
          // Navigator.pushReplacementNamed(context, '/apartment-details');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/ai-recommendation-preview');
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/service');
          break;
      }
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF14B997),
      unselectedItemColor: const Color(0xFF878787),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Pretendard Variable', fontSize: 11),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Pretendard Variable', fontSize: 11),
      currentIndex: currentIndex,
      onTap: onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.apartment_outlined), activeIcon: Icon(Icons.apartment), label: '아파트'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), activeIcon: Icon(Icons.location_on), label: '로컬'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'AI추천'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), activeIcon: Icon(Icons.menu), label: '서비스'),
      ],
    );
  }
}