import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

// 참고: 이 앱을 실행하려면 pubspec.yaml 파일에 다음 종속성을 추가해야 합니다.
// dependencies:
//   flutter:
//     sdk: flutter
//   fl_chart: ^0.68.0 # 최신 버전 확인

void main() {
  runApp(const MatzipApp());
}

// --- Data Models ---
// 여러 화면에서 사용될 수 있는 데이터 모델을 통합하여 관리합니다.

class PropertyItem {
  final String rank;
  final IconData trendIcon;
  final Color trendIconColor;
  final String name;
  final String area;
  final String price;
  final String transport;

  PropertyItem({
    required this.rank,
    required this.trendIcon,
    required this.trendIconColor,
    required this.name,
    required this.area,
    required this.price,
    required this.transport,
  });
}

class ApartmentInfo {
  final String id;
  final String name;
  final String area;
  final String price;
  final String transport;
  final IconData trendIcon;
  final Color trendIconColor;

  ApartmentInfo({
    required this.id,
    required this.name,
    required this.area,
    required this.price,
    required this.transport,
    this.trendIcon = Icons.arrow_upward,
    this.trendIconColor = const Color(0xFF14B997),
  });
}

class TransactionData {
  final String date;
  final String area;
  final String price;
  final String floor;
  TransactionData(this.date, this.area, this.price, this.floor);
}

class AreaTransactionData {
  final String area;
  final String volume;
  final String price;
  AreaTransactionData(this.area, this.volume, this.price);
}

class GapData {
  final String area;
  final String salePrice;
  final String gapPrice;
  final String changeAmount;
  final String changeRate;
  GapData(this.area, this.salePrice, this.gapPrice, this.changeAmount, this.changeRate);
}

class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;
  Tuple2(this.item1, this.item2);
}


// --- Main App Widget ---
// 앱의 최상위 위젯으로, 테마와 라우팅을 설정합니다.

class MatzipApp extends StatelessWidget {
  const MatzipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MATZIP',
      theme: ThemeData(
        primaryColor: const Color(0xFF14B997),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        fontFamily: 'Pretendard',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF14B997),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Pretendard'),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Pretendard', color: Colors.black87),
          labelLarge: TextStyle(fontFamily: 'Pretendard'),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF14B997),
          unselectedItemColor: Color(0xFF878787),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      // 앱 시작 시 스플래시 화면을 먼저 보여줍니다.
      home: const SplashScreen(),
      // 네비게이션을 위한 라우트 정의
      routes: {
        '/main': (context) => const MainScreen(),
        '/ai_recommendation': (context) => const AiRecommendationPreviewScreen(),
        '/property_detail': (context) => const PropertyDetailScreen(),
        '/apartment_list': (context) => const ApartmentListScreen(),
      },
    );
  }
}

// --- Main Navigation Host ---
// 하단 네비게이션 바를 관리하고 현재 선택된 화면을 보여주는 호스트 위젯입니다.

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 하단 네비게이션 바에 연결될 화면 목록
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),         // Iphone13Mini2
    ApartmentListScreen(),// Iphone13Mini5
    Center(child: Text('로컬 화면')), // Placeholder
    AiRecommendationPreviewScreen(), // Iphone13Mini3
    Center(child: Text('전체 서비스 화면')), // Placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // 화면 전환 시 상태를 유지하기 위해 IndexedStack 사용
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.apartment_outlined), activeIcon: Icon(Icons.apartment), label: '아파트'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), activeIcon: Icon(Icons.location_on), label: '로컬'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'AI추천'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: '서비스'),
        ],
      ),
    );
  }
}


