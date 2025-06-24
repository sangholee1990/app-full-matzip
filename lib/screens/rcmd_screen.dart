import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_full_matzip/utils/common_bottom_nav_bar.dart';
import 'package:app_full_matzip/services/api_service.dart';
import 'package:intl/intl.dart';

class RcmdScreen extends StatefulWidget {
  const RcmdScreen({super.key});

  @override
  State<RcmdScreen> createState() => _RcmdScreenState();
}

class _RcmdScreenState extends State<RcmdScreen> {
  final MatzipApiService _apiService = MatzipApiService();

  // 컨트롤러
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _debtRatController = TextEditingController();

  // 필터 상태 변수
  String _selectedGender = '남자';
  String _selectedAge = '전체';
  String _selectedArea = '전체';
  final List<String> _genders = ['남자', '여자'];
  final List<String> _ages = ['전체', '10대', '20대', '30대', '40대', '50대+'];
  final List<String> _areas = ['전체', '9평', '18평', '24평', '32평', '43평+'];

  // 지역 및 아파트 선택 드롭다운 상태
  List<Map<String, dynamic>> _allRegionData = [];
  List<String> _sidoList = [];
  List<String> _gusiList = [];
  String? _selectedSido;
  String? _selectedGusi;
  List<String> _apartmentDropdownList = [];
  String? _selectedApartmentInDropdown;

  // 데이터 로딩 및 추천 관련 상태
  // bool _isInitialLoading = true;
  bool _isListLoading = true;
  bool _isRecommending = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _fetchedProperties = []; // 아파트 목록 데이터는 드롭다운 채우기 위해 유지

  // 추천목록 상태
  bool _showRecommendations = false;
  List<Map<String, dynamic>> _recommendedList = [];

  // [삭제] 아파트 선택 개수 관련 변수 제거
  // int get _selectedItemCount => ...;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _debtRatController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message) {
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

  // --- 데이터 변환 헬퍼 함수 (이전과 동일) ---
  String _getGenderParam() => _selectedGender == '남자' ? '1' : '2';

  String _getAgeParam() {
    switch (_selectedAge) {
      case '전체': return '20-99';
      case '10대': return '10-19';
      case '20대': return '20-29';
      case '30대': return '30-39';
      case '40대': return '40-49';
      case '50대+': return '50-99';
      default: return '20-39';
    }
  }

  String _getAreaParam() {
    const double pyeongToM2 = 3.3058;
    const String maxArea = '500';

    int pyeongToM2Round(int pyeong) {
      return (pyeong * pyeongToM2).round();
    }

    switch (_selectedArea) {
      case '전체': return '0-$maxArea';
      case '9평': return '0-${pyeongToM2Round(9)}';
      case '18평': return '${pyeongToM2Round(9)}-${pyeongToM2Round(18)}';
      case '24평': return '${pyeongToM2Round(18)}-${pyeongToM2Round(24)}';
      case '32평': return '${pyeongToM2Round(24)}-${pyeongToM2Round(32)}';
      case '43평+': return '${pyeongToM2Round(32)}-$maxArea';
      default: return '';
    }
  }

