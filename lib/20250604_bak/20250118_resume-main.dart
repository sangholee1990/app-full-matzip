import 'package:flutter/material.dart';

// 웹프로그램을 개발하기 위한 패키지 import
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// 프로젝트와 연락처 페이지 import
import '20250118_resume-projects.dart';
import '20250118_resume-contact.dart';
import '20250118_resume-comAppBar.dart';

void main() {
  usePathUrlStrategy();     // 웹방식의 라우팅을 사용하도록 설정
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /* 플러터 프레임워크가 제공한 코드를 주석 처리하고 웹프로그래밍할 때의 라우팅 방식으로 변경
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
    */
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (routeSettings) {
        // ?? 연산자는 앞에 지정된 값이 Null인 경우에 뒤의 값을 사용하도록 하는 역할을 함
        final uri = Uri.parse(routeSettings.name ?? '/');
        final path = uri.path;
        Widget page;
        switch (path) {
          case "/":
            page = MyHomePage();
          case "/projects":
            page = ProjectsPage();
          case "/contact":
            page = ContactPage();
          default:
            return null;
        }
        return PageRouteBuilder(
          settings: routeSettings,
          pageBuilder: (_, __, ___) => page,
          transitionDuration: Duration.zero,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  /* title 속성을 넘기지 않도록 코드를 수정
  const MyHomePage({super.key, required this.title});

  final String title;
  */
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /* 플러터 프레임워크가 제공한 코드를 주석 처리하고 웹의 홈페이지로 변경
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildCommonAppBar(),
      // appBar: buildCommonAppBar(NavigationPages.home),
      appBar: buildCommonAppBar(context, NavigationPages.home),
      body: Center(
        child: Text("홈 페이지"),
      ),
    );
  }
}