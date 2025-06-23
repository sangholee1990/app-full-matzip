import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';

// [수정] 데이터 모델에 isSelected 추가
class PropertyItem {
  final String rank;
  final String name;
  final String region;
  final String area;
  final String price;
  final String similarity; // 유사도
  final List<String> tags;
  bool isSelected; // 선택 여부

  PropertyItem({
    required this.rank,
    required this.name,
    required this.region,
    required this.area,
    required this.price,
    required this.similarity,
    required this.tags,
    this.isSelected = false,
  });
}

class AiRecommendationScreen extends StatefulWidget {
  const AiRecommendationScreen({super.key});

  @override
  State<AiRecommendationScreen> createState() => _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends State<AiRecommendationScreen> {
  // 상태 변수 정의
  String _selectedGender = '남자';
  String _selectedAge = '20대';
  String _selectedArea = '30평대';
  final List<String> _genders = ['남자', '여자'];
  final List<String> _ages = ['10대', '20대', '30대', '40대', '50대+'];
  final List<String> _areas = ['10평대', '20평대', '30평대', '40평대', '50평대+'];

  // [수정] 새로운 데이터 모델에 맞게 리스트 업데이트
  final List<PropertyItem> _propertyItems = [
    PropertyItem(rank: '1', name: '양천벽산블루밀2단지(월정로9길 20)', region: '경기도 양천', area: '84.77', price: '450,000,000원', similarity: '58개(56.0점)', tags: ['교육', '교통', '주거환경', '편의시설'], isSelected: true),
    PropertyItem(rank: '2', name: '래미안 신반포 팰리스', region: '서울시 서초구', area: '112.5', price: '3,200,000,000원', similarity: '55개(54.5점)', tags: ['교육', '주거환경']),
    PropertyItem(rank: '3', name: '아크로 리버파크', region: '서울시 서초구', area: '84.9', price: '3,800,000,000원', similarity: '52개(51.0점)', tags: ['교육', '교통'], isSelected: true),
    PropertyItem(rank: '4', name: '은마아파트', region: '서울시 강남구', area: '76.79', price: '2,400,000,000원', similarity: '50개(49.0점)', tags: ['교육']),
  ];

  // 선택된 아이템 개수 계산
  int get _selectedItemCount => _propertyItems.where((p) => p.isSelected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildCustomAppBar(context),
      body: Column(
        children: [
          _buildFilterSection(),
          const SizedBox(height: 10),
          Expanded(child: _buildApartmentListSection()),
        ],
      ),
      bottomNavigationBar: _buildBottomActionSection(),
    );
  }

  // 커스텀 AppBar 위젯
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: const Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/svg/logo_matzip_color.svg', width: 92),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.notifications_none, color: Colors.grey), onPressed: () {}),
              IconButton(icon: const Icon(Icons.person_outline, color: Colors.grey), onPressed: () {}),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.maybePop(context)),
              const Text('AI 매물 추천', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // 매물 추천 조건 필터 섹션
  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('매물 추천 조건', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildDropdown(_genders, _selectedGender, (val) => setState(() => _selectedGender = val!))),
              const SizedBox(width: 10),
              Expanded(child: _buildDropdown(_ages, _selectedAge, (val) => setState(() => _selectedAge = val!))),
              const SizedBox(width: 10),
              Expanded(child: _buildDropdown(_areas, _selectedArea, (val) => setState(() => _selectedArea = val!))),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextField('보유현금', '원'),
          const SizedBox(height: 10),
          _buildTextField('대출이율', '%'),
          const SizedBox(height: 10),
          _buildTextField('자동계산', '원'),
        ],
      ),
    );
  }

  // 드롭다운 버튼 위젯
  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF14B997))),
        fillColor: const Color(0xFFF7F8FA),
        filled: true,
      ),
    );
  }

  // 텍스트 필드 위젯
  Widget _buildTextField(String label, String suffix) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF14B997))),
        fillColor: const Color(0xFFF7F8FA),
        filled: true,
      ),
    );
  }

  // 아파트 리스트 섹션
  Widget _buildApartmentListSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('아파트 리스트', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('최소 3개 이상 최대 5개까지 선택 ($_selectedItemCount/5)', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: _propertyItems.length,
              itemBuilder: (context, index) => _buildListItem(_propertyItems[index]),
              separatorBuilder: (context, index) => const Divider(height: 1),
            ),
          ),
        ],
      ),
    );
  }

  // 아파트 리스트 아이템 위젯
  Widget _buildListItem(PropertyItem item) {
    return InkWell(
      onTap: () => setState(() => item.isSelected = !item.isSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Checkbox(value: item.isSelected, onChanged: (bool? value) => setState(() => item.isSelected = value ?? false), activeColor: const Color(0xFF14B997)),
            Text(item.rank, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${item.region} · 전용 ${item.area}㎡', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('평균거래금액 ${item.price}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('유사도 ${item.similarity}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6.0,
                    runSpacing: 4.0,
                    children: item.tags.map((tag) => Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 11, color: Color(0xFF14B997))),
                      backgroundColor: const Color(0xFF14B997).withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  )
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // 하단 액션 버튼 + 네비게이션 바 섹션
  Widget _buildBottomActionSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ElevatedButton(
            onPressed: (_selectedItemCount >= 3 && _selectedItemCount <= 5) ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14B997),
              disabledBackgroundColor: Colors.grey.shade300,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('추천받기', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const CommonBottomNavBar(currentIndex: 3),
      ],
    );
  }
}