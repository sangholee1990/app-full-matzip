import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

// Data model for apartment list items
class ApartmentInfo {
  final String id;
  final String name;
  final String area;
  final String price;
  final String transport;
  final IconData trendIcon; // Added for consistency with potential future use
  final Color trendIconColor; // Added for consistency

  ApartmentInfo({
    required this.id,
    required this.name,
    required this.area,
    required this.price,
    required this.transport,
    this.trendIcon = Icons.arrow_upward, // Default trend icon
    this.trendIconColor = const Color(0xFF14B997), // Default trend icon color
  });
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF7F8FA), // Adjusted to a lighter common background
        primaryColor: const Color(0xFF14B997),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF14B997), // Explicitly set AppBar background
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Pretendard Variable'), // Consistent font
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle.light, // Light status bar icons
        ),
        // Define text theme if 'Pretendard Variable' is used globally
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Pretendard Variable', color: Colors.black87),
          labelLarge: TextStyle(fontFamily: 'Pretendard Variable'), // For button text
        ),
      ),
      home: const ApartmentDataScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ApartmentDataScreen extends StatefulWidget {
  const ApartmentDataScreen({super.key});

  @override
  State<ApartmentDataScreen> createState() => _ApartmentDataScreenState();
}

class _ApartmentDataScreenState extends State<ApartmentDataScreen> {
  int _selectedIndex = 1; // "아파트" is the selected tab
  RangeValues _currentRangeValues = const RangeValues(2012, 2018); // Initial year range

  final List<ApartmentInfo> apartmentData = List.generate(
    5,
        (index) => ApartmentInfo(
      id: (index + 1).toString(),
      name: '양천벽산블루밀2단지(월정로9길 20)',
      area: '84.77',
      price: '8억 4770', // Example of formatted price
      transport: '58개(56.0점)',
    ),
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensures status bar icons are light, matching the AppBar theme
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // Already handled by AppBarTheme

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 130, // Adjusted width for logo and back button
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20), // Slightly smaller back icon
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(width: 0), // Adjust spacing if needed
            const Icon(Icons.domain, color: Colors.white, size: 22), // Building icon for MATZIP
            const SizedBox(width: 6),
            const Text(
              "MATZIP",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17, // Adjusted size
                  fontFamily: 'Pretendard Variable'
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: const Text('아파트 데이터'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () { /* Handle notification icon press */ },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () { /* Handle profile icon press */ },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF14B997),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0), // Adjusted padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8), // Slightly less rounded
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: '아파트명을 입력하세요.',
                              hintStyle: TextStyle(color: Color(0xFF878787), fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Pretendard Variable'),
                              prefixIcon: Icon(Icons.search, color: Color(0xFF878787), size: 22),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
                            ),
                            style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Pretendard Variable'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C493C), // Darker teal from previous example
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(55, 40),
                        ),
                        child: const Text(
                          '검색',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Pretendard Variable'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFilterDropdown('시/도', flex: 2), // Adjusted flex for better spacing
                      _buildFilterDropdown('구/시', flex: 2),
                      _buildFilterDropdown('평형', flex: 2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildYearSlider(),
                  const SizedBox(height: 10), // Space before the white card transition
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF14B997), // Ensure teal color continues for smooth transition
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20), // Slightly more rounded
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [ // Optional: subtle shadow
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8), // Padding inside the white card
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: apartmentData.length,
                      itemBuilder: (context, index) {
                        final item = apartmentData[index];
                        return _buildApartmentListItem(item: item);
                      },
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                        color: Color(0xFFEAEAEA), // Lighter divider
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: TextButton(
                        onPressed: () { /* Handle "더보기" */ },
                        child: const Text(
                          '더보기',
                          style: TextStyle(
                            color: Color(0xFF878787),
                            fontSize: 14,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w500, // Slightly bolder
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF14B997),
        unselectedItemColor: const Color(0xFF878787),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Pretendard Variable', fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Pretendard Variable', fontSize: 11),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.apartment_outlined), activeIcon: Icon(Icons.apartment), label: '아파트'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), activeIcon: Icon(Icons.location_on), label: '로컬'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'AI추천'), // Changed to bar_chart
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: '서비스'),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String hint, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 38, // Slightly taller
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              hint,
              style: const TextStyle(color: Color(0xFF878787), fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Pretendard Variable'), // Adjusted font
              overflow: TextOverflow.ellipsis,
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF878787), size: 20),
            items: <String>['옵션1', '옵션2', '옵션3']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Pretendard Variable')),
              );
            }).toList(),
            onChanged: (_) { /* Handle dropdown change */ },
          ),
        ),
      ),
    );
  }

  Widget _buildYearSlider() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding for the slider
          child: RangeSlider(
            values: _currentRangeValues,
            min: 2006,
            max: 2024,
            divisions: (2024 - 2006), // One division per year
            activeColor: const Color(0xFF0C493C), // Darker teal for active part
            inactiveColor: Colors.white.withOpacity(0.5), // Lighter track color
            labels: RangeLabels(
              _currentRangeValues.start.round().toString() + '년',
              _currentRangeValues.end.round().toString() + '년',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
        ),
        // const SizedBox(height: 0), // Removed SizedBox as RangeSlider has some intrinsic padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjusted padding for year labels
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['06년', '09년', '12년', '15년', '18년', '21년', '24년']
                .map((year) => Text(
              year,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Pretendard Variable', fontWeight: FontWeight.w500), // Slightly smaller
            ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildApartmentListItem({required ApartmentInfo item}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Increased vertical padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          Text(
            item.id,
            style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Pretendard Variable'),
          ),
          const SizedBox(width: 10),
          Icon(item.trendIcon, color: item.trendIconColor, size: 18), // Using item's trend icon
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(color: Colors.black87, fontSize: 14.5, fontWeight: FontWeight.w600, fontFamily: 'Pretendard Variable', height: 1.3), // Slightly larger, adjusted line height
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align detail items' baseline
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
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 22), // Slightly larger chevron
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF14B997), fontSize: 10.5, fontWeight: FontWeight.w500, height: 1.4, fontFamily: 'Pretendard Variable'), // Adjusted size
        ),
        Text(
          value,
          style: const TextStyle(color: Color(0xFF14B997), fontSize: 10.5, fontWeight: FontWeight.w500, height: 1.4, fontFamily: 'Pretendard Variable'), // Adjusted size
        ),
      ],
    );
  }
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