  // --- 데이터 로딩 함수들 ---
  Future<void> _loadInitialData() async {
    // [삭제] _isInitialLoading 상태 변경 로직 제거
    setState(() {
      _errorMessage = null;
    });
    try {
      final regions = await _fetchAllRegions();
      if (!mounted) return;

      // setState 내부에서 데이터 할당 및 UI 갱신
      setState(() {
        _allRegionData = regions;
        _initializeRegionFilters();
      });

      if (_selectedSido != null && _selectedGusi != null) {
        await _fetchApartmentData();
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    }
    // [삭제] _isInitialLoading 상태 변경 로직 제거
  }


  Future<List<Map<String, dynamic>>> _fetchAllRegions() async {
    final response = await _apiService.fetchData(
      apiUrl: '/api/sel-statRealSearchBySgg',
      apiParam: {'limit': 999, 'sgg': '서울특별시', 'page': 1, 'sort': 'cnt|desc'},
    );
    if (response['status'] == 'succ' && response['data'] is List) {
      return (response['data'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('지역 정보를 불러오는 데 실패했습니다.');
    }
  }

  void _initializeRegionFilters() {
    if (_allRegionData.isEmpty) return;
    final sidoSet = _allRegionData.map((r) => (r['sgg'] as String?)?.split(' ')[0]).whereType<String>().toSet();
    _sidoList = sidoSet.toList()..sort();
    if (_sidoList.isNotEmpty) {
      _selectedSido = _sidoList.first;
      _updateGusiListForSido();
    }
  }

  void _updateGusiListForSido() {
    if (_selectedSido == null) return;
    _gusiList = _allRegionData
        .where((r) => (r['sgg'] as String?)?.startsWith(_selectedSido!) ?? false)
        .map((r) => (r['sgg'] as String).substring(_selectedSido!.length).trim())
        .where((g) => g.isNotEmpty).toSet().toList()..sort();
    _selectedGusi = _gusiList.isNotEmpty ? _gusiList.first : null;
  }

  Future<void> _fetchApartmentData() async {
    if (_selectedSido == null || _selectedGusi == null) return;
    setState(() => _isListLoading = true);
    try {
      final params = {
        'limit': 100, 'page': 1, 'sort': 'cnt|desc',
        'sgg': '${_selectedSido!} ${_selectedGusi!}'
      };
      final response = await _apiService.fetchData(
          apiUrl: '/api/sel-statRealMaxBySggApt', apiParam: params);
      if (mounted) {
        if (response['status'] == 'succ' && response['data'] is List) {
          final List<dynamic> data = response['data'];
          setState(() {
            // [수정] isSelected 프로퍼티 더 이상 필요 없음
            _fetchedProperties = data.cast<Map<String, dynamic>>();
            // _apartmentDropdownList = ['전체', ..._fetchedProperties.map((p) => p['apt'] as String).toSet()];
            // _selectedApartmentInDropdown = '전체';
            _apartmentDropdownList = [..._fetchedProperties.map((p) => p['apt'] as String).toSet()];
            _selectedApartmentInDropdown = _apartmentDropdownList[0];
          });
        } else {
          throw Exception(response['message'] ?? '아파트 데이터를 불러오는 데 실패했습니다.');
        }
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isListLoading = false);
    }
  }

  // [삭제] _filterApartmentListByDropdown 함수는 더 이상 필요 없음

  // [수정] 추천 받기 API 호출 로직 변경
  Future<void> _getRecommendations() async {
    // --- 1. 유효성 검사 (이전과 동일) ---
    if (_priceController.text.isEmpty) {
      _showSnackBar(context, '가격을 입력해주세요.');
      return;
    }

    if (_debtRatController.text.isEmpty) {
      _showSnackBar(context, '부채 비율을 입력해주세요.');
      return;
    }

    if (_selectedApartmentInDropdown == null || _selectedApartmentInDropdown == '전체') {
      _showSnackBar(context, '매물 기준 아파트를 선택해주세요.');
      return;
    }

    // --- 2. 요청 시작 및 상태 초기화 ---
    setState(() {
      _isRecommending = true; // 로딩 시작
      _errorMessage = null;   // 이전 에러 메시지 제거

      // [추가] 이전 추천 목록을 미리 지워서 더 나은 UX 제공
      _showRecommendations = false;
      _recommendedList = [];
    });

    try {
      // --- 3. API 요청 (이전과 동일) ---
      final apiParam = {
        'gender': _getGenderParam(),
        'age': _getAgeParam(),
        'area': _getAreaParam(),
        'price': _priceController.text,
        'debtRat': _debtRatController.text,
        'apt': _selectedApartmentInDropdown!,
        'cnt': '10',
      };

      // MatzipApiService의 fetchData2가 아닌 fetchData를 호출한다고 가정합니다.
      // 만약 서비스 클래스에 fetchData2가 있다면 그대로 사용하시면 됩니다.
      final response = await _apiService.fetchData2(
        apiUrl: '/api/sel-rcmd',
        apiParam: apiParam,
      );

      // --- 4. 성공 시 상태 업데이트 (이전과 동일) ---
      if (mounted) {
        if (response['status'] == 'succ' && response['data']['cf'] is List && (response['data']['cf'] as List).isNotEmpty) {
          setState(() {
            _recommendedList = List<Map<String, dynamic>>.from(response['data']['cf']);
            _showRecommendations = true;
          });
        } else {
          // API가 성공했지만 데이터가 없는 경우, 에러로 처리
          throw Exception('검색 결과가 없습니다.');
        }
      }
    } catch (e) {
      // --- 5. [수정] 에러 발생 시 처리 ---
      if (mounted) {
        // 사용자에게 고정된 메시지 표시
        _showSnackBar(context, '검색 결과가 없습니다.');
        // 상태를 초기화하여 화면에서 목록을 완전히 제거
        setState(() {
          _recommendedList = [];
          _showRecommendations = false;
          // 내부적으로 에러 로그를 남길 수 있습니다.
          print('Recommendation error: ${e.toString()}');
        });
      }
    } finally {
      // --- 6. 로딩 종료 (이전과 동일) ---
      if (mounted) {
        setState(() => _isRecommending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildCustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFilterSection(),
            // [수정] 아파트 리스트 섹션 대신 추천 버튼 섹션 호출
            _buildRecommendationButtonSection(),
            if (_isRecommending)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: CircularProgressIndicator(color: Colors.grey)),
              ),
            if (_showRecommendations && !_isRecommending)
              _buildRecommendationResultSection(),
          ],
        ),
      ),
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 3),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
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
        preferredSize: const Size.fromHeight(55.0),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('AI 매물 추천', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

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
              Expanded(child: _buildDropdown(_areas, _selectedArea, (val) => setState(() => _selectedArea = val!), hint: '면적(평)')),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _priceController,
            label: '가격 억원 (예: 0-100)',
            suffix: '억원',
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _debtRatController,
            label: '부채 비율 (예: 0.25)',
            suffix: '',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildDropdown(_sidoList, _selectedSido, (newValue) {
                if (newValue == null) return;
                setState(() {
                  _selectedSido = newValue;
                  _updateGusiListForSido();
                  // 시/도 변경 시 아파트 목록 다시 불러오기
                  _fetchApartmentData();
                });
              }, hint: "시/도 선택"),
              ),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _buildDropdown(_gusiList, _selectedGusi, (newValue) {
                if (newValue == null) return;
                setState(() {
                  _selectedGusi = newValue;
                  // 시/군/구 변경 시 아파트 목록 다시 불러오기
                  _fetchApartmentData();
                });
              }, hint: "시/군/구 선택", disabled: _gusiList.isEmpty),
              ),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _buildDropdown(
                _apartmentDropdownList,
                _selectedApartmentInDropdown,
                    (newValue) => setState(() => _selectedApartmentInDropdown = newValue),
                hint: "아파트 선택",
                disabled: _apartmentDropdownList.isEmpty,
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // [추가] 추천 버튼만 있는 새로운 위젯
  Widget _buildRecommendationButtonSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: ElevatedButton(
        onPressed: _getRecommendations,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF14B997),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('추천 받기', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        // _isRecommending
        //     ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            // : const Text('추천 받기', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // [삭제] _buildApartmentListSection, _buildListItem 위젯 제거

  Widget _buildDropdown(List<String> items, String? value, ValueChanged<String?> onChanged, {String? hint, bool disabled = false}) {
    // ... 이전 코드와 동일
    final dropdownValue = disabled || (value != null && !items.contains(value)) ? null : value;
    return DropdownButtonFormField<String>(
      value: dropdownValue,
      hint: Text(hint ?? '선택', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
      items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis,))).toList(),
      onChanged: disabled ? null : onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF14B997))),
        fillColor: disabled ? Colors.grey.shade200 : const Color(0xFFF7F8FA),
        filled: true,
      ),
      isExpanded: true,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // ... 이전 코드와 동일
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF14B997))),
        fillColor: const Color(0xFFF7F8FA),
        filled: true,
      ),
    );
  }

  Widget _buildRecommendationResultSection() {
    // ... 이전 코드와 동일
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('AI 추천 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recommendedList.length,
            itemBuilder: (context, index) {
              Color backgroundColor;
              switch (index) {
                case 0: backgroundColor = Colors.white; break;
                case 1: backgroundColor = Colors.grey.shade50; break;
                case 2: backgroundColor = Colors.grey.shade100; break;
                case 3: backgroundColor = Colors.grey.shade200; break;
                default: backgroundColor = Colors.white; break;
              }
              return Container(
                color: backgroundColor,
                child: RecommendedListItem(
                  rank: index + 1,
                  item: _recommendedList.elementAt(index),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              ),
              child: const Text('더보기', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.normal)),
            ),
          )
        ],
      ),
    );
  }
}

