// lib/screens/ai_recommendation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';
import 'package:flutter_svg/svg.dart'; // 공통 네비게이션 바 import

// 데이터 모델 클래스 (변경 없음)
class PropertyItem {
  final String rank;
  final IconData trendIcon;
  final Color trendIconColor;
  final String name;
  final String area;
  final String price;
  final String transport;
  PropertyItem({required this.rank, required this.trendIcon, required this.trendIconColor, required this.name, required this.area, required this.price, required this.transport});
}

class AiRecommendationScreen extends StatefulWidget {
  const AiRecommendationScreen({super.key});
  @override
  State<AiRecommendationScreen> createState() => _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends State<AiRecommendationScreen> {
  // [삭제] 네비게이션 인덱스를 관리하던 상태 변수 제거
  // int _currentBottomNavIndex = 3;

  final List<PropertyItem> _propertyItems = [
    PropertyItem(rank: '1', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '2', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '3', trendIcon: Icons.arrow_downward, trendIconColor: Colors.indigo.shade300, name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
  ];

  // 레이아웃을 위한 상수 (변경 없음)
  static const double _headerHeight = 100.0;
  static const double _subscriptionButtonHeight = 45.0;
  static const double _paddingBetweenButtonAndList = 16.0;
  static const double _paddingForSubscriptionButtonHorizontal = 20.0;

  // [삭제] 하단 네비게이션 바 높이를 직접 정의할 필요 없음
  // static const double _bottomNavBarHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Image.asset('images/logo_matzip_white.png', width: 92, height: 27)
                            SvgPicture.asset('svg/logo_matzip_white.svg',
                                width: 92),
                          ])),
                  // child: Row(children: const [
                      //   Icon(Icons.business_center, color: Colors.white, size: 24),
                      //   SizedBox(width: 8),
                      //   Text("MATZIP", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Pretendard Variable'))
                      // ])),
                  const Positioned(right: 35, top: 12, child: Icon(Icons.notifications_none, color: Colors.white, size: 26)),
                  const Positioned(right: 0, top: 12, child: Icon(Icons.person_outline, color: Colors.white, size: 26)),
                  Positioned(left: -10, top: 12 + 40, child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24), onPressed: () => Navigator.pop(context))),
                  const Positioned(left: 30, top: 12 + 46, right: 0, child: Text('AI 매물 추천 미리보기', style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w600, letterSpacing: -0.50), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
          Positioned(
            top: totalHeaderVisualHeight, left: 0, right: 0,
            // [수정] bottom 계산 시 네비게이션 바와 safe area 높이를 고려할 필요 없음
            bottom: totalSubscriptionButtonAreaHeight,
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
          Positioned(
            // [수정] bottom 계산 시 네비게이션 바와 safe area 높이를 고려할 필요 없음
            left: _paddingForSubscriptionButtonHorizontal, right: _paddingForSubscriptionButtonHorizontal, bottom: _paddingBetweenButtonAndList, height: _subscriptionButtonHeight,
            child: Container(
              decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: const Color(0xFF14B997).withOpacity(0.5)), borderRadius: BorderRadius.circular(8)), shadows: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))]),
              child: const Center(child: Text('구독하고 나에게 꼭 맞는 매물 추천 보기', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF0C493C), fontSize: 15, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w600, letterSpacing: -0.04))),
            ),
          ),
        ],
      ),
      // [수정] 직접 구현했던 네비게이션 바를 CommonBottomNavigationBar 위젯으로 교체
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildListItemWidget(PropertyItem item) {
    return InkWell(
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

// [삭제] 불필요해진 하단 네비게이션 관련 위젯 빌더 및 콜백 함수 제거
// Widget _buildBottomNavItemContent(...) {}
// void _onBottomNavItemTapped(...) {}
}