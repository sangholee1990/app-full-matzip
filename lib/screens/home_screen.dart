import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';

// import 'package:flutter_config/flutter_config.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dot_json_env/flutter_dot_json_env.dart';
import 'package:app_full_matzip/services/api_service.dart';
import 'dart:math';
import 'package:intl/intl.dart';

//================================================================================
// 3. Home Screen (Iphone13Mini2.dart 기반)
// 파일 경로: lib/screens/home_screen.dart
//================================================================================
// 1. StatefulWidget으로 변경
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MatzipApiService _apiService = MatzipApiService();

  final List<String> _apartmentFilters = ["전국", "서울", "경기", "인천", "부산"];
  late String _selectedApartmentFilter;
  late Future<Map<String, dynamic>> _apartmentsFuture;
  int _currentLimit = 10;

  final List<String> _regionTabs = ['서울특별시', '경기도'];
  late String _selectedRegionTab;
  late Future<Map<String, dynamic>> _regionsFuture;
  String? _selectedSubRegion;

  late String _selArea;
  late Future<Map<String, dynamic>> _selAreaData;
  int _selAreaLimit = 10;
  String? _selAreaSgg;

  @override
  void initState() {
    super.initState();
    // 초기 필터를 '전국'으로 설정
    _selectedApartmentFilter = _apartmentFilters.first;
    _selectedRegionTab = _regionTabs.first;

    // 위젯이 처음 로드될 때 '전국'에 대한 데이터를 가져옴
    _fetchApartments();
    // 초기 지역 데이터 로드 및 첫 번째 하위 지역 자동 선택 실행
    _onRegionTabTapped(_selectedRegionTab, isInitialLoad: true);
  }

  // 필터에 맞는 데이터를 불러오는 함수
  void _fetchApartments() {
    setState(() {
      _apartmentsFuture = _apiService
          .fetchData(apiUrl: '/api/sel-statRealMaxBySggApt', apiParam: {
        'sgg': _selectedApartmentFilter,
        'page': 1,
        'limit': _currentLimit,
        'sort': 'cnt|desc'
      });
    });
  }

  void _fetchRegions() {
    setState(() {
      _regionsFuture = _apiService.fetchData(
          apiUrl: '/api/sel-statRealSearchBySgg',
          apiParam: {
            'sgg': _selectedRegionTab,
            'page': 1,
            'limit': 99,
            'sort': 'cnt|desc'
          });
    });
  }

  void _fetchAreaData() {
    setState(() {
      if (_selAreaSgg == null) {
        _selAreaData = Future.value({'data': []});
        return;
      }

      _selAreaData = _apiService.fetchData(
          apiUrl: '/api/sel-statRealMaxBySggApt',
          apiParam: {
            'sgg': _selAreaSgg,
            'page': 1,
            'limit': _selAreaLimit,
            'sort': 'cnt|desc'
          });
    });
  }

  // 필터 버튼이 탭되었을 때 호출될 함수
  void _onFilterTapped(String filter) {
    // 이미 선택된 필터가 아니면 새로운 데이터를 불러옴
    if (_selectedApartmentFilter != filter) {
      _selectedApartmentFilter = filter;
      _currentLimit = 10;
      _fetchApartments();
    }
  }

  void _onSeeMoreTapped() {
    setState(() {
      _currentLimit = 30;
    });
    _fetchApartments();
  }

  // [수정] 상위 지역 탭 선택 시 로직
  void _onRegionTabTapped(String regionName, {bool isInitialLoad = false}) {
    // 동일한 탭을 다시 누르거나, 초기 로드가 아닐 때만 실행
    if (_selectedRegionTab != regionName || isInitialLoad) {
      setState(() {
        _selectedRegionTab = regionName;
        // 하위 지역 선택 및 관련 데이터를 모두 초기화
        _selectedSubRegion = null;
        _selAreaSgg = null;
        _selAreaData = Future.value({'data': []}); // 이전 목록을 지움
        _fetchRegions();
      });
    }
  }

  void _onAreaDataSeeMore() {
    setState(() {
      _selAreaLimit = 30;
    });
    _fetchAreaData();
  }

  // 스타일 정의는 원본과 동일하게 유지...
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
    height: 1.39,
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
  static const TextStyle _searchInputStyle = TextStyle(
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
  static const TextStyle _listItemRankStyle =
      TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle _listItemNewStyle = TextStyle(
      color: Color(0xFF14B997), fontSize: 10, fontWeight: FontWeight.w400);
  static const TextStyle _listItemNameStyle =
      TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle _listItemDetailsStyle = TextStyle(
      color: Color(0xFF14B997), fontSize: 10, fontWeight: FontWeight.w400);
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

  @override
  Widget build(BuildContext context) {
    const double figmaHeaderActualHeight = 15.0 + 27.0 + 10.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: figmaHeaderActualHeight,
                  bottom: 60,
                ),
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
                          _buildRecommendationCard(
                            context,
                            title: '교육을 중시하는',
                            subtitle: '3040 부부에게 \n맞는 집',
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF0B4438),
                                Color(0xFF1BAA8B),
                              ],
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
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/ai-recommendation-preview',
                        ),
                        child: Container(
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Color(0x7F199C80),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '구독하고 나에게 꼭 맞는 매물 추천 보기',
                              style: _subscribeButtonTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // [개선] 재사용 가능한 빌더 함수로 'TOP 아파트' 섹션 구성
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildInfoSection(
                        title: 'TOP 10 아파트',
                        future: _apartmentsFuture,
                        data: _apartmentsFuture,
                        headerContent: _buildApartmentFilters(),
                        // 필터 버튼 UI
                        itemBuilder: (itemData, index) {
                          if (itemData['apt'] == null)
                            return const SizedBox.shrink();

                          final String rank = (index + 1).toString();
                          final String name = itemData['apt'];
                          // final String details = "조회수 증가 +${itemData['cnt'] ?? ''}";
                          final int count = itemData['cnt'] as int? ?? 0;
                          final String formattedCount = NumberFormat('#,###').format(count);
                          final String details = "조회수 증가 +$formattedCount";
                          final bool isNew = Random(index).nextBool();
                          final bool hasUpArrow = Random(index + 1).nextBool();
                          return _buildApartmentListItem(
                            context,
                            rank,
                            name,
                            details,
                            isNew: isNew,
                            hasUpArrow: hasUpArrow,
                          );
                        },
                        onSeeMoreTapped: _onSeeMoreTapped,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // [개선] 동일한 빌더 함수로 'TOP 지역' 섹션 구성
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildInfoSection(
                        title: 'TOP 10 지역',
                        future: _regionsFuture,
                        data: _selAreaData,
                        headerContent: _buildRegionSelector(
                          onTabSelected: (tabName) {
                            _onRegionTabTapped(tabName);
                          },
                          onSubRegionSelected: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedSubRegion = newValue;
                                _selAreaSgg = newValue;
                                _selAreaLimit = 10;
                                _fetchAreaData();
                              });
                            }
                          },
                        ),
                        itemBuilder: (itemData, index) {
                          if (itemData['apt'] == null) {
                            return const SizedBox.shrink();
                          }

                          final String rank = (index + 1).toString();
                          final String name = itemData['apt'];
                          // final String details = "조회수 증가 +${itemData['cnt'] ?? ''}";
                          final int count = itemData['cnt'] as int? ?? 0;
                          final String formattedCount = NumberFormat('#,###').format(count);
                          final String details = "조회수 증가 +$formattedCount";
                          final bool isNew = Random(index).nextBool();
                          final bool hasUpArrow = Random(index + 1).nextBool();
                          return _buildApartmentListItem(
                            context,
                            rank,
                            name,
                            details,
                            isNew: isNew,
                            hasUpArrow: hasUpArrow,
                          );
                        },
                        onSeeMoreTapped: _onAreaDataSeeMore,
                      ),
                    )
                    // const SizedBox(height: 20 + 60),
                    // const SizedBox(height: 20),
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
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 15,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      // 자식 위젯들의 크기만큼만 공간을 차지하도록 설정
                      children: [
                        Icon(
                          Icons.business_center,
                          color: Color(0xFF161D24),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "MATZIP",
                          style: TextStyle(
                            color: Color(0xFF161D24),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard Variable',
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.notifications_none,
                          color: Color(0xFF161D24),
                          size: 24,
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.person_outline,
                          color: Color(0xFF161D24),
                          size: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ** 공통 네비게이션 바 적용 **
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 0),
    );
  }

  // ===========================================================================
  // Widget
  // ===========================================================================
  Widget _buildInfoSection({
    required String title,
    // required Future<Map<String, dynamic>> future,
    Future<Map<String, dynamic>>? future,
    Future<Map<String, dynamic>>? data,
    required Widget headerContent,
    required Widget Function(Map<String, dynamic> itemData, int index)
        itemBuilder,
    VoidCallback? onSeeMoreTapped,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: const Color(0xFF161D24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      // FutureBuilder를 Column 안으로 이동시켰습니다.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(TextSpan(children: [
                const TextSpan(text: '조회수\n', style: _sectionTitleDarkStyle),
                TextSpan(text: title, style: _sectionTitleDarkStyle)
              ])),
              // 날짜는 Future가 완료되어야 표시되므로 작은 FutureBuilder를 유지하거나,
              // 상태 변수로 관리할 수 있습니다. 현재 구조는 그대로 유지합니다.
              FutureBuilder<Map<String, dynamic>>(
                future: future,
                builder: (context, snapshot) {
                  final String date =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  return Text('데이터 산출일 : $date',
                      style: _dateTextStyle.copyWith(
                          color: Colors.white.withOpacity(0.7)));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 필터 또는 탭 UI도 항상 표시됩니다.
          headerContent,
          const SizedBox(height: 20),

          // --- 이 부분만 Future의 상태에 따라 변경됩니다 ---
          if (data != null)
            FutureBuilder<Map<String, dynamic>>(
              future: data,
              builder: (context, snapshot) {
                // 1. 로딩 상태 처리
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child:
                              CircularProgressIndicator(color: Colors.white)));
                }
                // 2. 에러 상태 처리
                if (snapshot.hasError) {
                  final errorMessage =
                      snapshot.error.toString().replaceFirst('Exception: ', '');
                  return Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child:
                              Text(errorMessage, style: _listItemNameStyle)));
                }
                // 3. 데이터 없음 또는 빈 데이터 처리
                if (!snapshot.hasData ||
                    snapshot.data!['data'] == null ||
                    (snapshot.data!['data'] as List).isEmpty) {
                  return const Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child:
                              Text('검색 결과가 없습니다.', style: _listItemNameStyle)));
                }

                // 4. 성공 시 데이터 목록 표시
                final List<dynamic> items =
                    snapshot.data!['data'] as List<dynamic>;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      itemBuilder(items[index], index),
                );
              },
            ),

          // '더보기' 버튼 (콜백이 있을 때만 표시)
          if (onSeeMoreTapped != null) ...[
            const SizedBox(height: 15),
            Center(
              child: InkWell(
                onTap: onSeeMoreTapped,
                child: const Opacity(
                    opacity: 0.50,
                    child: Text('더보기',
                        textAlign: TextAlign.center, style: _seeMoreStyle)),
              ),
            ),
          ] else
            const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _buildApartmentFilters() {
    return Row(
      children: _apartmentFilters
          .map((filter) => Expanded(
                child: InkWell(
                  onTap: () => _onFilterTapped(filter),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: ShapeDecoration(
                        color: _selectedApartmentFilter == filter
                            ? const Color(0xFF14B997)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(filter,
                        textAlign: TextAlign.center,
                        style: _filterButtonTextStyle.copyWith(
                            color: _selectedApartmentFilter == filter
                                ? Colors.white
                                : const Color(0xFF878787))),
                  ),
                ),
              ))
          .toList(),
    );
  }

  // [수정] 탭과 드롭다운을 모두 포함하는 위젯 빌더
  Widget _buildRegionSelector({
    required ValueChanged<String> onTabSelected,
    required ValueChanged<String?> onSubRegionSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. 상위 지역 선택 탭
        Row(
          children: _regionTabs.map((tabName) {
            final isSelected = tabName == _selectedRegionTab;
            return Expanded(
              child: InkWell(
                onTap: () => onTabSelected(tabName),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    )),
                  ),
                  child: Text(
                    tabName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),

        // [수정] 2. 하위 지역 선택 드롭다운 (FutureBuilder 사용)
        FutureBuilder<Map<String, dynamic>>(
          future: _regionsFuture,
          builder: (context, snapshot) {
            // 로딩 중일 때
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 48,
                child: Center(
                    child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white))),
              );
            }
            // 에러 발생 시
            if (snapshot.hasError) {
              return SizedBox(
                  height: 48,
                  child: Center(
                      child: Text('목록 로드 실패',
                          style: TextStyle(color: Colors.red))));
            }
            // 데이터가 없거나 비어있을 때
            if (!snapshot.hasData ||
                snapshot.data!['data'] == null ||
                (snapshot.data!['data'] as List).isEmpty) {
              return const SizedBox(
                  height: 48,
                  child: Center(
                      child: Text('검색 결과가 없습니다.',
                          style: TextStyle(color: Colors.white70))));
            }

            // 성공 시 드롭다운 메뉴 구성
            final subRegionsRaw = snapshot.data!['data'] as List<dynamic>;
            final subRegionNames = subRegionsRaw
                .where((item) => item['sgg'] != null)
                .map((item) => item['sgg'] as String)
                .toList();

            // 탭 변경 후 _selectedSubRegion이 null인 경우,
            // 첫 번째 아이템을 자동으로 선택하도록 콜백을 예약합니다.
            if (_selectedSubRegion == null && subRegionNames.isNotEmpty) {
              final firstSubRegion = subRegionNames.first;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // 위젯이 여전히 마운트된 상태인지 확인 후 상태 업데이트
                if (mounted) {
                  onSubRegionSelected(firstSubRegion);
                }
              });
            }

            // 현재 빌드 프레임에서 Dropdown의 값으로 사용할 변수.
            String? currentSelection = _selectedSubRegion;
            if (currentSelection == null ||
                !subRegionNames.contains(currentSelection)) {
              currentSelection =
                  subRegionNames.isNotEmpty ? subRegionNames.first : null;
            }

            if (currentSelection == null) {
              return const SizedBox(
                  height: 48,
                  child: Center(
                      child: Text('선택 가능한 지역이 없습니다.',
                          style: TextStyle(color: Colors.white70))));
            }

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentSelection,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF334155),
                  hint: const Text('시군구 선택',
                      style: TextStyle(color: Colors.white70)),
                  icon:
                      const Icon(Icons.arrow_drop_down, color: Colors.white70),
                  style: const TextStyle(color: Colors.white),
                  items:
                      subRegionNames.map<DropdownMenuItem<String>>((sggName) {
                    return DropdownMenuItem<String>(
                      value: sggName,
                      child: Text(sggName, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: onSubRegionSelected,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // 아파트 리스트 아이템 UI
  Widget _buildApartmentListItem(
      BuildContext context, String rank, String name, String details,
      {bool isNew = false, bool hasUpArrow = false}) {
    return InkWell(
      onTap: () {
        /* 상세 페이지로 이동 */
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            // 1. 순위와 순위 변동 아이콘 (고정 너비)
            SizedBox(
              width: 40.0, // 순위(최대 2자리)와 아이콘을 모두 표시할 충분한 공간
              child: Row(
                children: [
                  Text(rank, style: _listItemRankStyle),
                  const SizedBox(width: 4), // 숫자와 아이콘 사이의 간격
                  if (hasUpArrow)
                    const Icon(Icons.arrow_upward,
                        color: Color(0xFF14B997), size: 14),
                ],
              ),
            ),

            // 2. 'NEW' 태그 (고정 너비)
            SizedBox(
              width: 40.0, // 'NEW' 태그 또는 공백을 위한 고정 공간
              child: isNew
                  ? const Align(
                      alignment: Alignment.centerLeft, // 왼쪽 정렬
                      child: Text('NEW', style: _listItemNewStyle),
                    )
                  : const SizedBox(), // isNew가 아닐 경우, 공간만 차지하고 내용은 없음
            ),

            // 3. 아파트 이름과 상세 정보 (가변 너비)
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: _listItemNameStyle,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text(details, style: _listItemDetailsStyle),
                  ]),
            ),

            // 4. 오른쪽 화살표 아이콘
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  // 지역 리스트 아이템 UI
  Widget _buildRegionItem(Map<String, dynamic> itemData) {
    // 1. Map에서 데이터 추출 (null일 경우 기본값 사용)
    final String sggName = itemData['sgg'] ?? '알 수 없는 지역';
    final int count = itemData['cnt'] as int? ?? 0;

    // 2. 숫자에 쉼표 포맷 적용
    final numberFormatter = NumberFormat('#,###');
    final String formattedCount = numberFormatter.format(count);

    return InkWell(
      onTap: () {
        // 이 지역을 탭했을 때 상단 아파트 리스트 필터링
        _onFilterTapped(sggName);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          // 3. Row를 사용하여 양쪽 끝 정렬
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 왼쪽: 지역 이름
            Text(sggName, style: _listItemNameStyle),
            // 오른쪽: 조회수 (cnt)
            Text(
              formattedCount,
              style: _listItemDetailsStyle.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // // 위젯 빌더 함수들... (원본과 동일)
  Widget _buildRecommendationCard(BuildContext context,
      {required String title,
      required String subtitle,
      Gradient? gradient,
      Color? color}) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        width: (screenSize.width - 40 - 10) / 2,
        height: 190,
        padding: const EdgeInsets.all(15),
        decoration: ShapeDecoration(
            gradient: gradient,
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: _cardSmallTextStyle),
          const SizedBox(height: 10),
          Text(subtitle, style: _cardLargeTextStyle)
        ]));
  }
}
