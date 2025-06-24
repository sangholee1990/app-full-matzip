import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:app_full_matzip/utils/common_bottom_nav_bar.dart';
import 'package:app_full_matzip/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AptScreen extends StatefulWidget {
  const AptScreen({super.key});

  @override
  State<AptScreen> createState() => _AptScreenState();
}

class _AptScreenState extends State<AptScreen> {
  final MatzipApiService _apiService = MatzipApiService();

  late RangeValues _currentRangeValues;
  List<Map<String, dynamic>> _apartmentList = [];
  bool _isListLoading = false;
  String? _errorMessage;

  Timer? _debounce;
  final Map<String, Iterable<String>> _suggestionCache = {};
  String _aptSearchText = '';

  List<Map<String, dynamic>>? _allRegionData;
  List<String>? _sidoList;
  List<String>? _gusiList;
  List<String>? _pyeongList;
  String? _selectedSido;
  String? _selectedGusi;
  String? _selectedPyeong;

  int _currentPage = 1;
  bool _isMoreLoading = false;

  @override
  void initState() {
    super.initState();
    final int currentYear = DateTime.now().year;
    _currentRangeValues =
        RangeValues((currentYear - 10).toDouble(), currentYear.toDouble());
    _loadInitialFilters();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // --- 데이터 로딩 및 상태 관리 함수 (이전과 동일) ---

  Future<void> _loadInitialFilters() async {
    try {
      _allRegionData = await _fetchAllRegionData();
      if (!mounted) return;

      final sidoSet = <String>{};
      for (var region in _allRegionData!) {
        final parts = region['sgg'].toString().split(' ');
        if (parts.isNotEmpty) sidoSet.add(parts[0]);
      }
      final fetchedSidoList = sidoSet.toList()..sort();
      final firstSido = fetchedSidoList.isNotEmpty ? fetchedSidoList.first : null;

      final fetchedGusiList = firstSido != null ? _getGusiListForSido(firstSido) : <String>[];
      final firstGusiFormatted = fetchedGusiList.isNotEmpty ? fetchedGusiList.first : null;
      final firstGusiRaw = firstGusiFormatted?.split(' (')[0];

      final fetchedPyeongList = (firstSido != null && firstGusiRaw != null)
          ? await _fetchPyeongData(sido: firstSido, gusi: firstGusiRaw)
          : <String>[];
      final firstPyeong = fetchedPyeongList.isNotEmpty ? fetchedPyeongList.first : null;

      setState(() {
        _sidoList = fetchedSidoList;
        _gusiList = fetchedGusiList;
        _pyeongList = fetchedPyeongList;
        _selectedSido = firstSido;
        _selectedGusi = firstGusiFormatted;
        _selectedPyeong = firstPyeong;
      });
      await _searchApartments();
    } catch (e) {
      if(mounted) setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _searchApartments({bool isNewSearch = true}) async {
    if (isNewSearch) FocusScope.of(context).unfocus();

    if (isNewSearch) {
      setState(() {
        _currentPage = 1;
        _apartmentList = [];
        _isListLoading = true;
        _errorMessage = null;
      });
    } else {
      setState(() => _isMoreLoading = true);
    }

    if (_selectedSido == null || _selectedGusi == null || _selectedPyeong == null) {
      setState(() {
        _apartmentList = [];
        _isListLoading = false;
        _isMoreLoading = false;
      });
      return;
    }

    try {
      final params = {
        'sgg': '${_selectedSido!} ${_selectedGusi!.split(' (')[0]}',
        'srtYear': _currentRangeValues.start.round().toString(),
        'endYear': _currentRangeValues.end.round().toString(),
        'apt': _aptSearchText,
        'limit': 10,
        'page': _currentPage,
        'sort': 'date|desc',
      };

      if (_selectedPyeong != '전체') {
        params['area'] = _selectedPyeong!.split(' (')[0];
      }

      final response = await _apiService.fetchData(apiUrl: '/api/sel-real', apiParam: params);
      if (mounted) {
        final List<Map<String, dynamic>> newList = List<Map<String, dynamic>>.from(response['data'] ?? []);
        setState(() {
          if (isNewSearch) {
            _apartmentList = newList;
          } else {
            _apartmentList.addAll(newList);
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isListLoading = false;
          _isMoreLoading = false;
        });
      }
    }
  }

  void _loadMore() {
    setState(() => _currentPage++);
    _searchApartments(isNewSearch: false);
  }

  void _clearSuggestionCache() {
    setState(() => _suggestionCache.clear());
  }

  void _onSidoChanged(String? newValue) async {
    if (newValue == null || newValue == _selectedSido) return;
    _clearSuggestionCache();
    setState(() {
      _sidoList = _sidoList;
      _gusiList = null;
      _pyeongList = null;
      _selectedSido = newValue;
      _selectedGusi = null;
      _selectedPyeong = null;
    });

    final newGusiList = _getGusiListForSido(newValue);
    final firstGusiFormatted = newGusiList.isNotEmpty ? newGusiList.first : null;
    setState(() => _gusiList = newGusiList);
    setState(() => _selectedGusi = firstGusiFormatted);
    await _updatePyeongList();
  }

  void _onGusiChanged(String? newValue) async {
    if (newValue == null || newValue == _selectedGusi) return;
    _clearSuggestionCache();
    setState(() {
      _gusiList = _gusiList;
      _pyeongList = null;
      _selectedGusi = newValue;
      _selectedPyeong = null;
    });
    await _updatePyeongList();
  }

  void _onPyeongChanged(String? newValue) {
    if (newValue == null || newValue == _selectedPyeong) return;
    _clearSuggestionCache();
    setState(() => _selectedPyeong = newValue);
    _searchApartments(); // 자동 검색 호출
  }

  Future<void> _updatePyeongList() async {
    final rawSidoName = _selectedSido;
    final rawGusiName = _selectedGusi?.split(' (')[0];
    final newPyeongList = await _fetchPyeongData(sido: rawSidoName, gusi: rawGusiName);
    final firstPyeong = newPyeongList.isNotEmpty ? newPyeongList.first : null;
    if (mounted) {
      setState(() {
        _pyeongList = newPyeongList;
        _selectedPyeong = firstPyeong;
      });
    }
  }

  List<String> _getGusiListForSido(String sido) {
    if (_allRegionData == null) return [];
    final numberFormatter = NumberFormat('#,###');
    return _allRegionData!
        .where((region) => region['sgg'].toString().startsWith(sido))
        .map((region) {
      final parts = region['sgg'].toString().split(' ');
      final gusi = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      final count = region['cnt'] as int? ?? 0;
      return '$gusi (${numberFormatter.format(count)})';
    }).where((gusi) => gusi.isNotEmpty).toList()..sort();
  }

  Future<Iterable<String>> _fetchAutocompleteSuggestions(TextEditingValue textEditingValue) async {
    final query = textEditingValue.text;
    if(query.isEmpty) return const Iterable<String>.empty();
    if(_suggestionCache.containsKey(query)) return _suggestionCache[query]!;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final completer = Completer<Iterable<String>>();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (_selectedSido == null || _selectedGusi == null) {
        completer.complete(const []); return;
      }
      try {
        final params = {
          'sgg': '${_selectedSido!} ${_selectedGusi!.split(' (')[0]}',
          'apt': query, 'srtYear': _currentRangeValues.start.round().toString(),
          'endYear': _currentRangeValues.end.round().toString(),
          'limit': 100, 'page': 1, 'sort': 'cnt|desc',
        };
        if (_selectedPyeong != '전체') {
          params['area'] = _selectedPyeong!.split(' (')[0];
        }

        final response = await _apiService.fetchData(
            apiUrl: '/api/sel-statRealSearchByApt', apiParam: params);

        if (mounted && response.containsKey('data') && response['data'] is List) {
          final suggestions = (response['data'] as List).map((item) => item['apt'].toString()).toList();
          _suggestionCache[query] = suggestions;
          completer.complete(suggestions);
        } else {
          completer.complete(const []);
        }
      } catch (e) {
        completer.complete(const []);
      }
    });
    return completer.future;
  }

  // --- 이하 UI 빌드 위젯 ---

  // [수정] AppBar를 이미지에 맞게 단순화
  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF14B997),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/svg/logo_matzip_white.svg', width: 92),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
              IconButton(icon: const Icon(Icons.person_outline, color: Colors.white), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildResultList()),
        ],
      ),
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 1),
    );
  }

  // [수정] 필터 섹션 UI를 이미지에 맞게 전면 수정
  Widget _buildFilterSection() {
    return Container(
      color: const Color(0xFF14B997), // 배경색 녹색
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 20.0),
      child: Column(
        children: [
          // 1. 뒤로가기 버튼과 제목
          Row(
            children: [
              // IconButton(
              //   icon: const Icon(Icons.arrow_back, color: Colors.white),
              //   onPressed: () => Navigator.pop(context),
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              // ),
              // const SizedBox(width: 8),
              const Text('아파트 데이터', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          // 2. 검색 필드와 버튼
          Row(
            children: [
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Autocomplete<String>(
                      optionsBuilder: _fetchAutocompleteSuggestions,
                      onSelected: (String selection) {
                        setState(() => _aptSearchText = selection);
                        _searchApartments();
                      },
                      fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
                        final bool isEnabled = _sidoList != null;
                        return TextField(
                          controller: fieldController,
                          focusNode: focusNode,
                          enabled: isEnabled,
                          style: const TextStyle(color: Colors.black87),
                          onChanged: (text) => _aptSearchText = text,
                          onSubmitted: (text) => _searchApartments(),
                          decoration: InputDecoration(
                              hintText: isEnabled ? '아파트명을 입력하세요.' : '필터 로딩 중...',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 22),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 0)),
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 250),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return InkWell(
                                      onTap: () => onSelected(option),
                                      child: ListTile(title: Text(option)),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _searchApartments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C493C), // 어두운 녹색 버튼
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('검색', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          // 3. 지역 및 평형 드롭다운
          Row(
              children: [
                _buildFilterDropdown(
                    hint: '시/도', items: _sidoList,
                    value: _selectedSido, onChanged: _onSidoChanged, flex: 2),
                const SizedBox(width: 8),
                _buildFilterDropdown(
                    hint: '구/시', items: _gusiList, value: _selectedGusi,
                    onChanged: _selectedSido == null ? null : _onGusiChanged, flex: 3),
                const SizedBox(width: 8),
                _buildFilterDropdown(
                    hint: '평형', items: _pyeongList, value: _selectedPyeong,
                    onChanged: (_gusiList?.isEmpty ?? true) ? null : _onPyeongChanged, flex: 3)
              ]),
          const SizedBox(height: 12),
          // 4. 연도 슬라이더
          _buildYearSlider(),
        ],
      ),
    );
  }

  Widget _buildResultList() {
    if (_sidoList == null && _errorMessage == null) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF14B997)));
    }
    if (_isListLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF14B997)));
    }
    if (_errorMessage != null) {
      return Center(child: Text('오류가 발생했습니다: $_errorMessage'));
    }
    if (_apartmentList.isEmpty) {
      return Container(
          color: Colors.white,
          child: const Center(child: Text('검색 결과가 없습니다.'))
      );
    }

    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _apartmentList.length + 1,
        itemBuilder: (context, index) {
          if (index == _apartmentList.length) {
            return _buildLoadMoreButton();
          }
          return _buildApartmentListItem(item: _apartmentList[index], index: index);
        },
        separatorBuilder: (context, index) =>
        const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFEAEAEA)),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: _isMoreLoading
            ? const CircularProgressIndicator(color: Color(0xFF14B997))
            : TextButton(
            onPressed: _loadMore,
            child: const Text('더보기',
                style: TextStyle(
                    color: Color(0xFF878787),
                    fontSize: 14,
                    fontWeight: FontWeight.w500))),
      ),
    );
  }

  Widget _buildFilterDropdown(
      {required String hint,
        required List<String>? items,
        required String? value,
        required ValueChanged<String?>? onChanged,
        int flex = 1}) {
    final bool isLoading = items == null;
    return Expanded(
        flex: flex,
        child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: isLoading
                ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.0, color: Color(0xFF14B997))))
                : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: value,
                    hint: Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 13), overflow: TextOverflow.ellipsis),
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500, size: 20),
                    onChanged: onChanged,
                    items: (items ?? [])
                        .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontSize: 13))))
                        .toList()))));
  }

  Widget _buildYearSlider() {
    final int currentYear = DateTime.now().year;
    final int startYear = 2006;
    final Set<int> labelYears = {startYear, currentYear};
    for (int year = startYear + 1; year < currentYear; year++) {
      if (year % 5 == 0) {
        labelYears.add(year);
      }
    }
    final sortedLabelYears = labelYears.toList()..sort();
    return Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: RangeSlider(
              values: _currentRangeValues,
              min: startYear.toDouble(),
              max: currentYear.toDouble(),
              divisions: (currentYear - startYear),
              activeColor: const Color(0xFF0C493C),
              inactiveColor: Colors.white.withOpacity(0.5),
              labels: RangeLabels('${_currentRangeValues.start.round()}년', '${_currentRangeValues.end.round()}년'),
              onChangeEnd: (values) {
                _searchApartments();
              },
              onChanged: (RangeValues values) {
                if (values.start.round() <= values.end.round()) {
                  setState(() => _currentRangeValues = values);
                }
              })),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: sortedLabelYears
                  .map((year) => Text("${year.toString().substring(2)}", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)))
                  .toList()))
    ]);
  }

  Widget _buildDetailColumn(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis,),
        ],
      ),
    );
  }

  Widget _buildApartmentListItem({required Map<String, dynamic> item, required int index}) {
    final String aptName = item['apt'] ?? '이름 없음';
    final String amountText = item['amountConv']?.toString() ?? '정보 없음';
    final String capacity = (item['capacity'] as num? ?? 0.0).toStringAsFixed(1);
    final String area = item['area']?.toString() ?? '';
    final int floor = (item['floor'] as num? ?? 0).toInt();
    final String date = item['date']?.toString() ?? ''; // 날짜를 MM-DD 형식으로
    final String conDate = item['conDate']?.toString() ?? '';

    return InkWell(
        onTap: () => Navigator.pushNamed(context, '/apartment-details', arguments: {'name': aptName}),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 30,
                        child: Text((index + 1).toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(aptName,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                height: 1.3))),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.grey[400], size: 22)
                  ],
                ),
                const SizedBox(height: 0),
                Row(
                  children: [
                    const SizedBox(width: 38),
                    _buildDetailColumn('거래금액', '${amountText} 억'),
                    _buildDetailColumn('전용면적', '${capacity} m²'),
                    _buildDetailColumn('평형', '${area}'),
                    _buildDetailColumn('층', '${floor} 층'),
                    _buildDetailColumn('거래일', '$date'),
                    _buildDetailColumn('건축일', '$conDate'),
                  ],
                )
              ],
            )));
  }

  // API Call methods
  Future<List<Map<String, dynamic>>> _fetchAllRegionData() async {
    final responseData = await _apiService.fetchData(
        apiUrl: '/api/sel-statRealSearchBySgg',
        apiParam: {'page': 1, 'limit': '999', 'sort': 'cnt|desc'});
    if (responseData.containsKey('data') && responseData['data'] is List) {
      return (responseData['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<List<String>> _fetchPyeongData({String? sido, String? gusi}) async {
    if (sido == null || gusi == null) return ['전체'];
    final String sgg = '$sido $gusi';
    final responseData = await _apiService.fetchData(
        apiUrl: '/api/sel-statRealSearchByArea',
        apiParam: {'sgg': sgg, 'limit': 999, 'page': 1});

    if (responseData.containsKey('data') && responseData['data'] is List) {
      final List<Map<String, dynamic>> dataList =
      (responseData['data'] as List).cast<Map<String, dynamic>>();
      dataList.sort((a, b) {
        double getSortValue(String s) {
          final match = RegExp(r'\d+').firstMatch(s);
          if (match == null) return double.infinity;
          double num = double.parse(match.group(0)!);
          if (s.contains('미만')) num -= 0.1;
          return num;
        }
        return getSortValue(a['area'].toString()).compareTo(getSortValue(b['area'].toString()));
      });
      final numberFormatter = NumberFormat('#,###');
      return ['전체', ...dataList.map((item) {
        return '${item['area']} (${numberFormatter.format(item['cnt'])})';
      })];
    }
    return ['전체'];
  }
}