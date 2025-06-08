import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const DynamicScreen(screenKey: 'splash'),
    );
  }
}

class ScreenConfig {
  final Color backgroundColor;
  final String imagePath;
  final double imageWidthRatio;
  final double imageHeightRatio;
  final Color loadingIndicatorColor;

  ScreenConfig({
    required this.backgroundColor,
    required this.imagePath,
    required this.imageWidthRatio,
    required this.imageHeightRatio,
    required this.loadingIndicatorColor,
  });

  factory ScreenConfig.fromJson(Map<String, dynamic> json) {
    return ScreenConfig(
      backgroundColor: _hexToColor(json['backgroundColor']),
      imagePath: json['imagePath'],
      imageWidthRatio: json['imageWidthRatio'],
      imageHeightRatio: json['imageHeightRatio'],
      loadingIndicatorColor: _hexToColor(json['loadingIndicatorColor']),
    );
  }

  static Color _hexToColor(String hexCode) {
    final hex = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

class DynamicScreen extends StatefulWidget {
  final String screenKey;

  const DynamicScreen({required this.screenKey, super.key});

  @override
  _DynamicScreenState createState() => _DynamicScreenState();
}

class _DynamicScreenState extends State<DynamicScreen> {
  Map<String, dynamic>? screenConfig;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      // JSON 파일을 rootBundle에서 로드
      final jsonString = await rootBundle.loadString('json/dyn_splash_screen.json');
      final jsonData = json.decode(jsonString);
      setState(() {
        screenConfig = jsonData[widget.screenKey];
      });
    } catch (e) {
      print('Error loading config: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (screenConfig == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final config = ScreenConfig.fromJson(screenConfig!);

    // 화면 너비와 높이를 기반으로 이미지 크기 계산
    double imageWidth = MediaQuery.of(context).size.width * config.imageWidthRatio;
    double imageHeight = MediaQuery.of(context).size.height * config.imageHeightRatio;

    return Scaffold(
      backgroundColor: config.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              config.imagePath,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              color: config.loadingIndicatorColor,
            ),
          ],
        ),
      ),
    );
  }
}
