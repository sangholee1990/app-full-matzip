import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

// Data model for property list items
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

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        // Using light theme convention for background color, but you can adjust
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        // Ensure the primary color is set if other components rely on it
        primaryColor: const Color(0xFF14B997),
        // Define text theme if 'Pretendard Variable' is used globally
        // textTheme: TextTheme(
        //   bodyMedium: TextStyle(fontFamily: 'Pretendard Variable'),
        //   // ... other text styles
        // ),
      ),
      home: const AiRecommendationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AiRecommendationScreen extends StatefulWidget {
  const AiRecommendationScreen({super.key});

  @override
  State<AiRecommendationScreen> createState() => _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends State<AiRecommendationScreen> {
  int _currentBottomNavIndex = 3; // Default to 'AI추천'

  // Sample data for the list
  final List<PropertyItem> _propertyItems = [
    PropertyItem(rank: '1', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '2', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '3', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '4', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '5', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '6', trendIcon: Icons.arrow_downward, trendIconColor: Colors.indigo.shade300, name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
    PropertyItem(rank: '7', trendIcon: Icons.arrow_upward, trendIconColor: const Color(0xFF14B997), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '84.77', transport: '58개(56.0점)'),
  ];

  // Constants for layout
  static const double _headerHeight = 100.0;
  static const double _subscriptionButtonHeight = 45.0;
  static const double _paddingBetweenButtonAndList = 16.0; // Padding below the list, above the button
  static const double _paddingForSubscriptionButtonHorizontal = 20.0;
  static const double _bottomNavBarHeight = 56.0;


  // Builds a single list item for the property list
  Widget _buildListItemWidget(PropertyItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40, // Adjusted for potentially wider ranks or icons
            child: Row(
              children: [
                Text(item.rank, style: const TextStyle(color: Colors.black87, fontSize: 14, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w500)),
                const SizedBox(width: 5),
                Icon(item.trendIcon, color: item.trendIconColor, size: 18),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(color: Colors.black87, fontSize: 15, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // 항목들이 세로로 길어질 경우를 대비해 정렬
                  children: [
                    _buildDetailColumn('전용면적', item.area, flex: 3),
                    const SizedBox(width: 8),
                    _buildDetailColumn('거래금액', item.price, flex: 3),
                    const SizedBox(width: 8),
                    _buildDetailColumn('교통', item.transport, flex: 4),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }

  // Helper to build detail columns within a list item
  Widget _buildDetailColumn(String title, String value, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Row( // Column에서 Row로 변경
        crossAxisAlignment: CrossAxisAlignment.baseline, // 텍스트 기준선 정렬
        textBaseline: TextBaseline.alphabetic, // 텍스트 기준선 타입
        children: [
          Text(
            '$title: ', // 제목 뒤에 콜론과 공백 추가
            style: TextStyle(color: const Color(0xFF14B997).withOpacity(0.9), fontSize: 11, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w500),
          ),
          //SizedBox(width: 4), // 제목과 값 사이의 간격 제거 또는 조정
          Expanded( // 값이 길어질 경우를 대비해 Expanded 추가
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF14B997), fontSize: 12, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis, // 내용이 넘칠 경우 ... 처리
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Builds a single item for the bottom navigation bar
  Widget _buildBottomNavItemContent(IconData icon, String label, bool isSelected) {
    final color = isSelected ? const Color(0xFF14B997) : Colors.grey[600];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
    // Add navigation logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomSafeArea = MediaQuery.of(context).padding.bottom;

    // Total height occupied by the fixed header (green background part)
    final double totalHeaderVisualHeight = _headerHeight + statusBarHeight;
    // Total height occupied by the subscription button and its padding from the bottom of the screen content area
    final double totalSubscriptionButtonAreaHeight = _subscriptionButtonHeight + _paddingBetweenButtonAndList;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA), // Background for the entire screen
      body: Stack(
        children: [
          // Header Background
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: totalHeaderVisualHeight,
            child: Container(color: const Color(0xFF14B997)),
          ),

          // Header Content (Logo, Title, Icons)
          Positioned(
            left: 0,
            top: statusBarHeight, // Position below actual status bar
            right: 0,
            height: _headerHeight, // Height of the content area of the header
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack( // Use Stack for precise positioning of header elements
                alignment: Alignment.centerLeft, // Default alignment for children
                children: [
                  // Logo and App Name
                  Positioned(
                    left: 0,
                    top: 12, // Relative to the start of the content area
                    child: Row(
                      children: const [
                        Icon(Icons.business_center, color: Colors.white, size: 24), // Example logo icon
                        SizedBox(width: 8),
                        Text("MATZIP", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Pretendard Variable')),
                      ],
                    ),
                  ),
                  // Notification Icon
                  Positioned(
                    right: 35, // 20 (edge) + 26 (icon width) + 8 (spacing) approx
                    top: 12,
                    child: Icon(Icons.notifications_none, color: Colors.white, size: 26),
                  ),
                  // Profile Icon
                  Positioned(
                    right: 0,
                    top: 12,
                    child: Icon(Icons.person_outline, color: Colors.white, size: 26),
                  ),
                  // Sub-Header: Back Arrow
                  Positioned(
                    left: -4, // To align icon edge with padding
                    top: 12 + 40, // Below logo row
                    child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  // Sub-Header: Title
                  Positioned(
                    left: 30, // After back arrow
                    top: 12 + 41, // Align with back arrow
                    right: 0, // Allow text to take available space
                    child: Text(
                      'AI 매물 추천 미리보기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.50,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Property List Card
          Positioned(
            top: totalHeaderVisualHeight,
            left: 0,
            right: 0,
            // The bottom of this card is above the subscription button area
            bottom: totalSubscriptionButtonAreaHeight + _bottomNavBarHeight + bottomSafeArea,
            child: Container(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              child: SingleChildScrollView( // Make the list scrollable
                child: Column(
                  children: [
                    const SizedBox(height: 20), // Initial padding for the list
                    ..._propertyItems.expand((item) => [
                      _buildListItemWidget(item),
                      Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey[200]),
                    ]).toList()..removeLast(), // Remove last divider
                    const SizedBox(height: 10), // Padding at the end of the list
                  ],
                ),
              ),
            ),
          ),

          // Subscription Button
          Positioned(
            left: _paddingForSubscriptionButtonHorizontal,
            right: _paddingForSubscriptionButtonHorizontal,
            // Positioned above the bottom navigation bar
            bottom: _bottomNavBarHeight + bottomSafeArea + _paddingBetweenButtonAndList,
            height: _subscriptionButtonHeight,
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white, // Button background
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFF14B997).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  '구독하고 나에게 꼭 맞는 매물 추천 보기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF0C493C),
                    fontSize: 15,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.04,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: _bottomNavBarHeight + bottomSafeArea,
        padding: EdgeInsets.only(bottom: bottomSafeArea, top:0), // only apply safe area to bottom
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
        ),
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
}