// --- Screen 1: Splash Screen (from Iphone13Mini1.dart) ---

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // 3초 후 메인 화면으로 자동 전환
  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle matzipTitleStyle = TextStyle(
      color: Colors.white,
      fontSize: 64,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w900,
      letterSpacing: 1.2,
    );
    const TextStyle subtitleStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      height: 1.78,
      letterSpacing: -0.45,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF076653), Color(0xFF0C342C)],
          ),
        ),
        child: Stack(
          children: [
            // 장식용 배경 도형들
            Positioned(left: -72, top: -111, child: _buildDecorativeShape(347, 923, const [Color(0xFF1EA78A), Color(0xFF0C4136)])),
            Positioned(left: 142, top: 42, child: _buildDecorativeShape(347, 858, const [Color(0xFF14B997), Color(0xFF095344)])),
            Positioned(left: -38, top: 319, child: _buildDecorativeShape(278, 493, const [Color(0xFF0B4438), Color(0xFF137963), Color(0xFF1BAA8B)])),
            Positioned(left: 190, top: 516, child: _buildDecorativeShape(233, 351, const [Color(0xFF076653), Color(0xFF0C342C)])),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('MATZIP', textAlign: TextAlign.center, style: matzipTitleStyle),
                  const SizedBox(height: 28),
                  const SizedBox(
                    width: 248,
                    height: 96,
                    child: Text(
                      'AI 매물 추천\n아파트 빅데이터 보고서\n아파트 미래가격 예측',
                      textAlign: TextAlign.center,
                      style: subtitleStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeShape(double width, double height, List<Color> colors) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.50, -0.00),
          end: const Alignment(0.50, 1.00),
          colors: colors,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(width / 2),
            topRight: Radius.circular(width / 2),
          ),
        ),
      ),
    );
  }
}


