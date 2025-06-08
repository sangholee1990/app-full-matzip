import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChrome 사용을 위해 import
import 'dart:async';                    // Timer 사용을 위해 import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController(); // Page Controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(Duration(seconds: 3), (timer) {
      // 3초마다 실행
      var currPage = pageController.page;
      print(currPage);

      if (currPage != 4)                                         // 마지막 페이지가 아니면
        pageController.nextPage(
            duration: Duration(seconds: 1), curve: Curves.ease); // 다음 페이지로 이동
      else                                                       // 마지막 페이지이면
        pageController.jumpToPage(0);                            // 첫 페이지로 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    // 상태바를 흰색으로 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: PageView(
        // 5장의 이미지로 구성된 PageView
        // 스와이프는 자동으로 발생함
          controller: pageController, // pageController 등록
          children: [
            // 229~231 페이지의 BoxFit 그림 설명 참조
            Image.asset("images/image_1.jpeg", fit: BoxFit.cover),
            Image.asset("images/image_2.jpeg", fit: BoxFit.cover),
            Image.asset("images/image_3.jpeg", fit: BoxFit.cover),
            Image.asset("images/image_4.jpeg", fit: BoxFit.cover),
            Image.asset("images/image_5.jpeg", fit: BoxFit.cover)
          ]),
    );
  }
}