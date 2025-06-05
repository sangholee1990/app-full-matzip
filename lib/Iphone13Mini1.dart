import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

// 생성 도구: https://www.figma.com/community/plugin/842128343887142055/
// 개선된 버전
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const Scaffold(
        body: Iphone13Mini1(), // 단일 전체 화면 항목
      ),
      debugShowCheckedModeBanner: false, // 선택 사항: 디버그 배너 숨기기
    );
  }
}

class Iphone13Mini1 extends StatelessWidget {
  const Iphone13Mini1({super.key});

  // 재사용성과 코드 정리를 위해 텍스트 스타일을 상수로 정의
  static const TextStyle _matzipTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 64,
    fontFamily: 'Pretendard', // 중요: pubspec.yaml에 이 폰트가 설정되어 있고, assets 폴더에 폰트 파일이 포함되어 있는지 확인하세요.
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
  );

  static const TextStyle _subtitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'Pretendard', // 중요: pubspec.yaml에 이 폰트가 설정되어 있고, assets 폴더에 폰트 파일이 포함되어 있는지 확인하세요.
    fontWeight: FontWeight.w600,
    height: 1.78, // 줄 높이
    letterSpacing: -0.45,
  );

  @override
  Widget build(BuildContext context) {
    // MediaQuery를 사용하여 메인 컨테이너가 화면 크기에 반응하도록 설정
    final screenSize = MediaQuery.of(context).size;

    return Container(
      // 화면 크기 사용
      width: screenSize.width,
      height: screenSize.height,
      clipBehavior: Clip.antiAlias, // 자식 위젯이 경계를 넘어갈 때 자르기
      decoration: const BoxDecoration(), // 배경은 그라데이션으로 채워지므로 별도 색상 지정 안 함
      child: Stack(
        children: [
          // 배경 그라데이션 레이어 1 (화면 전체 채우기)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, -0.00), // Alignment.topCenter와 동일
                  end: Alignment(0.50, 1.00),   // Alignment.bottomCenter와 동일
                  colors: [Color(0xFF076653), Color(0xFF0C342C)],
                ),
              ),
            ),
          ),

          // 장식용 그라데이션 도형 1
          Positioned(
            left: -72,
            top: -111,
            child: Container(
              width: 347,
              height: 923,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [Color(0xFF1EA78A), Color(0xFF0C4136)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(173.50),
                    topRight: Radius.circular(173.50),
                  ),
                ),
              ),
            ),
          ),

          // 장식용 그라데이션 도형 2
          Positioned(
            left: 142,
            top: 42,
            child: Container(
              width: 347,
              height: 858,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [Color(0xFF14B997), Color(0xFF095344)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(173.50),
                    topRight: Radius.circular(173.50),
                  ),
                ),
              ),
            ),
          ),

          // 장식용 그라데이션 도형 3
          Positioned(
            left: -38,
            top: 319,
            child: Container(
              width: 278,
              height: 493,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.95, 0.06),
                  end: Alignment(0.10, 1.00),
                  colors: [
                    Color(0xFF0B4438),
                    Color(0xFF137963),
                    Color(0xFF1BAA8B)
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(139),
                    topRight: Radius.circular(139),
                  ),
                ),
              ),
            ),
          ),

          // 장식용 그라데이션 도형 4
          Positioned(
            left: 190,
            top: 516,
            child: Container(
              width: 233,
              height: 351,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [Color(0xFF076653), Color(0xFF0C342C)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(116.50),
                    topRight: Radius.circular(116.50),
                  ),
                ),
              ),
            ),
          ),

          // --- 개선된 텍스트 레이아웃 ---
          // 화면 중앙에 텍스트 콘텐츠(제목, 부제목)를 배치합니다.
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Column 내의 요소들을 수직으로 중앙 정렬합니다.
              children: [
                // "MATZIP" 제목 텍스트
                const Text(
                  'MATZIP', // 브랜드 이름으로 간주하여 영어 유지
                  textAlign: TextAlign.center,
                  style: _matzipTitleStyle,
                ),

                // 제목과 부제목 사이의 간격 (원본 Figma의 시각적 간격을 유지하도록 조정)
                const SizedBox(height: 28),

                // 부제목 텍스트
                // 원본 Figma 디자인에서 부제목에 고정된 너비와 높이가 있는 것처럼 보이므로 SizedBox로 감싸서 유지합니다.
                // 텍스트가 이 영역을 벗어나지 않도록 주의해야 합니다.
                SizedBox(
                  width: 248, // 원본 Figma 값
                  height: 96, // 원본 Figma 값 (3줄 텍스트에 적합한 높이)
                  child: const Text(
                    'AI 매물 추천\n아파트 빅데이터 보고서\n아파트 미래가격 예측', // 이미 한국어
                    textAlign: TextAlign.center,
                    style: _subtitleStyle,
                  ),
                ),
              ],
            ),
          ),
          // 참고: 원본 코드의 빈 상태 표시줄 영역을 위한 Positioned 위젯은
          // 실제 기능이 없고 Figma 변환 과정에서 생성된 것으로 보여 제거했습니다.
          // 상태 표시줄 영역을 고려해야 한다면, Scaffold의 body를 SafeArea로 감싸거나,
          // SystemChrome을 사용하여 상태 표시줄 스타일을 직접 제어하는 것을 고려할 수 있습니다.
        ],
      ),
    );
  }
}
