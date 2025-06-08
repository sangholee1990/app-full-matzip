import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

import 'screens/ai_recommendation_screen.dart';
import 'screens/apartment_data_screen.dart';
import 'screens/apartment_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//================================================================================
// 1. Main Application & Navigation Setup (기존 파일들을 통합하는 메인 파일)
// 파일 경로: lib/main.dart
//================================================================================
// void main() {
Future<void> main() async {
  // Flutter 엔진과 위젯 바인딩 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일의 변수들을 로드
  // await FlutterConfig.loadEnvVariables();
  // print(FlutterConfig.get('BASE_URL'));
  // print(FlutterConfig.get('BASE_URL'));
  // print(FlutterConfig.get('API_KEY'));

  await dotenv.load(fileName: ".env");
  print(dotenv.env['APP_NAME']);
  print(dotenv.env['BASE_URL']);
  print(dotenv.env['API_KEY']);

  runApp(const MatzipApp());
}

class MatzipApp extends StatelessWidget {
  const MatzipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MATZIP',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        primaryColor: const Color(0xFF14B997),
        fontFamily: 'Pretendard Variable',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF14B997),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard Variable'),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyMedium:
          TextStyle(fontFamily: 'Pretendard Variable', color: Colors.black87),
          labelLarge: TextStyle(fontFamily: 'Pretendard Variable'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/ai-recommendation-preview': (context) => const AiRecommendationScreen(),
        '/apartment-details': (context) => const ApartmentDetailScreen(),
        '/apartment-data': (context) => const ApartmentDataScreen(),
      },
    );
  }
}
