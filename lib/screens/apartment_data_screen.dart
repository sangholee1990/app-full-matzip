import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';
import 'package:app_full_matzip/services/api_service.dart';
import 'package:intl/intl.dart';

// [수정] ApartmentInfo 클래스 제거

class ApartmentDataScreen extends StatefulWidget {
  const ApartmentDataScreen({super.key});

  @override
  State<ApartmentDataScreen> createState() => _ApartmentDataScreenState();
}

class _ApartmentDataScreenState extends State<ApartmentDataScreen> {
  final MatzipApiService _apiService = MatzipApiService();

  late RangeValues _currentRangeValues;
  // [수정] API 결과 리스트를 다시 주 데이터 소스로 사용
  List<Map<String, dynamic>> _apartmentList = [];
  bool _isListLoading = true;

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

  @override
  void initState() {
    super.initState();
    final int currentYear = DateTime.now().year;
    _currentRangeValues =
        RangeValues((currentYear - 10).toDouble(), currentYear.toDouble());
    _loadInitialFiltersAndSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialFiltersAndSearch() async {
    _allRegionData = await _fetchAllRegionData();
    if (!mounted) return;

    final sidoSet = <String>{};
    for (var region in _allRegionData!) {
      final parts = region['sgg'].toString().split(' ');
      if (parts.isNotEmpty) {
        sidoSet.add(parts[0]);
      }
    }
    final fetchedSidoList = sidoSet.toList()..sort();
    final firstSido =
    fetchedSidoList.isNotEmpty ? fetchedSidoList.first : null;

    final fetchedGusiList =
    firstSido != null ? _getGusiListForSido(firstSido) : <String>[];
    final firstGusiFormatted =
    fetchedGusiList.isNotEmpty ? fetchedGusiList.first : null;
    final firstGusiRaw = firstGusiFormatted?.split(' (')[0];

    final fetchedPyeongList = (firstSido != null && firstGusiRaw != null)
        ? await _fetchPyeongData(sido: firstSido, gusi: firstGusiRaw)
        : <String>[];
    final firstPyeong =
    fetchedPyeongList.isNotEmpty ? fetchedPyeongList.first : null;

    setState(() {
      _sidoList = fetchedSidoList;
      _gusiList = fetchedGusiList;
      _pyeongList = fetchedPyeongList;
      _selectedSido = firstSido;
      _selectedGusi = firstGusiFormatted;
      _selectedPyeong = firstPyeong;
    });

    await _searchApartments();
  }

  Future<void> _searchApartments() async {
    if (_selectedSido == null ||
        _selectedGusi == null ||
        _selectedPyeong == null ||
        _aptSearchText == null) {
      return;
    }
    setState(() {
      _isListLoading = true;
    });
    try {
      final params = {
        'sgg': '${_selectedSido!} ${_selectedGusi!.split(' (')[0]}',
        'area': _selectedPyeong!.split(' (')[0],
        'srtYear': _currentRangeValues.start.round().toString(),
        'endYear': _currentRangeValues.end.round().toString(),
        'apt': _aptSearchText,
        'limit': 10,
        'page': 1,
        'sort': 'date|desc',
      };
      final response = await _apiService.fetchData(
          apiUrl: '/api/sel-real', apiParam: params);
      if (mounted) {
        setState(() {
          _apartmentList = (response['data'] as List).cast<Map<String, dynamic>>();
          // print(_apartmentList);
        });
      }
    } catch (e) {
      //...
    } finally {
      if (mounted) {
        setState(() {
          _isListLoading = false;
        });
      }
    }
  }

  void _clearSuggestionCache() {
    setState(() {
      _suggestionCache.clear();
    });
  }

  void _onSidoChanged(String? newValue) async {
    if (newValue == null || newValue == _selectedSido) return;
    _clearSuggestionCache();
    final newGusiList = _getGusiListForSido(newValue);
    final firstGusiFormatted =
    newGusiList.isNotEmpty ? newGusiList.first : null;
    setState(() {
      _selectedSido = newValue;
      _gusiList = newGusiList;
      _selectedGusi = firstGusiFormatted;
      _pyeongList = null;
      _selectedPyeong = null;
    });
    await _updatePyeongAndSearch();
  }

  void _onGusiChanged(String? newValue) async {
    if (newValue == null || newValue == _selectedGusi) return;
    _clearSuggestionCache();
    setState(() {
      _selectedGusi = newValue;
      _pyeongList = null;
      _selectedPyeong = null;
    });
    await _updatePyeongAndSearch();
  }

  void _onPyeongChanged(String? newValue) {
    if (newValue == null || newValue == _selectedPyeong) return;
    _clearSuggestionCache();
    setState(() {
      _selectedPyeong = newValue;
    });
    _searchApartments();
  }

  Future<void> _updatePyeongAndSearch() async {
    final rawSidoName = _selectedSido;
    final rawGusiName = _selectedGusi?.split(' (')[0];
    final newPyeongList =
    await _fetchPyeongData(sido: rawSidoName, gusi: rawGusiName);
    final firstPyeong = newPyeongList.isNotEmpty ? newPyeongList.first : null;
    if (mounted) {
      setState(() {
        _pyeongList = newPyeongList;
        _selectedPyeong = firstPyeong;
      });
      await _searchApartments();
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

    // if (query.isEmpty) {
    //   return const Iterable<String>.empty();
    // }
    if(_suggestionCache.containsKey(query)) {
      return _suggestionCache[query]!;
    }

    // if (_selectedSido == null || _selectedGusi == null || _selectedPyeong == null) {
    //   return const Iterable<String>.empty();
    // }

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final completer = Completer<Iterable<String>>();
    _debounce = Timer(const Duration(milliseconds: 0), () async {
      try {
        final params = {
          'sgg': '${_selectedSido!} ${_selectedGusi!.split(' (')[0]}',
          'area': _selectedPyeong!.split(' (')[0],
          'srtYear': _currentRangeValues.start.round().toString(),
          'endYear': _currentRangeValues.end.round().toString(),
          'apt': query,
          'limit': 30,
          'page': 1,
          'sort': 'cnt|desc',
        };
        final response = await _apiService.fetchData(
            apiUrl: '/api/sel-statRealSearchByApt', apiParam: params);

        if (mounted && response.containsKey('data') && response['data'] is List) {
          final suggestions = (response['data'] as List)
              .map((item) => item['apt'].toString())
              .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: const Text('아파트 데이터'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
          const SizedBox(width: 8)
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF14B997),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Autocomplete<String>(
                        optionsBuilder: _fetchAutocompleteSuggestions,
                        onSelected: (String selection) {
                          setState(() {
                            _aptSearchText = selection;
                          });
                          _searchApartments();
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {

                          final bool isEnabled = _sidoList != null && _gusiList != null && _pyeongList != null;

                          return TextField(
                            controller: fieldController,
                            focusNode: focusNode,
                            enabled: isEnabled,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) {
                              _aptSearchText = text;
                            },
                            onSubmitted: (text) {
                              onFieldSubmitted();
                              _searchApartments();
                            },
                            decoration: InputDecoration(
                                hintText: isEnabled ? '아파트명을 입력하세요.' : '필터 로딩 중...',
                                hintStyle: const TextStyle(
                                    color: Color(0xFF878787),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                prefixIcon: const Icon(Icons.search,
                                    color: Color(0xFF878787), size: 22),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Color(0xFF0C493C)),
                                  onPressed: isEnabled ? () {
                                    _searchApartments();
                                  } : null,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 9.0, horizontal: 0)),
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: ConstrainedBox(
                                  constraints:
                                  const BoxConstraints(maxHeight: 500),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String option =
                                      options.elementAt(index);
                                      return InkWell(
                                        onTap: () {
                                          onSelected(option);
                                        },
                                        child: ListTile(
                                          title: Text(option),
                                        ),
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
                  const SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFilterDropdown(
                            hint: '시도',
                            items: _sidoList,
                            value: _selectedSido,
                            onChanged: _onSidoChanged,
                            flex: 2),
                        _buildFilterDropdown(
                            hint: '구',
                            items: _gusiList,
                            value: _selectedGusi,
                            onChanged:
                            _selectedSido == null ? null : _onGusiChanged,
                            flex: 3),
                        _buildFilterDropdown(
                            hint: '평형',
                            items: _pyeongList,
                            value: _selectedPyeong,
                            onChanged: (_gusiList?.isEmpty ?? true)
                                ? null
                                : _onPyeongChanged,
                            flex: 3)
                      ]),
                  const SizedBox(height: 20),
                  _buildYearSlider(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // [수정] API 로딩 상태에 따라 분기 처리
          _isListLoading
              ? const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
              : SliverToBoxAdapter(
              child: Container(
                decoration:
                const BoxDecoration(color: Color(0xFF14B997)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5))
                      ]),
                  child: _apartmentList.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(child: Text('검색 결과가 없습니다.')),
                  )
                      : Column(children: [
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _apartmentList.length,
                      itemBuilder: (context, index) =>
                          _buildApartmentListItem(
                              item: _apartmentList[index],
                              index: index),
                      separatorBuilder: (context, index) =>
                      const Divider(
                          height: 1,
                          indent: 20,
                          endIndent: 20,
                          color: Color(0xFFEAEAEA)),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0),
                        child: TextButton(
                            onPressed: () {},
                            child: const Text('더보기',
                                style: TextStyle(
                                    color: Color(0xFF878787),
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w500)))),
                  ]),
                ),
              )),
        ],
      ),
      bottomNavigationBar: const CommonBottomNavigationBar(currentIndex: 1),
    );
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
    if (sido == null || gusi == null) return [];
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
      return dataList.map((item) {
        return '${item['area']} (${numberFormatter.format(item['cnt'])})';
      }).toList();
    }
    return [];
  }

