import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Webview를 사용하기 위하여 import
// import 'dart:io';

void main() {
  // 플러터 프레임워크가 앱을 실행할 준비가 될 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  // WebView 플랫폼 초기화
  // if (Platform.isAndroid) {
  //   WebView.platform = SurfaceAndroidWebView();
  // }

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
      home: const MyHomePage(title: 'Code Factory'),
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
  late final WebViewController controller;
    // WebViewController controller = WebViewController(); // WebViewController 생성

  @override
  void initState() {
    super.initState();

    controller = WebViewController(); // WebViewController 생성
    // WebViewController 설정
    controller.loadRequest(Uri.parse("https://blog.codefactory.ai"));
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.title),
        centerTitle: true, // 타이틀을 중앙에 배치
        actions: [
          // 홈 버튼 추가
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              controller.loadRequest(Uri.parse("https://blog.codefactory.ai"));
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: controller), // 웹뷰
    );
  }
}