// --- Screen 2: Home Screen (from Iphone13Mini2.dart) ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 스타일 상수 정의
  static const TextStyle _headerTitleStyle = TextStyle(color: Color(0xFF161D24), fontSize: 20, fontWeight: FontWeight.w700);
  static const TextStyle _cardSmallTextStyle = TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400);
  static const TextStyle _cardLargeTextStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, height: 1.28);
  static const TextStyle _subscribeButtonTextStyle = TextStyle(color: Color(0xFF0C493C), fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle _sectionTitleDarkStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle _sectionTitleDarkStyleMultiLine = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, height: 1.39);
  static const TextStyle _dateTextStyle = TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400);
  static const TextStyle _searchInputPlaceholderStyle = TextStyle(color: Color(0xFF878787), fontSize: 14, fontWeight: FontWeight.w600);
  static const TextStyle _filterButtonTextStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
  static const TextStyle _listItemRankStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle _listItemNewStyle = TextStyle(color: Color(0xFF14B997), fontSize: 10, fontWeight: FontWeight.w400);
  static const TextStyle _listItemNameStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle _listItemDetailsStyle = TextStyle(color: Color(0xFF14B997), fontSize: 10, fontWeight: FontWeight.w400);
  static const TextStyle _dropdownItemStyle = TextStyle(color: Colors.white, fontSize: 12);
  static const TextStyle _seeMoreStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(Icons.maps_home_work_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text("MATZIP", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        title: const Text('홈'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.white), onPressed: () {}),
          const SizedBox(width: 12),
        ],
        backgroundColor: const Color(0xFF161D24), // 헤더 색상 통일
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text('AI 매물 추천 미리보기', style: _headerTitleStyle),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRecommendationCard(context, title: '교육을 중시하는', subtitle: '3040 부부에게 \n맞는 집', gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0B4438), Color(0xFF1BAA8B)])),
                  _buildRecommendationCard(context, title: '교통과 편의성을 중시하는', subtitle: '2030 학생과 \n직장인에게 맞는 집', color: const Color(0xFF14B997)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 40,
                decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(width: 1, color: Color(0x7F199C80)), borderRadius: BorderRadius.circular(10))),
                child: const Center(child: Text('구독하고 나에게 꼭 맞는 매물 추천 보기', style: _subscribeButtonTextStyle)),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildTopListSection(
                context: context, title: '조회수 TOP 10 아파트', date: '2025-05-18', showSearchBar: true, filters: ["전국", "서울", "경기", "인천", "부산"],
                listItems: [
                  _buildApartmentListItem(context, "1", "삼청청담공원아파트(도산대로 96길)", "거래가 증가 + 100", hasUpArrow: true),
                  _buildApartmentListItem(context, "2", "삼청청담공원아파트(도산대로 96길)", "거래가 증가 + 100", isNew: true),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildTopListSection(
                context: context, title: '조회수 TOP 10 지역', date: '2025-05-18', showDropdowns: true,
                dropdown1Items: [_buildDropdownItem('서울특별시', false, false, context), _buildDropdownItem('경기도', false, true, context, hasArrow: true)],
                dropdown2Items: [_buildDropdownItem('고양시', false, false, context), _buildDropdownItem('과천시', false, true, context, hasArrow: true)],
                listItems: [
                  _buildRegionListItem(context, "1", "삼성청담공원 (지역 예시)", "조회수 증가 +100", hasUpArrow: true),
                  _buildRegionListItem(context, "2", "삼성청담공원 (지역 예시)", "조회수 증가 +80", isNew: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, {required String title, required String subtitle, Gradient? gradient, Color? color}) {
    final screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/property_detail'),
      child: Container(
        width: (screenSize.width - 50) / 2,
        height: 190,
        padding: const EdgeInsets.all(15),
        decoration: ShapeDecoration(gradient: gradient, color: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: _cardSmallTextStyle), const SizedBox(height: 10), Text(subtitle, style: _cardLargeTextStyle)]),
      ),
    );
  }

  Widget _buildTopListSection({required BuildContext context, required String title, required String date, bool showSearchBar = false, bool showDropdowns = false, List<String>? filters, List<Widget>? dropdown1Items, List<Widget>? dropdown2Items, required List<Widget> listItems}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(color: const Color(0xFF161D24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        if (showSearchBar) ...[
          Container(height: 35, decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const TextField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '아파트명을 입력하세요.', hintStyle: _searchInputPlaceholderStyle, suffixIcon: Icon(Icons.search, color: Color(0xFF878787), size: 20), border: InputBorder.none, isDense: true))),
          const SizedBox(height: 20),
        ],
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(title, style: _sectionTitleDarkStyle),
          Text('데이터 산출일 : $date', style: _dateTextStyle.copyWith(color: Colors.white.withOpacity(0.7))),
        ]),
        const SizedBox(height: 20),
        if (filters != null) ...[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: filters.map((label) => _buildFilterButton(label, label == filters.first)).toList()),
          const SizedBox(height: 20),
        ],
        ...listItems,
        const SizedBox(height: 15),
        const Center(child: Opacity(opacity: 0.50, child: Text('더보기', textAlign: TextAlign.center, style: _seeMoreStyle))),
      ]),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: ShapeDecoration(color: isSelected ? const Color(0xFF14B997) : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Text(text, textAlign: TextAlign.center, style: _filterButtonTextStyle.copyWith(color: isSelected ? Colors.white : const Color(0xFF878787))),
      ),
    );
  }

  Widget _buildApartmentListItem(BuildContext context, String rank, String name, String details, {bool isNew = false, bool hasUpArrow = false}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/property_detail'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(width: 35, child: Row(children: [Text(rank, style: _listItemRankStyle), if (hasUpArrow) ...[const SizedBox(width: 3), const Icon(Icons.arrow_upward, color: Color(0xFF14B997), size: 14)]])),
          if (isNew) Container(padding: const EdgeInsets.only(right: 8.0), child: const Text('NEW', style: _listItemNewStyle)) else const SizedBox(width: 38),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: _listItemNameStyle, overflow: TextOverflow.ellipsis), const SizedBox(height: 3), Text(details, style: _listItemDetailsStyle)])),
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        ]),
      ),
    );
  }

  Widget _buildRegionListItem(BuildContext context, String rank, String name, String details, {bool isNew = false, bool hasUpArrow = false}) {
    return _buildApartmentListItem(context, rank, name, details, isNew: isNew, hasUpArrow: hasUpArrow);
  }

  Widget _buildDropdownItem(String text, bool isSelected, bool isHighlighted, BuildContext context, {bool hasArrow = false}) {
    return InkWell(onTap: () {}, child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), color: isHighlighted ? const Color(0xFF677A89) : Colors.transparent, child: Row(children: [if (hasArrow) Icon(Icons.play_arrow, size: 12, color: Colors.white.withOpacity(0.8)), if (hasArrow) const SizedBox(width: 5), Expanded(child: Text(text, style: _dropdownItemStyle.copyWith(fontWeight: isSelected || isHighlighted ? FontWeight.w600 : FontWeight.w400)))])));
  }
}


