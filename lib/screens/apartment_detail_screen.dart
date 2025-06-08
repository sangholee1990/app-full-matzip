import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

//================================================================================
// 5. Apartment Detail Screen (Iphone13Mini4.dart 기반)
// 파일 경로: lib/screens/apartment_detail_screen.dart
//================================================================================
class ApartmentDetailScreen extends StatefulWidget {
  const ApartmentDetailScreen({super.key});
  @override
  State<ApartmentDetailScreen> createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen> with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  late TabController _tabController;
  final double _headerContentHeight = 95.0;

  // 스타일 정의...
  static const TextStyle _headerTitleStyle = TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w600, letterSpacing: -0.50,);
  static const TextStyle _logoTextStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Pretendard Variable');
  static const TextStyle _darkGreenTextS13 = TextStyle(color: Color(0xFF0C342C), fontSize: 13, fontFamily: 'Pretendard', fontWeight: FontWeight.w400);
  static const TextStyle _darkGreenBoldTextS18 = TextStyle(color: Color(0xFF0C342C), fontSize: 18, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, height: 1.28);
  static const TextStyle _propertyNameStyle = TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w600, letterSpacing: -0.04,);
  static const TextStyle _infoValueStyle = TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w400, letterSpacing: -0.04,);
  static const TextStyle _tabTextStyle = TextStyle(fontSize: 14, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w600, letterSpacing: -0.04,);
  final List<String> _tabs = ['소개', '키워드', '실거래가', '층별', '평형별', '매매가 예측'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final totalHeaderVisualHeight = statusBarHeight + _headerContentHeight;

    return Material(
      color: const Color(0xFFF7F8FA),
      child: Stack(
        children: [
          _buildCustomHeader(context, statusBarHeight, totalHeaderVisualHeight),
          Positioned(
            top: totalHeaderVisualHeight - 20,
            left: 0,
            right: 0,
            bottom: 0, // 하단 네비게이션 바가 없으므로 bottom 0
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildTopContentCard(context, screenWidth),
                // 상세 정보 내용들...
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, double statusBarHeight, double totalHeaderVisualHeight) {
    return Stack(children: [
      Positioned(left: 0, top: 0, right: 0, height: totalHeaderVisualHeight, child: Container(color: const Color(0xFF14B997))),
      Positioned(left: 0, top: statusBarHeight, right: 0, height: _headerContentHeight, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(alignment: Alignment.centerLeft, children: [
          Positioned(left: 0, top: 12, child: Row(children: const [Icon(Icons.maps_home_work_outlined, color: Colors.white, size: 24), SizedBox(width: 8), Text("MATZIP", style: _logoTextStyle)])),
          Positioned(right: 40, top: 12, child: IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 26), onPressed: () {})),
          Positioned(right: 0, top: 12, child: IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.person_outline, color: Colors.white, size: 26), onPressed: () {})),
          Positioned(left: -8, top: 12 + 35, child: IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24), onPressed: () => Navigator.pop(context))),
          const Positioned(left: 30, top: 12 + 35 + 2, right: 0, child: Text('AI 매물 추천 미리보기', style: _headerTitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ]),
      )),
    ]);
  }

  Widget _buildTopContentCard(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth, margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Color(0x19000000), blurRadius: 8, offset: Offset(0, 4), spreadRadius: 2)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('교육을 중시하는', style: _darkGreenTextS13),
            const Text('3040 부부에게 맞는 집', style: _darkGreenBoldTextS18),
            const SizedBox(height: 15), const Divider(color: Color(0xFFEAEAEA), thickness: 1), const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('양천벽산블루밀2단지', style: _propertyNameStyle), IconButton(icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.red : Colors.grey, size: 28), onPressed: () => setState(() => _isFavorite = !_isFavorite))]),
            const SizedBox(height: 5),
            Row(children: const [Icon(Icons.location_on_outlined, color: Color(0xFF757575), size: 16), SizedBox(width: 4), Flexible(child: Text('서울시 양천구 월정로9길 20(신월동 1027)', style: _infoValueStyle, overflow: TextOverflow.ellipsis))]),
            const SizedBox(height: 25),
            TabBar(controller: _tabController, isScrollable: true, labelColor: const Color(0xFF14B997), unselectedLabelColor: Colors.black, labelStyle: _tabTextStyle, indicatorColor: const Color(0xFF14B997), indicatorWeight: 3.0, tabs: _tabs.map((String name) => Tab(text: name)).toList()),
          ]),
        ),
        SizedBox(height: 800, child: TabBarView(controller: _tabController, children: [
          const Center(child: Text("소개 내용")),
          const Center(child: Text("키워드 내용")),
          const Center(child: Text("실거래가 내용")),
          const Center(child: Text("층별 내용")),
          const Center(child: Text("평형별 내용")),
          const Center(child: Text("매매가 예측 내용")),
        ])),
      ]),
    );
  }
}