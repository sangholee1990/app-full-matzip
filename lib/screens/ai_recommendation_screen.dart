import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';

//================================================================================
// 4. AI Recommendation Screen (Iphone13Mini3.dart 기반)
// 파일 경로: lib/screens/ai_recommendation_screen.dart
//================================================================================
class PropertyItem {
  final String rank; final IconData trendIcon; final Color trendIconColor; final String name; final String area; final String price; final String transport;
  PropertyItem({required this.rank, required this.trendIcon, required this.trendIconColor, required this.name, required this.area, required this.price, required this.transport});
}

class AiRecommendationScreen extends StatefulWidget {
  const AiRecommendationScreen({super.key});
  @override
  State<AiRecommendationScreen> createState() => _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends State<AiRecommendationScreen> {
  int _currentBottomNavIndex = 3;

  final List<PropertyItem> _propertyItems = [
    PropertyItem(rank: '1', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '2', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '3', trendIcon: Icons.arrow_downward, trendIconColor: Colors.indigo.shade300, name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
  ];

  static const double _headerHeight = 100.0;
  static const double _subscriptionButtonHeight = 45.0;
  static const double _paddingBetweenButtonAndList = 16.0;
  static const double _paddingForSubscriptionButtonHorizontal = 20.0;
  static const double _bottomNavBarHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final double totalHeaderVisualHeight = _headerHeight + statusBarHeight;
    final double totalSubscriptionButtonAreaHeight = _subscriptionButtonHeight + _paddingBetweenButtonAndList;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Stack(
        children: [
          Positioned(left: 0, top: 0, right: 0, height: totalHeaderVisualHeight, child: Container(color: const Color(0xFF14B997))),
          Positioned(
            left: 0, top: statusBarHeight, right: 0, height: _headerHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                      left: 0,
                      top: 12,
                      child: Row(children: const [
                        Icon(Icons.business_center,
                            color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text("MATZIP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard Variable'))
                      ])),
                  const Positioned(right: 35, top: 12, child: Icon(Icons.notifications_none, color: Colors.white, size: 26)),
                  const Positioned(right: 0, top: 12, child: Icon(Icons.person_outline, color: Colors.white, size: 26)),
                  Positioned(left: -4, top: 12 + 40, child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24), onPressed: () => Navigator.pop(context))), // ** 뒤로가기 기능 추가 **
                  const Positioned(left: 30, top: 12 + 41, right: 0, child: Text('AI 매물 추천 미리보기', style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w600, letterSpacing: -0.50), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
          Positioned(
            top: totalHeaderVisualHeight, left: 0, right: 0,
            bottom: totalSubscriptionButtonAreaHeight + _bottomNavBarHeight + bottomSafeArea,
            child: Container(
              decoration: const ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ..._propertyItems.expand((item) => [_buildListItemWidget(item), Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey[200])]).toList()..removeLast(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          // ... (하단 구독 버튼, 네비게이션 바 등 UI 코드는 원본과 동일하게 유지)
          Positioned(
            left: _paddingForSubscriptionButtonHorizontal, right: _paddingForSubscriptionButtonHorizontal, bottom: _bottomNavBarHeight + bottomSafeArea + _paddingBetweenButtonAndList, height: _subscriptionButtonHeight,
            child: Container(
              decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: const Color(0xFF14B997).withOpacity(0.5)), borderRadius: BorderRadius.circular(8)), shadows: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))]),
              child: const Center(child: Text('구독하고 나에게 꼭 맞는 매물 추천 보기', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF0C493C), fontSize: 15, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w600, letterSpacing: -0.04))),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: _bottomNavBarHeight + bottomSafeArea, padding: EdgeInsets.only(bottom: bottomSafeArea),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(child: InkWell(onTap: () => _onBottomNavItemTapped(0), child: _buildBottomNavItemContent(Icons.home_filled, '홈', _currentBottomNavIndex == 0))),
            Expanded(child: InkWell(onTap: () => _onBottomNavItemTapped(1), child: _buildBottomNavItemContent(Icons.apartment, '아파트', _currentBottomNavIndex == 1))),
            Expanded(child: InkWell(onTap: () => _onBottomNavItemTapped(2), child: _buildBottomNavItemContent(Icons.location_on, '로컬', _currentBottomNavIndex == 2))),
            Expanded(child: InkWell(onTap: () => _onBottomNavItemTapped(3), child: _buildBottomNavItemContent(Icons.bar_chart, 'AI추천', _currentBottomNavIndex == 3))),
            Expanded(child: InkWell(onTap: () => _onBottomNavItemTapped(4), child: _buildBottomNavItemContent(Icons.menu, '서비스', _currentBottomNavIndex == 4))),
          ],
        ),
      ),
    );
  }

  // --- 위젯 빌더 함수들 (원본 코드와 동일하게 유지) ---
  Widget _buildListItemWidget(PropertyItem item) {
    return InkWell( // ** 네비게이션 추가 **
      onTap: () => Navigator.pushNamed(context, '/apartment-details'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 40, child: Row(children: [Text(item.rank, style: const TextStyle(color: Colors.black87, fontSize: 14, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w500)), const SizedBox(width: 5), Icon(item.trendIcon, color: item.trendIconColor, size: 18)])),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name, style: const TextStyle(color: Colors.black87, fontSize: 15, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 6),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildDetailColumn('전용면적', item.area, flex: 3), const SizedBox(width: 8), _buildDetailColumn('거래금액', item.price, flex: 3), const SizedBox(width: 8), _buildDetailColumn('교통', item.transport, flex: 4)])
              ]),
            ),
            const SizedBox(width: 10), Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String title, String value, {int flex = 1}) {
    return Expanded(flex: flex, child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [Text('$title: ', style: TextStyle(color: const Color(0xFF14B997).withOpacity(0.9), fontSize: 11, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w500)), Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF14B997), fontSize: 12, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 1))]));
  }
  Widget _buildBottomNavItemContent(IconData icon, String label, bool isSelected) {
    final color = isSelected ? const Color(0xFF14B997) : Colors.grey[600];
    return Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color, size: 24), const SizedBox(height: 4), Text(label, style: TextStyle(color: color, fontSize: 10, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w400))]);
  }
  void _onBottomNavItemTapped(int index) {
    setState(() { _currentBottomNavIndex = index; });
    // 홈 화면으로 이동하는 로직 추가
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