// --- Screen 3: AI Recommendation Preview (from Iphone13Mini3.dart) ---

class AiRecommendationPreviewScreen extends StatefulWidget {
  const AiRecommendationPreviewScreen({super.key});

  @override
  State<AiRecommendationPreviewScreen> createState() => _AiRecommendationPreviewScreenState();
}

class _AiRecommendationPreviewScreenState extends State<AiRecommendationPreviewScreen> {
  final List<PropertyItem> _propertyItems = List.generate(7, (index) => PropertyItem(rank: '${index + 1}', trendIcon: index < 5 ? Icons.arrow_upward : Icons.arrow_downward, trendIconColor: index < 5 ? const Color(0xFF14B997) : Colors.indigo.shade300, name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '8억 4770만', transport: '58개(56.0점)'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 매물 추천 미리보기'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(20),
              child: const Center(
                  child: Text(
                    '로그인/구독 시\n더 많은 추천을 볼 수 있습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("추천 매물 목록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _propertyItems.length,
                    itemBuilder: (context, index) => _buildListItemWidget(_propertyItems[index]),
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0C493C),
                      side: const BorderSide(color: Color(0xFF14B997)),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text('구독하고 나에게 꼭 맞는 매물 추천 보기'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListItemWidget(PropertyItem item) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/property_detail'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(children: [
          SizedBox(width: 40, child: Row(children: [Text(item.rank, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)), const SizedBox(width: 5), Icon(item.trendIcon, color: item.trendIconColor, size: 18)])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(children: [
                _buildDetailColumn('전용면적', item.area, flex: 3),
                _buildDetailColumn('거래금액', item.price, flex: 3),
                _buildDetailColumn('교통', item.transport, flex: 4),
              ]),
            ]),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ]),
      ),
    );
  }

  Widget _buildDetailColumn(String title, String value, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
        Text('$title: ', style: TextStyle(color: const Color(0xFF14B997).withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w500)),
        Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF14B997), fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 1)),
      ]),
    );
  }
}

