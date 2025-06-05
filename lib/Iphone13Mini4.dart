import 'package:flutter/material.dart';
import 'dart:math' as math; // For rotateZ
import 'package:fl_chart/fl_chart.dart'; // fl_chart 패키지 임포트

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color(0xFFF7F8FA),
          primaryColor: const Color(0xFF14B997),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF14B997),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          )
      ),
      home: const Scaffold(
        body: Iphone13Mini4(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Iphone13Mini4 extends StatefulWidget {
  const Iphone13Mini4({super.key});

  @override
  State<Iphone13Mini4> createState() => _Iphone13Mini4State();
}

class _Iphone13Mini4State extends State<Iphone13Mini4> with SingleTickerProviderStateMixin {
  int _activeBottomNavIndex = 3;
  int _activeInfraTabIndex = 0;
  bool _isFavorite = false;

  late TabController _tabController;

  final double _headerContentHeight = 95.0;

  static const TextStyle _headerTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.50,
  );

  static const TextStyle _logoTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Pretendard Variable'
  );

  static const TextStyle _darkGreenTextS13 = TextStyle(
    color: Color(0xFF0C342C),
    fontSize: 13,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _darkGreenBoldTextS18 = TextStyle(
    color: Color(0xFF0C342C),
    fontSize: 18,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
    height: 1.28,
  );

  static const TextStyle _blackTextS16W400 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.04,
  );
  static const TextStyle _propertyNameStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.04,
  );

  static const TextStyle _tabTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.04,
  );

  static const TextStyle _infoLabelStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.04,
  );

  static const TextStyle _infoValueStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.04,
  );

  static const TextStyle _chartAxisLabelStyle = TextStyle(
    color: Color(0xFF878787),
    fontSize: 10,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.03,
  );

  static const TextStyle _chartLegendTextStyle = TextStyle(
    color: Color(0xFF878787),
    fontSize: 12,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.03,
  );
  static const TextStyle _predictionValueStyle = TextStyle(
    color: Color(0xFF14B997),
    fontSize: 11,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.03,
  );


  static const TextStyle _bottomNavLabelStyle = TextStyle(
    color: Color(0xFF878787),
    fontSize: 11,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.03,
  );

  static const TextStyle _sectionTitleStyle = TextStyle(
    color: Color(0xFF222222),
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Pretendard',
  );

  final List<String> _tabs = ['소개', '키워드', '실거래가', '층별', '평형별', '매매가 예측'];
  final List<String> _infraTabs = ['교육', '교통', '주거환경', '편의시설'];
  final List<Map<String, dynamic>> _bottomNavItems = [
    {'icon': Icons.home_outlined, 'label': '홈'},
    {'icon': Icons.apartment_outlined, 'label': '아파트'},
    {'icon': Icons.map_outlined, 'label': '로컬'},
    {'icon': Icons.lightbulb_outline, 'label': 'AI추천'},
    {'icon': Icons.apps_outlined, 'label': '서비스'},
  ];

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

  Widget _buildTabContent(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    switch (index) {
      case 0: // 소개
        return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildDetailedInfoTable(context)
        );
      case 1: // 키워드
        return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildSectionContainer(context, screenWidth, title: "단지 주요 키워드", content: _buildKeywordsContent(context))
        );
      case 2: // 실거래가
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSectionContainer(context, screenWidth, title: "양천벽산블루밀2단지 실거래가 내역", content: _buildRealTransactionTabContent(context)),
              _buildSectionContainer(context, screenWidth, title: "양천벽산블루밀2단지 실거래가 변화", content: RepaintBoundary(child: _buildSalesPriceTrendChart(context, "실거래가"))),
              _buildSectionContainer(context, screenWidth, title: "양천벽산블루밀2단지 거래량 변화", content: _buildPlaceholderChart(context, "거래량 변화", "volume_change_chart.png", isBarChart: true)),
            ],
          ),
        );
      case 3: // 층별
        return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child:_buildFloorSpecificTabContent(context));
      case 4: // 평형별
        return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child:_buildSectionContainer(context, screenWidth, title: "양천벽산블루밀2단지 평형별 정보", content: _buildAreaTypeTabContent(context)));
      case 5: // 매매가 예측
        return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildPricePredictionTabContent(context));
      default:
        return const Center(child: Text("선택된 탭 콘텐츠 없음"));
    }
  }

  Widget _buildKeywordsContent(BuildContext context) {
    final keywords = ["#강서구", "#신축", "#학군우수", "#대단지", "#역세권", "#공세권", "#개발호재", "#조용한", "#리모델링"];
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: keywords.map((keyword) => Chip(
        label: Text(keyword, style: const TextStyle(color: Color(0xFF0C342C))),
        backgroundColor: const Color(0xFFB2DED5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide.none,
        ),
      )).toList(),
    );
  }

  Widget _buildRealTransactionTabContent(BuildContext context) {
    return _buildTransactionTable(context, "실거래가", [
      TransactionData('2023-12-30', '32평', '21억', '11층'),
      TransactionData('2023-11-15', '32평', '20.5억', '8층'),
      TransactionData('2023-10-01', '18평', '15억', '5층'),
    ]);
  }

  Widget _buildFloorSpecificTabContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        _buildSectionContainer(context, screenWidth, title: "양천벽산블루밀2단지 층별 거래량", content: _buildFloorVolumeChart(context)),
        const SizedBox(height: 20),
        _buildSectionContainer(context, screenWidth, title: "양천벽산블루밀2단지 층별 실거래가", content: _buildPlaceholderChart(context, "층별 실거래가", "floor_price_barchart.png", isBarChart: true)),
      ],
    );
  }


  Widget _buildAreaTypeTabContent(BuildContext context) {
    return _buildAreaTypeTransactionTable(context);
  }

  Widget _buildPricePredictionTabContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        _buildSectionContainer(context, screenWidth, title: "AI 매매가 예측", content: _buildAIPredictionSection(context, screenWidth, "매매가")),
        _buildSectionContainer(context, screenWidth, title: "AI 전세가 예측", content: _buildAIPredictionSection(context, screenWidth, "전세가")),
        _buildSectionContainer(context, screenWidth, title: "양천벽산블루밀2단지 갭 변화율", content: _buildGapChangeTable(context)),
      ],
    );
  }

  Widget _buildAIPredictionSection(BuildContext context, double screenWidth, String priceType) {
    String propertyName = "양천벽산블루밀2단지";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$propertyName $priceType", style: _blackTextS16W400.copyWith(fontWeight: FontWeight.w600, fontSize: 17)),
        const SizedBox(height: 10),
        _buildTransactionTable(context, priceType, [
          TransactionData('2023-12-30', '32평', priceType == "매매가" ? '21억' : '10억', '11층'),
          TransactionData('2023-12-30', '32평', priceType == "매매가" ? '21억' : '10억', '11층'),
        ]),
        const SizedBox(height: 20),
        Text("$propertyName $priceType 추이", style: _blackTextS16W400.copyWith(fontWeight: FontWeight.w600, fontSize: 17)),
        const SizedBox(height: 10),
        RepaintBoundary(child: _buildSalesPriceTrendChart(context, priceType)),
        const SizedBox(height: 15),
        _buildChartLegend(context, priceType),
      ],
    );
  }

  Widget _buildChartLegend(BuildContext context, String priceType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(width: 25, height: 10, color: const Color(0xFFB2DED5)),
            const SizedBox(width: 5),
            Text(priceType, style: _chartLegendTextStyle),
            const SizedBox(width: 15),
            Container(width: 25, height: 3, color: const Color(0xFF7E53DB)),
            const SizedBox(width: 5),
            Text('예측 딥러닝 $priceType', style: _chartLegendTextStyle),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(width: 25, height:3, color: const Color(0xFF14B997)),
            const SizedBox(width: 5),
            Text('예측 머신러닝 $priceType', style: _chartLegendTextStyle),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("2017년도", style: _infoValueStyle.copyWith(color:Colors.white, fontWeight: FontWeight.bold)),
              _buildPredictionRowForLegend("예측 딥러닝 $priceType", "1,564,251,354.17원"),
              _buildPredictionRowForLegend("예측 머신러닝 $priceType", "1,633,040,959.73원"),
              _buildPredictionRowForLegend(priceType, "1,562,833,333.33원", isHistorical: true),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPredictionRowForLegend(String label, String value, {bool isHistorical = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _infoValueStyle.copyWith(color: Colors.white.withOpacity(0.85), fontSize: 11)),
          Text(value, style: _infoValueStyle.copyWith(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
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
          _buildCustomHeader(context, statusBarHeight, _headerContentHeight, totalHeaderVisualHeight),
          Positioned(
            top: totalHeaderVisualHeight - 20,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildTopContentCard(context, screenWidth),
                _buildSectionContainer(
                  context,
                  screenWidth,
                  title: "양천벽산블루밀2단지 주변 인프라",
                  content: _buildInfrastructureContent(context),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavBar(context, screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, double statusBarHeight, double headerContentHeight, double totalHeaderVisualHeight) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: totalHeaderVisualHeight,
          child: Container(color: const Color(0xFF14B997)),
        ),
        Positioned(
          left: 0,
          top: statusBarHeight,
          right: 0,
          height: headerContentHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: 0,
                  top: 12,
                  child: Row(
                    children: const [
                      Icon(Icons.maps_home_work_outlined, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text("MATZIP", style: _logoTextStyle),
                    ],
                  ),
                ),
                Positioned(
                    right: 40,
                    top: 12,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 26),
                      onPressed: () { /* Notification action */ },
                    )
                ),
                Positioned(
                    right: 0,
                    top: 12,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.person_outline, color: Colors.white, size: 26),
                      onPressed: () { /* Profile action */ },
                    )
                ),
                Positioned(
                    left: -8,
                    top: 12 + 35,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    )
                ),
                Positioned(
                  left: 30,
                  top: 12 + 35 + 2,
                  right: 0,
                  child: Text(
                    'AI 매물 추천 미리보기',
                    style: _headerTitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTopContentCard(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Color(0x19000000), blurRadius: 8, offset: Offset(0, 4), spreadRadius: 2)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('교육을 중시하는', style: _darkGreenTextS13),
                const Text('3040 부부에게 맞는 집', style: _darkGreenBoldTextS18),
                const SizedBox(height: 15),
                const Divider(color: Color(0xFFEAEAEA), thickness: 1),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('양천벽산블루밀2단지', style: _propertyNameStyle),
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Color(0xFF757575), size: 16),
                    const SizedBox(width: 4),
                    const Flexible(
                      child: Text(
                        '서울시 양천구 월정로9길 20(신월동 1027)',
                        style: _infoValueStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  labelColor: const Color(0xFF14B997),
                  unselectedLabelColor: Colors.black,
                  labelStyle: _tabTextStyle,
                  indicatorColor: const Color(0xFF14B997),
                  indicatorWeight: 3.0,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1000,
            child: TabBarView(
              controller: _tabController,
              children: _tabs.asMap().entries.map((entry) {
                return _buildTabContent(entry.key);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInfoTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInfoTableRow(context, '도로명 주소', '서울시 양천구 월정로9길 20', bgColor: const Color(0xFFF7F8FA)),
          _buildInfoTableRow(context, '건축년도', '2006. 9. (준공일 / 19년차)'),
          _buildInfoTableRow(context, '전체 세대수', '235세대', bgColor: const Color(0xFFF7F8FA)),
          _buildInfoTableRow(context, '등기부등본\n/건축물대장', '등본/건축물대장 발급하기', isButton: true, showArrow: true),
          _buildInfoTableRow(context, '평형', '32평, 18평', bgColor: const Color(0xFFF7F8FA)),
          _buildInfoTableRow(context, '층 수', '지상 14층 (지하 3층)'),
          _buildInfoTableRow(context, '주차 대수', '총 1626대(자주식 1626대)', bgColor: const Color(0xFFF7F8FA), isLast: true),
        ],
      ),
    );
  }

  Widget _buildInfoTableRow(BuildContext context, String label, String value, {bool isButton = false, Color? bgColor, bool isLast = false, bool showArrow = false}) {
    Widget valueWidget;
    if (isButton) {
      valueWidget = TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
            alignment: Alignment.centerLeft,
          ),
          onPressed: () { /* TODO: Implement actual button navigation/action */ },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF14B997), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: _infoValueStyle.copyWith(color: const Color(0xFF14B997)),
                ),
                if (showArrow) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF14B997)),
                ]
              ],
            ),
          )
      );
    } else {
      valueWidget = Text(value, style: _infoValueStyle);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFEAEAEA), width: 1.0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Text(label, style: _infoLabelStyle, textAlign: TextAlign.left),
          ),
          const SizedBox(width: 10),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(BuildContext context, double screenWidth, {required String title, required Widget content}) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(top:10, bottom: 10, left:0, right:0),
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Color(0x19000000), blurRadius: 2, offset: Offset(0, 2), spreadRadius: 2),
          ],
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: _blackTextS16W400.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTable(BuildContext context, String type, List<TransactionData> data, {bool isAreaType = false}) {
    return Column(
      children: [
        _buildTransactionTableHeader(isAreaType),
        ...data.map((item) => _buildTransactionTableRow(item, isAreaType)).toList(),
      ],
    );
  }

  Widget _buildTransactionTableHeader(bool isAreaType) {
    return Container(
      color: const Color(0xFFF7F8FA),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 2, child: Text('계약일자', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text(isAreaType ? '평형' : '평형', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(isAreaType ? '거래금액' : '거래금액', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('층', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildTransactionTableRow(TransactionData item, bool isAreaType) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 2, child: Text(item.date, style: _infoValueStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text(item.area, style: _infoValueStyle, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(item.price, style: _infoValueStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text(item.floor, style: _infoValueStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildPlaceholderChart(BuildContext context, String chartTitle, String placeholderAsset, {bool isBarChart = false}) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage("https://placehold.co/600x400/EFEFEF/AAAAAA?text=${Uri.encodeComponent(chartTitle)}&font=montserrat"),
          fit: BoxFit.contain,
          onError: (exception, stackTrace) => Center(
            child: Text(
              "$chartTitle\n(차트 로딩 실패)",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalesPriceTrendChart(BuildContext context, String priceType) {
    final List<FlSpot> spots = [
      const FlSpot(2013, 8.5), const FlSpot(2014, 9.0), const FlSpot(2015, 8.8),
      const FlSpot(2016, 9.5), const FlSpot(2017, 10.5),const FlSpot(2018, 11.5),
      const FlSpot(2019, 11.0),const FlSpot(2020, 12.5),const FlSpot(2021, 15.0),
      const FlSpot(2022, 14.0),const FlSpot(2023, 13.5),const FlSpot(2024, 13.8),
    ];
    final List<FlSpot> predictionSpots1 = spots.map((e) => FlSpot(e.x, e.y * 1.05)).toList();
    final List<FlSpot> predictionSpots2 = spots.map((e) => FlSpot(e.x, e.y * 1.1)).toList();


    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 16, left: 6, top: 20, bottom: 10),
      child: LineChart(
        LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 2.5,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[300]!, strokeWidth: 0.5),
              getDrawingVerticalLine: (value) => FlLine(color: Colors.grey[300]!, strokeWidth: 0.5),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 2,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    String text = '';
                    switch (value.toInt()) {
                      case 2013: text = '‘13'; break; case 2015: text = '‘15'; break;
                      case 2017: text = '‘17'; break; case 2019: text = '‘19'; break;
                      case 2021: text = '‘21'; break; case 2023: text = '‘23'; break;
                      case 2024: text = '‘24'; break;
                    }
                    return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: _chartAxisLabelStyle));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  interval: 5,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    if (value % 5 == 0 && value >=0) {
                      return Text('${value.toInt()}억', style: _chartAxisLabelStyle, textAlign: TextAlign.left);
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey[400]!, width: 1)),
            minX: 2013, maxX: 2026,
            minY: 0, maxY: 25,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: const Color(0xFFB2DED5),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: predictionSpots1,
                isCurved: true,
                color: const Color(0xFF7E53DB),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: predictionSpots2,
                isCurved: true,
                color: const Color(0xFF14B997),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (LineBarSpot spot) => Colors.blueGrey.withOpacity(0.8),
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final flSpot = barSpot;
                      String title;
                      if (barSpot.barIndex == 0) title = '$priceType: ';
                      else if (barSpot.barIndex == 1) title = '딥러닝 예측: ';
                      else title = '머신러닝 예측: ';

                      return LineTooltipItem(
                        '${flSpot.x.toInt()}년\n$title${flSpot.y}억',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                    }).toList();
                  }
              ),
              handleBuiltInTouches: true,
            )
        ),
      ),
    );
  }
  Widget _buildFloorVolumeChart(BuildContext context) {
    final List<Tuple2<int, double>> floorVolumeData = [
      Tuple2(1, 22), Tuple2(2, 22), Tuple2(3, 24), Tuple2(4, 19), Tuple2(5, 19),
      Tuple2(6, 19), Tuple2(7, 21), Tuple2(8, 22), Tuple2(9, 17), Tuple2(10, 23),
      Tuple2(11, 22), Tuple2(12, 25), Tuple2(13, 15), Tuple2(14, 21), Tuple2(15, 27),
    ];

    return Container(
      height: 350,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: BarChart(
        BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 30,
            minY: 0,
            groupsSpace: 12,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              verticalInterval: 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[300]!,
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey[300]!,
                  strokeWidth: 0.5,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 5,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text('${value.toInt()}', style: _chartAxisLabelStyle),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    if (value >=1 && value <= 15) {
                      return Text('${value.toInt()}F', style: _chartAxisLabelStyle, textAlign: TextAlign.right);
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey[400]!, width: 1),
            ),
            barGroups: floorVolumeData.map((data) {
              final isHighlighted = data.item1 == 15;
              return BarChartGroupData(
                x: data.item1,
                barRods: [
                  BarChartRodData(
                    toY: data.item2,
                    color: isHighlighted ? const Color(0xFF14B997) : const Color(0xFFB2DED5),
                    width: 10,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              );
            }).toList(),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => Colors.black.withOpacity(0.8),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  if (group.x.toInt() == 15) {
                    return BarTooltipItem(
                      '2024년도\n15F 거래량 ${rod.toY.toInt()}건',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                    );
                  }
                  return null;
                },
              ),
            )
        ),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }


  Widget _buildAreaTypeTransactionTable(BuildContext context) {
    final data = [
      AreaTransactionData("32평", "160건", "10.9억"),
      AreaTransactionData("18평", "59건", "7.2억"),
    ];
    return Column(
      children: [
        Container(
          color: const Color(0xFFF7F8FA),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
          child: Row(
            children: [
              Expanded(child: Text('평형', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              Expanded(child: Text('거래량', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              Expanded(child: Text('거래금액', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
            ],
          ),
        ),
        ...data.map((item) => Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA))),
          ),
          child: Row(
            children: [
              Expanded(child: Text(item.area, style: _infoValueStyle, textAlign: TextAlign.center)),
              Expanded(child: Text(item.volume, style: _infoValueStyle, textAlign: TextAlign.center)),
              Expanded(child: Text(item.price, style: _infoValueStyle, textAlign: TextAlign.center)),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildAIPredictionCardContent(BuildContext context, double screenWidth, String priceType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPredictionRow("예측 딥러닝 ${priceType}", "1,564,251,354.17원"),
        _buildPredictionRow("예측 머신러닝 ${priceType}", "1,633,040,959.73원"),
        if(priceType == "매매가")
          _buildPredictionRow("2017년도 ${priceType}", "1,562,833,333.33원", isHistorical: true),
      ],
    );
  }

  Widget _buildPredictionRow(String label, String value, {bool isHistorical = false}) {
    final textColor = isHistorical ? Colors.grey[600] : const Color(0xFF14B997);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _infoLabelStyle.copyWith(color: textColor, fontWeight: FontWeight.w600, fontSize: 12)),
          Text(value, style: _infoValueStyle.copyWith(color: textColor, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildGapChangeTable(BuildContext context) {
    final data = [
      GapData("32평", "11.6억", "5.8억", "5,024만", "9.44"),
      GapData("18평", "8.5억", "4.9억", "9,792만", "12.11"),
    ];
    return Column(
      children: [
        Container(
          color: const Color(0xFFF7F8FA),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
          child: Row(
            children: [
              Expanded(flex:1, child: Text('평형', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              Expanded(flex:2, child: Text('매매가(현)', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              Expanded(flex:2, child: Text('갭(현)', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              Expanded(flex:2, child: Text('변화액(미)', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              Expanded(flex:2, child: Text('변화율(미)', style: _infoLabelStyle.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
            ],
          ),
        ),
        ...data.map((item) => Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA))),
          ),
          child: Row(
            children: [
              Expanded(flex:1, child: Text(item.area, style: _infoValueStyle, textAlign: TextAlign.center)),
              Expanded(flex:2, child: Text(item.salePrice, style: _infoValueStyle, textAlign: TextAlign.center)),
              Expanded(flex:2, child: Text(item.gapPrice, style: _infoValueStyle, textAlign: TextAlign.center)),
              Expanded(flex:2, child: Text(item.changeAmount, style: _infoValueStyle, textAlign: TextAlign.center)),
              Expanded(flex:2, child: Text(item.changeRate, style: _infoValueStyle, textAlign: TextAlign.center)),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildInfrastructureContent(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _infraTabs.asMap().entries.map((entry) {
            int idx = entry.key;
            String label = entry.value;
            bool isActive = _activeInfraTabIndex == idx;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: TextButton(
                  onPressed: () {
                    setState(() { _activeInfraTabIndex = idx; });
                    print("$label 탭 선택됨");
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isActive ? const Color(0xFF14B997) : const Color(0xFFF2F3F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal:8, vertical: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF878787),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
        Stack( // Use Stack to overlay buttons on the map
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage("https://placehold.co/335x230/EAEAEA/777777?text=${Uri.encodeComponent(_infraTabs[_activeInfraTabIndex])}+Map+Controls"),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => const Center(child: Icon(Icons.map_outlined, size: 50, color: Colors.grey)),
                ),
              ),
            ),
            // "추가 정보" 버튼 (좌측 상단)
            Positioned(
              top: 10,
              left: 10,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.filter_list, size: 16),
                label: const Text("추가 정보", style: TextStyle(fontSize: 12)),
                onPressed: () { /* TODO: 추가 정보 필터 기능 */ },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  textStyle: const TextStyle(fontSize: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                ),
              ),
            ),
            // "중개, 단지, 매물" 버튼 그룹 (우측)
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: ["중개", "단지", "매물"].map((text) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () { /* TODO: 버튼별 기능 */ },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: const Color(0xFF333333),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        minimumSize: const Size(60, 30), // Ensure buttons have some width
                        elevation: 2,
                      ),
                      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x26000000), blurRadius: 5, offset: Offset(0, -5), spreadRadius: -3),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _bottomNavItems.asMap().entries.map((entry) {
              int idx = entry.key;
              Map<String, dynamic> item = entry.value;
              return _buildBottomNavItem(
                context,
                item['icon'],
                item['label'],
                isActive: _activeBottomNavIndex == idx,
                onTap: () {
                  setState(() {
                    _activeBottomNavIndex = idx;
                  });
                  print("${item['label']} 선택됨");
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 5),
          Container(
            width: 130,
            height: 5,
            decoration: ShapeDecoration(
              color: const Color(0xFF878787),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(BuildContext context, IconData icon, String label, {required bool isActive, required VoidCallback onTap}) {
    final color = isActive ? const Color(0xFF14B997) : const Color(0xFF878787);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(label, style: _bottomNavLabelStyle.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

// --- Data Models ---
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

// Helper class for chart data, similar to FlSpot but for BarChart
class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;
  Tuple2(this.item1, this.item2);
}