  // Widget Builder methods
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
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: isLoading
                ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.0, color: Color(0xFF14B997))))
                : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: value,
                    hint: Text(hint, style: const TextStyle(color: Color(0xFF878787), fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF878787), size: 20),
                    onChanged: onChanged,
                    items: (items ?? [])
                        .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontSize: 13))))
                        .toList()))));
  }

  Widget _buildYearSlider() {
    const int startYear = 2006;
    final int endYear = DateTime.now().year + 1;
    final Set<int> labelYears = {startYear, endYear};
    for (int year = startYear; year <= endYear; year++) {
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
              max: endYear.toDouble(),
              divisions: (endYear - startYear),
              activeColor: const Color(0xFF0C493C),
              inactiveColor: Colors.white.withOpacity(0.5),
              labels: RangeLabels('${_currentRangeValues.start.round()}년', '${_currentRangeValues.end.round()}년'),
              onChangeEnd: (values) {
                _searchApartments();
              },
              onChanged: (RangeValues values) {
                if (values.start >= startYear && values.end <= endYear) {
                  setState(() => _currentRangeValues = values);
                }
              })),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: sortedLabelYears
                  .map((year) => Text("'${year.toString().substring(2)}년'", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)))
                  .toList()))
    ]);
  }

  // [수정] Map<String, dynamic>을 사용하도록 UI 복원
  Widget _buildApartmentListItem({required Map<String, dynamic> item, required int index}) {
    if (item['apt'] == null) {
      return const SizedBox.shrink();
    }

    final numberFormatter = NumberFormat('#,###');
    final String aptName = item['apt'];
    final int count = item['cnt'] as int? ?? 0;
    return InkWell(
        onTap: () => Navigator.pushNamed(context, '/apartment-details', arguments: {'name': aptName}),
        child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                  width: 24,
                  child: Text((index + 1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500))),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(aptName,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                height: 1.3)),
                        const SizedBox(height: 5),
                        Text('조회수: ${numberFormatter.format(count)}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500))
                      ])),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 22)
            ])));
  }
}