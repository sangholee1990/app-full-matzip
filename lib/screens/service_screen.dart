// lib/screens/service_screen.dart

import 'package:flutter/material.dart';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [수정] 데이터 구조는 Map으로 유지하되, 리스트 선언 시 const 제거
    final List<Map<String, dynamic>> serviceItems = [
      {
        // 'iconAssetPath': 'images/icon_calendar.png',
        'iconAssetPath': 'svg/icon_calendar.svg',
        'title': '월 정기구독 상품',
        'description': '원하는 지역구의 아파트별 시각화 및 \n예측 정보를 볼 수 있는 보고서와 AI매물 추천 서비스를 무제한으로 이용할 수 있습니다.',
        'buttonText': '장바구니 담기',
        'onPressed': () {
          _showCustomSnackBar(context, '서비스 준비 중입니다.');
        },
      },
      {
        // 'iconAssetPath': 'images/icon_report.png',
        'iconAssetPath': 'svg/icon_report.svg',
        'title': '보고서 단건 상품',
        'description': '사용자는 임장 시 용이한 \n아파트 보고서(단건)를 출력하여 이용할 수 있습니다.',
        'buttonText': '장바구니 담기',
        'onPressed': () {
          _showCustomSnackBar(context, '서비스 준비 중입니다.');
        },
      },
      {
        // 'iconAssetPath': 'images/icon_dashboard.png',
        'iconAssetPath': 'svg/icon_dashboard.svg',
        'title': 'API 서비스 구축 상품',
        'description': '원하시는 조건에 맞는 \n부동산 데이터 API 제작 및 데이터 센터를 구축해 드립니다.',
        'buttonText': '신청하기',
        'onPressed': () {
          _showCustomSnackBar(context, '신청이 완료되었습니다. 담당자가 곧 연락드릴 예정입니다.');
        },
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      // [수정] 표준 AppBar를 사용하여 상단 바를 고정하고 통일성 확보
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset('svg/logo_matzip_color.svg', width: 92),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        // [핵심] ConstrainedBox가 넓은 화면에서 콘텐츠가 과도하게 늘어나는 것을 막아줌
        child: ConstrainedBox(
          constraints: const BoxConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 페이지 타이틀
              _buildPageTitle(),
              // [수정] 반응형 로직을 제거하고 항상 ListView만 사용하도록 고정
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: serviceItems.length,
                  itemBuilder: (context, index) {
                    return _ServiceCard(item: serviceItems[index]);
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 4),
    );
  }

  // SnackBar 헬퍼 함수는 그대로 유지하여 중복 제거
  void _showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        backgroundColor: const Color(0xFF424242),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Image.asset(
          //   'images/logo_matzip_color.png',
          //   width: 92,
          //   height: 27,
          // ),
          SvgPicture.asset(
            'svg/logo_matzip_color.svg',
            width: 92,
          ),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.grey),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.grey),
                  onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        '서비스',
        style: TextStyle(
          color: Color(0xFF161D24),
          fontSize: 24,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// [수정] item 파라미터를 Map<String, dynamic>으로 받는 반응형 카드 위젯
class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ServiceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    // [수정] LayoutBuilder와 반응형 분기 로직 제거
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.02, -1.00),
          end: Alignment(1.0, 1.0),
          colors: [Color(0xFF161D24), Color(0xFF546F8A)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      // [수정] 항상 가로형 레이아웃(_buildWideLayout)만 사용
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardIcon(),
          const SizedBox(width: 16),
          Expanded(child: _buildCardContent(context)),
        ],
      ),
    );
  }


  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardIcon(),
        const SizedBox(width: 16),
        Expanded(child: _buildCardContent(context)),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCardIcon(),
        const SizedBox(height: 20),
        _buildCardContent(context),
      ],
    );
  }

  Widget _buildCardIcon() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      // child: Center(child: Image.asset(item['iconAssetPath'], width: 100, height: 100)),
      child: Center(child: SvgPicture.asset(item['iconAssetPath'], width: 100, height: 100)),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['title'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          item['description'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: item['onPressed'],
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: Text(
              item['buttonText'],
              style: const TextStyle(
                color: Color(0xFF161D24),
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}