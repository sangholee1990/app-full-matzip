// lib/screens/local_screen.dart

import 'package:flutter/material.dart';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          // 상단 헤더 영역
          _Header(),
          // 하단 콘텐츠 영역
          _ContentBody(),
        ],
      ),
      bottomNavigationBar: CommonBottomNavBar(currentIndex: 2),
    );
  }
}

// 상단 헤더 위젯
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF161D24),
      automaticallyImplyLeading: false, // 뒤로가기 버튼 자동 생성 방지
      pinned: true,
      expandedHeight: 260,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: const Column(
            children: [
              _TopBar(),
              _Title(),
              _Filters(),
              Spacer(),
              _ReportButton(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

// 헤더 최상단 로고 및 아이콘
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo_matzip_white.png', // 흰색 로고로 변경
            width: 92,
            height: 27,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 헤더의 페이지 타이틀
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '로컬 데이터',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// 헤더의 필터 버튼들
class _Filters extends StatelessWidget {
  const _Filters();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(child: _buildFilterButton('경기도')),
          const SizedBox(width: 8),
          Expanded(child: _buildFilterButton('시/구')),
          const SizedBox(width: 8),
          Container(
            width: 65,
            height: 35,
            decoration: ShapeDecoration(
              color: const Color(0xFF14B997),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Center(
              child: Text(
                '검색',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Container(
      height: 35,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF878787),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// 헤더의 '보고서 출력' 버튼
class _ReportButton extends StatelessWidget {
  const _ReportButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 35,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF14B997),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            '보고서 출력',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// 하얀색 콘텐츠 영역
class _ContentBody extends StatelessWidget {
  const _ContentBody();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            _buildSection(title: '최고 거래가 아파트', child: _buildChartPlaceholder(height: 250)),
            _buildSection(title: '최고 거래량 아파트', child: _buildChartPlaceholder(height: 250)),
            _buildSection(title: '지역구 인구 변화', child: _buildChartPlaceholder(height: 250)),
            _buildSection(title: '입주 예정 물량', child: _buildChartPlaceholder(height: 250)),
            _buildSection(title: '미분양 추이', child: _buildChartPlaceholder(height: 250)),
            _buildSection(title: '매매가 변화율', child: _buildChartPlaceholder(height: 250)),
            _buildSection(title: '전세가 변화율', child: _buildChartPlaceholder(height: 250)),
            _buildSection(title: '시군구동별 평균가 비교', child: _buildChartPlaceholder(height: 250)),
            _buildSection(title: '지역구 거래 금액 / 거래량 분포', child: _buildChartPlaceholder(height: 250)),
            const SizedBox(height: 20),
            SizedBox(
              width: 335,
              height: 34,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF161D24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '목록으로',
                  style: TextStyle(
                    color: Color(0xFF14B997),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder({double height = 200}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!)
      ),
      child: const Center(
        child: Text('Chart Area', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}