// --- Screen 4: Property Detail Screen (from Iphone13Mini4.dart) ---

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  late TabController _tabController;
  final List<String> _tabs = ['소개', '키워드', '실거래가', '층별', '평형별', '매매가 예측'];
  final List<String> _infraTabs = ['교육', '교통', '주거환경', '편의시설'];
  int _activeInfraTabIndex = 0;

  // 스타일 상수
  static const TextStyle _propertyNameStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle _tabTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static const TextStyle _infoLabelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle _infoValueStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle _sectionTitleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle _chartAxisLabelStyle = TextStyle(color: Color(0xFF878787), fontSize: 10, fontWeight: FontWeight.w400);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('아파트 상세 정보'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.red : Colors.white),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('양천벽산블루밀2단지', style: _propertyNameStyle),
                    const SizedBox(height: 5),
                    const Row(children: [Icon(Icons.location_on_outlined, color: Colors.grey, size: 16), SizedBox(width: 4), Flexible(child: Text('서울시 양천구 월정로9길 20', style: _infoValueStyle, overflow: TextOverflow.ellipsis))]),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black,
                  labelStyle: _tabTextStyle,
                  tabs: _tabs.map((name) => Tab(text: name)).toList(),
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((name) {
            // 각 탭에 해당하는 컨텐츠 위젯을 반환합니다.
            switch (name) {
              case '소개': return _buildIntroductionTab();
              case '키워드': return _buildKeywordsTab();
              case '실거래가': return _buildPriceTab();
              case '층별': return _buildFloorTab();
              case '평형별': return _buildAreaTypeTab();
              case '매매가 예측': return _buildPredictionTab();
              default: return Center(child: Text('$name 콘텐츠'));
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: _sectionTitleStyle),
        const SizedBox(height: 15),
        content,
      ]),
    );
  }

  // 각 탭의 내용을 구성하는 메소드
  Widget _buildIntroductionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildSectionContainer(title: "단지 상세 정보", content: _buildDetailedInfoTable()),
          _buildSectionContainer(title: "주변 인프라", content: _buildInfrastructureContent())
        ],
      ),
    );
  }

  Widget _buildDetailedInfoTable() {
    return Column(children: [
      _buildInfoTableRow('도로명 주소', '서울시 양천구 월정로9길 20'),
      _buildInfoTableRow('건축년도', '2006. 9. (준공일 / 19년차)'),
      _buildInfoTableRow('전체 세대수', '235세대'),
      _buildInfoTableRow('평형', '32평, 18평'),
    ]);
  }

  Widget _buildInfoTableRow(String label, String value) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(children: [
          SizedBox(width: 85, child: Text(label, style: _infoLabelStyle)),
          Expanded(child: Text(value, style: _infoValueStyle)),
        ])
    );
  }

  Widget _buildKeywordsTab() {
    final keywords = ["#강서구", "#신축", "#학군우수", "#대단지", "#역세권", "#공세권"];
    return _buildSectionContainer(title: "단지 주요 키워드", content: Wrap(spacing: 8.0, runSpacing: 8.0, children: keywords.map((kw) => Chip(label: Text(kw))).toList()));
  }

  Widget _buildPriceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildSectionContainer(title: "실거래가 내역", content: _buildTransactionTable()),
          _buildSectionContainer(title: "실거래가 변화", content: _buildSalesPriceTrendChart("실거래가")),
        ],
      ),
    );
  }

  Widget _buildTransactionTable() {
    final data = [TransactionData('2023-12-30', '32평', '21억', '11층'), TransactionData('2023-11-15', '32평', '20.5억', '8층')];
    return Column(children: [
      // Table Header
      Container(color: Colors.grey[100], padding: const EdgeInsets.all(8), child: Row(children: const [Expanded(child: Text('계약일자')), Expanded(child: Text('평형')), Expanded(child: Text('거래금액')), Expanded(child: Text('층'))])),
      // Table Body
      ...data.map((item) => Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Expanded(child: Text(item.date)), Expanded(child: Text(item.area)), Expanded(child: Text(item.price)), Expanded(child: Text(item.floor))])))
    ]);
  }

  Widget _buildSalesPriceTrendChart(String priceType) {
    // ... fl_chart 구현 ...
    return Container(height: 250, color: Colors.grey[200], child: Center(child: Text('$priceType 추이 차트')));
  }

  Widget _buildFloorTab() {
    return _buildSectionContainer(title: "층별 정보", content: Container(height: 250, color: Colors.grey[200], child: const Center(child: Text('층별 거래량/가격 차트'))));
  }
  Widget _buildAreaTypeTab() {
    return _buildSectionContainer(title: "평형별 정보", content: Container(height: 250, color: Colors.grey[200], child: const Center(child: Text('평형별 정보 테이블'))));
  }
  Widget _buildPredictionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildSectionContainer(title: "AI 매매가 예측", content: _buildSalesPriceTrendChart("매매가 예측")),
          _buildSectionContainer(title: "AI 전세가 예측", content: _buildSalesPriceTrendChart("전세가 예측")),
        ],
      ),
    );
  }

  Widget _buildInfrastructureContent() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _infraTabs.asMap().entries.map((entry) {
        bool isActive = _activeInfraTabIndex == entry.key;
        return Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: TextButton(onPressed: () => setState(() => _activeInfraTabIndex = entry.key), style: TextButton.styleFrom(backgroundColor: isActive ? Theme.of(context).primaryColor : Colors.grey[200], foregroundColor: isActive ? Colors.white : Colors.black), child: Text(entry.value))));
      }).toList()),
      const SizedBox(height: 15),
      Container(height: 230, decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)), child: Center(child: Text('${_infraTabs[_activeInfraTabIndex]} 지도')))
    ]);
  }
}

