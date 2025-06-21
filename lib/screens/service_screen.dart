// lib/screens/service_screen.dart

import 'package:flutter/material.dart';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';

// [수정] _ServiceItem 클래스 제거

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [수정] 데이터 구조를 List<Map<String, dynamic>>으로 변경
    final List<Map<String, dynamic>> serviceItems = [
      {
        'iconAssetPath': 'images/icon_calendar.png',
        'title': '월 정기구독 상품',
        'description': '원하는 지역구의 아파트별 시각화 및 \n예측 정보를 볼 수 있는 보고서와 AI매물 추천 서비스를 무제한으로 이용할 수 있습니다.',
        'buttonText': '장바구니 담기',
        'onPressed': () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text('서비스 준비 중입니다.'),
                ],
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              backgroundColor: const Color(0xFF424242),
            ),
          );
        },
      },
      {
        'iconAssetPath': 'images/icon_report.png',
        'title': '보고서 단건 상품',
        'description': '사용자는 임장 시 용이한 \n아파트 보고서(단건)를 출력하여 이용할 수 있습니다.',
        'buttonText': '장바구니 담기',
        'onPressed': () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text('서비스 준비 중입니다.'),
                ],
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              backgroundColor: const Color(0xFF424242),
            ),
          );
        },
      },
      {
        'iconAssetPath': 'images/icon_dashboard.png',
        'title': 'API 서비스 구축 상품',
        'description': '원하시는 조건에 맞는 \n부동산 데이터 API 제작 및 데이터 센터를 구축해 드립니다.',
        'buttonText': '신청하기',
        'onPressed': () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text('신청이 완료되었습니다. 담당자가 곧 연락드릴 예정입니다.'),
                ],
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              backgroundColor: const Color(0xFF424242),
            ),
          );
        },
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                _buildPageTitle(),
                Expanded(
                  child: ListView.separated(
                    // padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    itemCount: serviceItems.length,
                    itemBuilder: (context, index) {
                      return _buildServiceCard(item: serviceItems[index]);
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CommonBottomNavigationBar(currentIndex: 4),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'images/logo_matzip_color.png',
            width: 92,
            height: 27,
          ),
          Row(
            children: [
              IconButton(
                icon: Image.asset('images/icon_bell.png',
                    width: 24, height: 24),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset('images/icon_person.png',
                    width: 24, height: 24),
                onPressed: () {},
              ),
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

Widget _buildCardIcon(String assetPath) {
  return Container(
    width: 150,
    height: 150,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      shape: BoxShape.circle,
    ),
    child: Center(child: Image.asset(assetPath, width: 100, height: 100)),
  );
}

// [수정] Map<String, dynamic>을 파라미터로 받도록 변경
Widget _buildServiceCard({required Map<String, dynamic> item}) {
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardIcon(item['iconAssetPath']),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
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
          ),
        ),
      ],
    ),
  );
}