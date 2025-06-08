import 'package:first_flutter/20250104_memberDetailPage.dart';
import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: '[기본] 가족 소개'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          title,
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
                    context,
                    '아버지',
                    'images/free-icon-father.png',
                    '가족을 이끄는 든든한 리더입니다.',
                    'images/father-back.png',
                  ),
                  const SizedBox(width: 20),
                  _buildFamilyMember(
                    context,
                    '어머니',
                    'images/free-icon-mother.png',
                    '가족을 따뜻하게 보살피는 분입니다.',
                    'images/mother-back.png',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFamilyMember(
                    context,
                    '첫째 누나',
                    'images/free-icon-woman.png',
                    '밝고 활기찬 에너지를 가진 분입니다.',
                    'images/woman-back.png',
                  ),
                  const SizedBox(width: 20),
                  _buildFamilyMember(
                    context,
                    '둘째 나',
                    'images/free-icon-man.png',
                    '모험을 좋아하는 가족의 막내입니다.',
                    'images/man-back.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyMember(
      BuildContext context, String name, String imageUrl, String desc, String backUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemberDetailPage(
              name: name,
              imageUrl: imageUrl,
              desc: desc,
              backUrl: backUrl,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: name,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imageUrl),
            ),
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
      ),
    );
  }
}