// SliverPersistentHeader를 위한 Delegate 클래스
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).scaffoldBackgroundColor, child: _tabBar);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}


// --- Screen 5: Apartment List Screen (from Iphone13Mini5.dart) ---

class ApartmentListScreen extends StatefulWidget {
  const ApartmentListScreen({super.key});

  @override
  State<ApartmentListScreen> createState() => _ApartmentListScreenState();
}

class _ApartmentListScreenState extends State<ApartmentListScreen> {
  RangeValues _currentRangeValues = const RangeValues(2012, 2018);
  final List<ApartmentInfo> apartmentData = List.generate(10, (index) => ApartmentInfo(id: (index + 1).toString(), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '8억 4770', transport: '58개(56.0점)'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('아파트 데이터')),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _buildFilterDropdown('시/도')),
                    Expanded(child: _buildFilterDropdown('구/시')),
                    Expanded(child: _buildFilterDropdown('평형')),
                  ]),
                  const SizedBox(height: 20),
                  _buildYearSlider(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apartmentData.length,
                itemBuilder: (context, index) => _buildApartmentListItem(item: apartmentData[index]),
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextButton(onPressed: () {}, child: const Text('더보기', style: TextStyle(color: Colors.grey)))
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(children: [
      const Expanded(child: TextField(decoration: InputDecoration(hintText: '아파트명을 입력하세요.', prefixIcon: Icon(Icons.search), border: InputBorder.none, filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.zero))),
      const SizedBox(width: 8),
      ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0C493C)), child: const Text('검색', style: TextStyle(color: Colors.white))),
    ]);
  }

  Widget _buildFilterDropdown(String hint) {
    return Container(height: 38, margin: const EdgeInsets.symmetric(horizontal: 4.0), padding: const EdgeInsets.symmetric(horizontal: 12.0), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(isExpanded: true, hint: Text(hint, style: const TextStyle(fontSize: 13)), icon: const Icon(Icons.keyboard_arrow_down), items: const [], onChanged: (_) {})));
  }

  Widget _buildYearSlider() {
    return Column(children: [
      RangeSlider(
        values: _currentRangeValues,
        min: 2006,
        max: 2024,
        divisions: 18,
        activeColor: const Color(0xFF0C493C),
        inactiveColor: Colors.white.withOpacity(0.5),
        labels: RangeLabels('${_currentRangeValues.start.round()}년', '${_currentRangeValues.end.round()}년'),
        onChanged: (values) => setState(() => _currentRangeValues = values),
      ),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('06년'), Text('24년')]))
    ]);
  }

  Widget _buildApartmentListItem({required ApartmentInfo item}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/property_detail'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.id, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 10),
          Icon(item.trendIcon, color: item.trendIconColor, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 5), Row(children: [
            _buildDetailColumn('전용면적', item.area),
            _buildDetailColumn('거래금액', item.price),
            _buildDetailColumn('교통', item.transport)
          ])])),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ]),
      ),
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Expanded(child: Text('$title: $value', style: const TextStyle(color: Color(0xFF14B997), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis));
  }
}
