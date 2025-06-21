// lib/screens/local_screen.dart

import 'package:flutter/material.dart';
import 'package:app_full_matzip/widgets/common_bottom_nav_bar.dart';
import 'package:app_full_matzip/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  final MatzipApiService _apiService = MatzipApiService();

  List<Map<String, dynamic>>? _allRegionData;
  List<String>? _sidoList;
  List<String>? _gusiList;
  String? _selectedSido;
  String? _selectedGusi;

  List<Map<String, dynamic>> _topRisingApartments = [];
  bool _isDataLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
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
    final firstGusi =
    fetchedGusiList.isNotEmpty ? fetchedGusiList.first : null;

    setState(() {
      _sidoList = fetchedSidoList;
      _gusiList = fetchedGusiList;
      _selectedSido = firstSido;
      _selectedGusi = firstGusi;
    });

    await _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    if (_selectedSido == null || _selectedGusi == null) return;
    setState(() { _isDataLoading = true; });

    try {
      final sgg = '${_selectedSido!} ${_selectedGusi!.split(' (')[0]}';
      final responseData = await _apiService.fetchData(
        apiUrl: '/api/sel-statReal',
        apiParam: {'sgg': sgg},
      );
      if (mounted && responseData['data'] is List) {
        setState(() {
          _topRisingApartments = (responseData['data'] as List).cast<Map<String, dynamic>>();
        });
      }
    } finally {
      if (mounted) {
        setState(() { _isDataLoading = false; });
      }
    }
  }

  // [신규] PDF 문서를 생성하고 출력/저장하는 함수
  Future<void> _printReport() async {
    final doc = pw.Document();
    // PDF에서 한글을 지원하기 위해 폰트 로드
    // final font = await PdfGoogleFonts.notoSansKrRegular();
    // final boldFont = await PdfGoogleFonts.notoSansKrBold();
    final fontData = await rootBundle.load("assets/fonts/NotoSansKr-Regular.ttf");
    final boldFontData = await rootBundle.load("assets/fonts/NotoSansKr-Bold.ttf");
    final font = pw.Font.ttf(fontData);
    final boldFont = pw.Font.ttf(boldFontData);

    // 데이터를 테이블 형태로 변환하는 헬퍼 함수
    pw.Table _buildPdfTable(String title, List<Map<String, dynamic>> items, String key) {
      return pw.Table.fromTextArray(
        headerStyle: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold, fontSize: 10),
        cellStyle: pw.TextStyle(font: font, fontSize: 9),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
        headers: ['아파트', '동', '평수', '이전가격', '현재가격', '변화율(%)'],
        data: items.where((item) => item['GRP'] == key).map((item) {
          final krwFormat = NumberFormat.compact(locale: 'ko');
          return [
            item['APT'],
            item['DONG'],
            item['AREA'],
            krwFormat.format(item['PREV_AVG_AMOUNT']),
            krwFormat.format(item['CURR_AVG_AMOUNT']),
            (item['RATE'] as num).toStringAsFixed(2),
          ];
        }).toList(),
      );
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('로컬 데이터 분석 보고서', style: pw.TextStyle(font: boldFont, fontSize: 24)),
            ),
            pw.Paragraph(
                text: '선택 지역: ${_selectedSido ?? ''} ${_selectedGusi?.split(' (')[0] ?? ''}',
                style: pw.TextStyle(font: font, fontSize: 12)
            ),
            pw.SizedBox(height: 20),
            pw.Text('최고상승 거래가 아파트', style: pw.TextStyle(font: boldFont, fontSize: 16)),
            pw.SizedBox(height: 10),
            _buildPdfTable('최고상승', _topRisingApartments, "최고상승"),
            pw.SizedBox(height: 20),
            pw.Text('최고하락 거래가 아파트', style: pw.TextStyle(font: boldFont, fontSize: 16)),
            pw.SizedBox(height: 10),
            _buildPdfTable('최고하락', _topRisingApartments, "최고하락"),
          ];
        },
      ),
    );

    // PDF 미리보기 및 저장/인쇄 화면 표시
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'matzip_local_report.pdf',
    );
  }

  void _onSidoChanged(String? newValue) async {
    if (newValue == null || newValue == _selectedSido) return;
    final newGusiList = _getGusiListForSido(newValue);
    final firstGusi = newGusiList.isNotEmpty ? newGusiList.first : null;
    setState(() {
      _selectedSido = newValue;
      _gusiList = newGusiList;
      _selectedGusi = firstGusi;
    });
    await _fetchChartData();
  }

  void _onGusiChanged(String? newValue) async {
    if (newValue == null || newValue == _selectedGusi) return;
    setState(() {
      _selectedGusi = newValue;
    });
    await _fetchChartData();
  }

  List<String> _getGusiListForSido(String sido) {
    if (_allRegionData == null) return [];
    final numberFormatter = NumberFormat('#,###');
    final gusiList = _allRegionData!
        .where((region) => region['sgg'].toString().startsWith(sido))
        .map((region) {
      final parts = region['sgg'].toString().split(' ');
      final gusi = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      final count = region['cnt'] as int? ?? 0;
      return '$gusi (${numberFormatter.format(count)})';
    }).where((gusi) => gusi.isNotEmpty).toList();
    gusiList.sort();
    return gusiList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: CustomScrollView(
            slivers: [
              _buildHeader(),
              _ContentBody(
                isDataLoading: _isDataLoading,
                topRisingApartments: _topRisingApartments,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      // ...
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              _buildTopBar(), _buildTitle(), _buildFilters(),
              const Spacer(),
              _buildReportButton(), // [수정] 콜백 연결을 위해 context 전달
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 35,
        child: ElevatedButton(
          onPressed: _isDataLoading ? null : _printReport, // [수정] _printReport 함수 연결, 로딩 중 비활성화
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14B997), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: _isDataLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('보고서 출력', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('images/logo_matzip_white.png', width: 92, height: 27),
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

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('로컬 데이터', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(child: _buildFilterDropdown(hint: '시도', items: _sidoList, value: _selectedSido, onChanged: _onSidoChanged)),
          const SizedBox(width: 8),
          Expanded(child: _buildFilterDropdown(hint: '시/구', items: _gusiList, value: _selectedGusi, onChanged: _onGusiChanged)),
          const SizedBox(width: 8),
          SizedBox(
            width: 65,
            height: 35,
            child: ElevatedButton(
              onPressed: _fetchChartData,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14B997), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('검색'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({required String hint, required List<String>? items, required String? value, required ValueChanged<String?>? onChanged}) {
    bool isLoading = items == null;
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: isLoading
          ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))
          : DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true, value: value,
          hint: Text(hint, style: const TextStyle(color: Color(0xFF878787), fontSize: 14, fontWeight: FontWeight.w600)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF878787)),
          onChanged: onChanged,
          items: items?.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontSize: 14)))).toList(),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAllRegionData() async {
    final responseData = await _apiService.fetchData(apiUrl: '/api/sel-statRealSearchBySgg', apiParam: {'page': 1, 'limit': '999', 'sort': 'cnt|desc'});
    if (responseData.containsKey('data') && responseData['data'] is List) {
      return (responseData['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }
}

class _ContentBody extends StatelessWidget {
  final bool isDataLoading;
  final List<Map<String, dynamic>> topRisingApartments;

  const _ContentBody({
    required this.isDataLoading,
    required this.topRisingApartments,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildSection(
              title: '최고 거래가 아파트',
              child: isDataLoading
                  ? _buildLoadingIndicator()
                  : _buildHighestPriceChart(topRisingApartments, "최고상승"),
            ),
            _buildSection(
              title: '최저 거래가 아파트',
              child: isDataLoading
                  ? _buildLoadingIndicator()
                  : _buildHighestPriceChart(topRisingApartments, "최고하락"),
            ),
          ],
        ),
      ),
    );
  }

  // [수정] 차트 빌더 메서드: X축 라벨과 툴팁 문제 해결
  Widget _buildHighestPriceChart(List<Map<String, dynamic>> items, String key) {
    if (items.isEmpty) return _buildChartPlaceholder(message: '데이터가 없습니다.');

    final chartData = items
        .where((item) => item['GRP'] == key)
        .toList();

    if (key == '최고상승') {
      chartData.sort((a, b) => (b['CURR_AVG_AMOUNT'] as num).compareTo(a['CURR_AVG_AMOUNT'] as num));
    } else if (key == '최고하락') {
      chartData.sort((a, b) => (a['CURR_AVG_AMOUNT'] as num).compareTo(b['CURR_AVG_AMOUNT'] as num));
    }

    final top10Data = chartData.take(10).toList();
    final maxValue = top10Data.isNotEmpty ? (top10Data.first['CURR_AVG_AMOUNT'] as num).toDouble() : 0;

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  maxContentWidth: 200, // [수정] 툴팁 너비 확보
                  getTooltipColor: (_) => Colors.black87,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final item = top10Data[group.x.toInt()];
                    // [수정] 괄호 앞에서 줄바꿈하여 툴팁 글자 잘림 방지
                    // final aptName = (item['APT'] as String? ?? '').replaceAll('(', '\n(');
                    final aptName = item['APT'];
                    const tooltipValueStyle = TextStyle(color: Color(0xFF14B997), fontWeight: FontWeight.bold, fontSize: 11);

                    return BarTooltipItem(
                        '$aptName',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12),
                        textAlign: TextAlign.left,
                        children: [
                          const TextSpan(
                            text: '\n거래금액 ',
                            style: tooltipValueStyle,
                          ),
                          TextSpan(
                            text: _formatCurrency(rod.toY),
                            style: tooltipValueStyle,
                          ),
                          const TextSpan(
                            text: '\n수익률 ',
                            style: tooltipValueStyle,
                          ),
                          TextSpan(
                            text: "${double.tryParse(item['RATE'].toString())?.toStringAsFixed(2) ?? 'NA'}%",
                            style: tooltipValueStyle,
                          )
                        ],
                    );
                  }
              )
          ),
          titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value == 0 && meta.min != 0) return const SizedBox.shrink();
                        return Text(_formatCurrency(value), style: const TextStyle(fontSize: 10, color: Colors.grey));
                      }
                  )
              ),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= top10Data.length) return const SizedBox.shrink();
                        final aptName = top10Data[index]['APT']?.toString() ?? '';
                        final displayName = aptName.split('(').first;

                        // [수정] Transform.rotate와 alignment를 사용하여 라벨 정렬
                        return Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Transform.rotate(
                            angle: -math.pi / 4,
                            alignment: Alignment.topCenter,
                            child: Text(
                              displayName.length > 10 ? '${displayName.substring(0, 10)}..' : displayName,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                  )
              )
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[200]!, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: top10Data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isTop = (item['CURR_AVG_AMOUNT'] as num).toDouble() == maxValue;
            return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: (item['CURR_AVG_AMOUNT'] as num).toDouble(),
                    color: isTop ? const Color(0xFF14B997) : const Color(0xFFB2DED5),
                    width: 12,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  )
                ]
            );
          }).toList(),
        ),
      ),
    );
  }

  // Other helper methods...
  Widget _buildLoadingIndicator() => const SizedBox(height: 250, child: Center(child: CircularProgressIndicator()));

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder({double height = 200, String message = 'Chart Area'}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!)),
      child: Center(
        child: Text(message, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 100000000) {
      return '${(value / 100000000).toStringAsFixed(1)}억';
    }
    return NumberFormat.compact(locale: 'ko').format(value);
  }
}