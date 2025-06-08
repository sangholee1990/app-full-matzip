import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Intro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: 'MalgunGothic',
      ),
      home: const MyHomePage(title: '가족 소개'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Timer 설정 (2초 간격)
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        // 위젯이 활성 상태인지 확인
        setState(() {
          if (_controller.status == AnimationStatus.completed) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/family-back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "4인 가족",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MalgunGothic',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFamilyMember(
                    '아버지',
                    'images/free-icon-father.png',
                  ),
                  const SizedBox(width: 20),
                  _buildFamilyMember(
                    '어머니',
                    'images/free-icon-mother.png',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFamilyMember(
                    '첫째 누나',
                    'images/free-icon-woman.png',
                  ),
                  const SizedBox(width: 20),
                  _buildFamilyMember(
                    '둘째 나',
                    'images/free-icon-man.png',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Text(
                      "가족과 함께\n보내는 즐거운 시간 😊",
                      textAlign: TextAlign.center, // 텍스트 내부 줄바꿈 중앙 정렬
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Hmfmpyun',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyMember(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          // backgroundImage: NetworkImage(imageUrl),
          backgroundImage: AssetImage(imageUrl),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'MalgunGothic',
          ),
        ),
      ],
    );
  }
}
