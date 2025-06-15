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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dot_json_env/flutter_dot_json_env.dart';
import 'dart:convert';

//================================================================================
// 1. Main Application & Navigation Setup (기존 파일들을 통합하는 메인 파일)
// 파일 경로: lib/main.dart
//================================================================================
// void main() {
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "config/local.env");
  print(dotenv.get('BASE_URL', fallback: null));
  print(dotenv.get('API_KEY', fallback: null));

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