class RecommendedListItem extends StatefulWidget {
  final int rank;
  final Map<String, dynamic> item;

  const RecommendedListItem({
    super.key,
    required this.rank,
    required this.item,
  });

  @override
  State<RecommendedListItem> createState() => _RecommendedListItemState();
}

class _RecommendedListItemState extends State<RecommendedListItem> {
  @override
  Widget build(BuildContext context) {
    final String aptName = widget.item['apt'] ?? '없음';
    final String region = widget.item['gu'] ?? '없음';
    final String area = (widget.item['area'] as num? ?? 0.0).toStringAsFixed(1);
    final String price = '${(widget.item['price'] as num? ?? 0.0).toStringAsFixed(1)} 억원';
    final String similarity = ((widget.item['score'] as num? ?? 0.0) * 100).toStringAsFixed(1);

    final List<MapEntry<String, int>> tagScores = [
      MapEntry('교통', widget.item['교통'] ?? 0),
      MapEntry('교육', widget.item['교육'] ?? 0),
      MapEntry('주거환경', widget.item['주거환경'] ?? 0),
      MapEntry('편의시설', widget.item['편의시설'] ?? 0),
    ];
    tagScores.sort((a, b) => b.value.compareTo(a.value));

    final List<Color> rankBgColors = [
      const Color(0xFF14B997),
      const Color(0xFF66C5AD),
      const Color(0xFFA3D9C8),
      const Color(0xFFC1E5DA),
    ];
    final List<Color> rankTextColors = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${widget.rank}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF14B997))),
                const SizedBox(width: 12),
                Expanded(child: Text(aptName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('지역', region),
                _buildInfoColumn('전용면적', '${area} m²'),
                _buildInfoColumn('평균거래금액', price),
                _buildInfoColumn('유사도', '$similarity 점'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(tagScores.length, (index) {
                final rankedTag = tagScores[index];
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: rankBgColors[index],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(right: index == tagScores.length - 1 ? 0 : 8),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            rankedTag.key,
                            style: TextStyle(
                              fontSize: 13,
                              color: rankTextColors[index],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${rankedTag.value}',
                            style: TextStyle(
                              fontSize: 12,
                              color: rankTextColors[index].withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}