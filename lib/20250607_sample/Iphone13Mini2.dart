import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

// Figma에서 생성된 코드: https://www.figma.com/community/plugin/842128343887142055/
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47), // 앱 전체 기본 배경색
      ),
      home: const Iphone13Mini2(), // Iphone13Mini2가 자체 Scaffold를 제공하여 화면을 구성
      debugShowCheckedModeBanner: false,
    );
  }
}

class Iphone13Mini2 extends StatelessWidget {
  const Iphone13Mini2({super.key});

  // 공통 TextStyle 정의
  static const TextStyle _headerTitleStyle = TextStyle(
    color: Color(0xFF161D24),
    fontSize: 20,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w700,
    letterSpacing: -0.50,
  );

  static const TextStyle _cardSmallTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _cardLargeTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    height: 1.28,
  );

  static const TextStyle _subscribeButtonTextStyle = TextStyle(
    color: Color(0xFF0C493C),
    fontSize: 16,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.04,
  );

  static const TextStyle _sectionTitleDarkStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle _sectionTitleDarkStyleMultiLine = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
    height: 1.39, // 줄 간격
    letterSpacing: -0.04,
  );

  static const TextStyle _dateTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.03,
  );

  static const TextStyle _searchInputPlaceholderStyle = TextStyle(
    color: Color(0xFF878787),
    fontSize: 14,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.04,
  );

  static const TextStyle _searchInputStyle = TextStyle( // TextField 입력 스타일
    color: Color(0xFF161D24),
    fontSize: 14,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.04,
  );

  static const TextStyle _filterButtonTextStyle = TextStyle(
    fontSize: 12,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.03,
  );

  static const TextStyle _listItemRankStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle _listItemNewStyle = TextStyle(color: Color(0xFF14B997), fontSize: 10, fontWeight: FontWeight.w400);
  static const TextStyle _listItemNameStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle _listItemDetailsStyle = TextStyle(color: Color(0xFF14B997), fontSize: 10, fontWeight: FontWeight.w400);

  static const TextStyle _seeMoreStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.04,
  );

  static const TextStyle _dropdownItemStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontFamily: 'Pretendard Variable',
  );

  static const TextStyle _bottomNavLabelStyle = TextStyle(
    fontSize: 11,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.03,
  );


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    const double figmaHeaderActualHeight = 15.0 + 27.0 + 10.0;


    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: figmaHeaderActualHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: SizedBox(
                        width: screenSize.width - 40,
                        child: const Text('AI 매물 추천 미리보기', style: _headerTitleStyle),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRecommendationCard(
                            context,
                            title: '교육을 중시하는',
                            subtitle: '3040 부부에게 \n맞는 집',
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0B4438), Color(0xFF1BAA8B)],
                            ),
                          ),
                          _buildRecommendationCard(
                            context,
                            title: '교통과 편의성을 중시하는',
                            subtitle: '2030 학생과 \n직장인에게 맞는 집',
                            color: const Color(0xFF14B997),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0x7F199C80)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(child: Text('구독하고 나에게 꼭 맞는 매물 추천 보기', style: _subscribeButtonTextStyle)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildTopListSection(
                        context: context,
                        titleLine1: '조회수',
                        titleLine2: 'TOP 10 아파트',
                        date: '2025-05-18',
                        showSearchBar: true,
                        filters: ["전국", "서울", "경기", "인천", "부산"],
                        listItems: [
                          _buildApartmentListItem("1", "삼청청담공원아파트(도산대로 96길)", "거래가 증가 + 100", hasUpArrow: true),
                          _buildApartmentListItem("2", "삼청청담공원아파트(도산대로 96길)", "거래가 증가 + 100", isNew: true),
                          _buildApartmentListItem("3", "삼청청담공원아파트(도산대로 96길)", "거래가 증가 + 100", isNew: true),
                          _buildApartmentListItem("4", "삼청청담공원아파트(도산대로 96길)", "거래가 증가 + 100", isNew: true),
                          _buildApartmentListItem("5", "삼청청담공원아파트(도산대로 96길)", "거래가 증가 + 100", isNew: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildTopListSection(
                        context: context,
                        titleLine1: '조회수',
                        titleLine2: 'TOP 10 지역',
                        date: '2025-05-18',
                        showDropdowns: true,
                        dropdown1Items: [
                          _buildDropdownItem('서울특별시', false, false, context),
                          _buildDropdownItem('경기도', false, true, context, hasArrow: true),
                        ],
                        dropdown2Items: [
                          _buildDropdownItem('고양시', false, false, context),
                          _buildDropdownItem('과천시', false, true, context, hasArrow: true),
                          _buildDropdownItem('광명시', false, false, context),
                          _buildDropdownItem('김포시', false, false, context),
                          _buildDropdownItem('남양주시', false, false, context),
                          _buildDropdownItem('동두천시', false, false, context),
                          _buildDropdownItem('성남시', false, false, context),
                          _buildDropdownItem('수원시', false, false, context),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 10, bottom: 5),
                            child: Text('더보기', style: _dropdownItemStyle.copyWith(fontSize: 10, color: Colors.white.withOpacity(0.5))),
                          ),
                        ],
                        listItems: [
                          _buildRegionListItem("1", "삼성청담공원 (지역 예시)", "조회수 증가 +100", hasUpArrow: true),
                          _buildRegionListItem("2", "삼성청담공원 (지역 예시)", "조회수 증가 +80", isNew: true),
                          _buildRegionListItem("3", "삼성청담공원 (지역 예시)", "조회수 증가 +70", isNew: false),
                          _buildRegionListItem("4", "삼성청담공원 (지역 예시)", "조회수 증가 +60", isNew: true),
                          _buildRegionListItem("5", "삼성청담공원 (지역 예시)", "조회수 증가 +50", isNew: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20 + 60),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                color: const Color(0xFFF7F8FA).withOpacity(0.95),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 92,
                      height: 27,
                      child: const Center(child: Text("[MATZIP Logo]", style: TextStyle(color: Colors.blueGrey, fontSize: 12))),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.notifications_none, color: Color(0xFF161D24), size: 24),
                        const SizedBox(width: 20),
                        const Icon(Icons.person_outline, color: Color(0xFF161D24), size: 24),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: screenSize.width,
        height: 60 + bottomPadding,
        padding: EdgeInsets.only(top: 5, bottom: bottomPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 5,
              offset: Offset(0, -5),
              spreadRadius: -3,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBottomNavItem(context, Icons.home_filled, '홈', true),
            _buildBottomNavItem(context, Icons.apartment, '아파트', false),
            _buildBottomNavItem(context, Icons.location_on_outlined, '로컬', false),
            _buildBottomNavItem(context, Icons.bar_chart, 'AI추천', false),
            _buildBottomNavItem(context, Icons.menu, '서비스', false),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, {required String title, required String subtitle, Gradient? gradient, Color? color}) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: (screenSize.width - 40 - 10) / 2,
      height: 190,
      padding: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        gradient: gradient,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _cardSmallTextStyle),
          const SizedBox(height: 10),
          Text(subtitle, style: _cardLargeTextStyle),
        ],
      ),
    );
  }

  Widget _buildTopListSection({
    required BuildContext context,
    required String titleLine1,
    required String titleLine2,
    required String date,
    bool showSearchBar = false,
    bool showDropdowns = false,
    List<String>? filters,
    List<Widget>? dropdown1Items,
    List<Widget>? dropdown2Items,
    required List<Widget> listItems,
  }) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: const Color(0xFF161D24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSearchBar) ...[
            Container(
              height: 35,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '아파트명을 입력하세요.',
                  hintStyle: _searchInputPlaceholderStyle,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 6.0),
                    child: Icon(Icons.search, color: Color(0xFF878787), size: 20),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                    right: 40,
                  ),
                ),
                style: _searchInputStyle,
              ),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: '$titleLine1\n', style: _sectionTitleDarkStyle),
                  TextSpan(text: titleLine2, style: _sectionTitleDarkStyleMultiLine),
                ]),
              ),
              Text('데이터 산출일 : $date', style: _dateTextStyle.copyWith(color: Colors.white.withOpacity(0.7))),
            ],
          ),
          const SizedBox(height: 20),
          if (filters != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: filters.map((label) => _buildFilterButton(label, label == filters.first)).toList(),
            ),
            const SizedBox(height: 20),
          ],
          if (showDropdowns && dropdown1Items != null && dropdown2Items != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStaticDropdownList(
                  context: context,
                  items: dropdown1Items,
                  width: (screenSize.width - 40 - 20 - 20 - 55 - 10) / 2,
                ),
                const SizedBox(width: 10),
                _buildStaticDropdownList(
                  context: context,
                  items: dropdown2Items,
                  width: (screenSize.width - 40 - 20 - 20 - 55 - 10) / 2,
                ),
                const Spacer(),
                Container(
                  width: 55,
                  height: 35,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14B997),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Center(child: Text('검색', style: _filterButtonTextStyle.copyWith(color: Colors.white, fontSize: 14))),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          ...listItems,
          const SizedBox(height: 15),
          Center(
            child: Opacity(
              opacity: 0.50,
              child: const Text('더보기', textAlign: TextAlign.center, style: _seeMoreStyle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF14B997) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: _filterButtonTextStyle.copyWith(color: isSelected ? Colors.white : const Color(0xFF878787)),
        ),
      ),
    );
  }

  // 아파트/지역 목록 아이템
  Widget _buildApartmentListItem(String rank, String name, String details, {bool isNew = false, bool hasUpArrow = false}) {
    // "NEW" 태그의 너비와 그 주변 간격을 대략적으로 정의
    const double newTagWidth = 30.0; // "NEW" 텍스트 너비
    const double newTagSpacing = 8.0; // "NEW" 태그와 이름 사이 간격
    const double rankColumnWidth = 35.0; // 순위/화살표 컬럼 너비

    return InkWell(
      onTap: () { /* TODO: 상세 페이지 이동 */ },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // 요소들을 세로 중앙 정렬
          children: [
            // 1. 순위 및 화살표 아이콘
            Container(
              width: rankColumnWidth,
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(rank, style: _listItemRankStyle, textAlign: TextAlign.center),
                  if (hasUpArrow) ...[
                    const SizedBox(width: 3),
                    const Icon(Icons.arrow_upward, color: Color(0xFF14B997), size: 14),
                  ]
                ],
              ),
            ),
            // 2. "NEW" 태그 (조건부 표시)
            if (isNew) ...[
              // const SizedBox(width: 5), // 순위와 NEW 태그 사이 간격 제거 또는 최소화
              Container(
                // width: newTagWidth, // 명시적 너비 대신 Text의 고유 너비 사용
                padding: const EdgeInsets.only(right: newTagSpacing), // NEW 태그와 이름 사이 간격
                child: const Text('NEW', style: _listItemNewStyle),
              ),
            ] else ...[
              // "NEW" 태그가 없을 때, 이름이 "NEW" 태그 위치만큼 밀리지 않도록 간격 추가
              SizedBox(width: newTagWidth + newTagSpacing - 5), // 대략적인 "NEW" 영역 너비만큼 확보, 기존 SizedBox(13+5)와 유사하게
            ],
            // 3. 아파트 이름 및 세부 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // 내부 텍스트들도 중앙 정렬되도록
                children: [
                  Text(name, style: _listItemNameStyle, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(details, style: _listItemDetailsStyle),
                ],
              ),
            ),
            // 4. 오른쪽 화살표 아이콘
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionListItem(String rank, String name, String details, {bool isNew = false, bool hasUpArrow = false}) {
    return _buildApartmentListItem(rank, name, details, isNew: isNew, hasUpArrow: hasUpArrow);
  }

  Widget _buildBottomNavItem(BuildContext context, IconData icon, String label, bool isSelected) {
    final color = isSelected ? const Color(0xFF14B997) : const Color(0xFF878787);
    return Expanded(
      child: InkWell(
        onTap: () {
          // TODO: 네비게이션 또는 상태 변경 로직
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: _bottomNavLabelStyle.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticDropdownList({required BuildContext context, required List<Widget> items, required double width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: ShapeDecoration(
        color: const Color(0xFF374957),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget _buildDropdownItem(String text, bool isSelected, bool isHighlighted, BuildContext context, {bool hasArrow = false}) {
    return InkWell(
      onTap: () {
        // TODO: 드롭다운 아이템 선택 시 로직 (상태 업데이트 등)
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        color: isHighlighted ? const Color(0xFF677A89) : Colors.transparent,
        child: Row(
          children: [
            if (hasArrow) Icon(Icons.play_arrow, size: 12, color: Colors.white.withOpacity(0.8)),
            if (hasArrow) const SizedBox(width: 5),
            Expanded(
              child: Text(
                text,
                style: _dropdownItemStyle.copyWith(fontWeight: isSelected || isHighlighted ? FontWeight.w600 : FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
