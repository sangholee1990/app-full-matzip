import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

//================================================================================
// 2. Splash Screen (Iphone13Mini1.dart 기반)
// 파일 경로: lib/screens/splash_screen.dart
//================================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            () => Navigator.of(context).pushReplacementNamed('/home'));
  }

  static const TextStyle _matzipTitleStyle = TextStyle(color: Colors.white, fontSize: 64, fontFamily: 'Pretendard', fontWeight: FontWeight.w900, letterSpacing: 1.2,);
  static const TextStyle _subtitleStyle = TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Pretendard', fontWeight: FontWeight.w600, height: 1.78, letterSpacing: -0.45,);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF076653), Color(0xFF0C342C)])))),
            Positioned(left: -72, top: -111, child: Container(width: 347, height: 923, decoration: const ShapeDecoration(gradient: LinearGradient(begin: Alignment(0.50, -0.00), end: Alignment(0.50, 1.00), colors: [Color(0xFF1EA78A), Color(0xFF0C4136)],), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(173.50), topRight: Radius.circular(173.50),),),),),),
            Positioned(left: 142, top: 42, child: Container(width: 347, height: 858, decoration: const ShapeDecoration(gradient: LinearGradient(begin: Alignment(0.50, -0.00), end: Alignment(0.50, 1.00), colors: [Color(0xFF14B997), Color(0xFF095344)],), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(173.50), topRight: Radius.circular(173.50),),),),),),
            Positioned(left: -38, top: 319, child: Container(width: 278, height: 493, decoration: const ShapeDecoration(gradient: LinearGradient(begin: Alignment(0.95, 0.06), end: Alignment(0.10, 1.00), colors: [Color(0xFF0B4438), Color(0xFF137963), Color(0xFF1BAA8B)]), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(139), topRight: Radius.circular(139),),),),),),
            Positioned(left: 190, top: 516, child: Container(width: 233, height: 351, decoration: const ShapeDecoration(gradient: LinearGradient(begin: Alignment(0.50, -0.00), end: Alignment(0.50, 1.00), colors: [Color(0xFF076653), Color(0xFF0C342C)],), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(116.50), topRight: Radius.circular(116.50),),),),),),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('MATZIP', textAlign: TextAlign.center, style: _matzipTitleStyle),
                  const SizedBox(height: 28),
                  SizedBox(width: 248, height: 96, child: const Text('AI 매물 추천\n아파트 빅데이터 보고서\n아파트 미래가격 예측', textAlign: TextAlign.center, style: _subtitleStyle)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}