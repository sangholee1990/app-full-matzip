import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';

//================================================================================
// 6. Apartment Data Screen (Iphone13Mini5.dart 기반)
// 파일 경로: lib/screens/apartment_data_screen.dart
//================================================================================
class ApartmentInfo {
  final String id; final String name; final String area; final String price; final String transport; final IconData trendIcon; final Color trendIconColor;
  ApartmentInfo({required this.id, required this.name, required this.area, required this.price, required this.transport, this.trendIcon = Icons.arrow_upward, this.trendIconColor = const Color(0xFF14B997)});
}

class ApartmentDataScreen extends StatefulWidget {
  const ApartmentDataScreen({super.key});
  @override
  State<ApartmentDataScreen> createState() => _ApartmentDataScreenState();
}

class _ApartmentDataScreenState extends State<ApartmentDataScreen> {
  RangeValues _currentRangeValues = const RangeValues(2012, 2018);
  final List<ApartmentInfo> apartmentData = List.generate(5, (index) => ApartmentInfo(id: (index + 1).toString(), name: '양천벽산블루밀2단지(월정로9길 20)', area: '84.77', price: '8억 4770', transport: '58개(56.0점)'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
        title: const Text('아파트 데이터'),
        actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}), IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}), const SizedBox(width: 8)],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF14B997), padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Container(height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: const TextField(decoration: InputDecoration(hintText: '아파트명을 입력하세요.', hintStyle: TextStyle(color: Color(0xFF878787), fontSize: 14, fontWeight: FontWeight.w500), prefixIcon: Icon(Icons.search, color: Color(0xFF878787), size: 22), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0))))),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0C493C), padding: const EdgeInsets.symmetric(horizontal: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), minimumSize: const Size(55, 40)), child: const Text('검색', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildFilterDropdown('시/도', flex: 2), _buildFilterDropdown('구/시', flex: 2), _buildFilterDropdown('평형', flex: 2)]),
                  const SizedBox(height: 20),
                  _buildYearSlider(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFF14B997)),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
                child: Column(children: [
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: apartmentData.length,
                    itemBuilder: (context, index) => _buildApartmentListItem(item: apartmentData[index]),
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFEAEAEA)),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: TextButton(onPressed: () {}, child: const Text('더보기', style: TextStyle(color: Color(0xFF878787), fontSize: 14, fontWeight: FontWeight.w500)))),
                ]),
              ),
            ),
          ),
        ],
      ),
      // ** 공통 네비게이션 바 적용 **
      bottomNavigationBar: const CommonBottomNavigationBar(currentIndex: 1),
    );
  }

  // 위젯 빌더 함수들...
  Widget _buildFilterDropdown(String hint, {int flex = 1}) { return Expanded(flex: flex, child: Container(height: 38, margin: const EdgeInsets.symmetric(horizontal: 4.0), padding: const EdgeInsets.symmetric(horizontal: 12.0), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(isExpanded: true, hint: Text(hint, style: const TextStyle(color: Color(0xFF878787), fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis), icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF878787), size: 20), items: <String>['옵션1'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 13)))).toList(), onChanged: (_) {})))); }
  Widget _buildYearSlider() { return Column(children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: RangeSlider(values: _currentRangeValues, min: 2006, max: 2024, divisions: (2024 - 2006), activeColor: const Color(0xFF0C493C), inactiveColor: Colors.white.withOpacity(0.5), labels: RangeLabels('${_currentRangeValues.start.round()}년', '${_currentRangeValues.end.round()}년'), onChanged: (RangeValues values) => setState(() => _currentRangeValues = values))), Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ['06년', '09년', '12년', '15년', '18년', '21년', '24년'].map((year) => Text(year, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500))).toList()))]); }
  Widget _buildApartmentListItem({required ApartmentInfo item}) { return InkWell(onTap: () => Navigator.pushNamed(context, '/apartment-details'), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.id, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)), const SizedBox(width: 10), Icon(item.trendIcon, color: item.trendIconColor, size: 18), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(color: Colors.black87, fontSize: 14.5, fontWeight: FontWeight.w600, height: 1.3), overflow: TextOverflow.ellipsis), const SizedBox(height: 5), Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [_buildDetailColumn('전용면적', item.area, flex: 3), const SizedBox(width: 8), _buildDetailColumn('거래금액', item.price, flex: 3), const SizedBox(width: 8), _buildDetailColumn('교통', item.transport, flex: 4)])])), const SizedBox(width: 8), Icon(Icons.chevron_right, color: Colors.grey[400], size: 22)]))); }
  Widget _buildDetailColumn(String title, String value, {int flex = 1}) { return Expanded(flex: flex, child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [Text('$title: ', style: TextStyle(color: const Color(0xFF14B997).withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w500)), Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF14B997), fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 1))])); }
}