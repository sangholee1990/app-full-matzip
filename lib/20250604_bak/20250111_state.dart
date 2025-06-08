import 'package:first_flutter/20250111_imgListView.dart';
import 'package:first_flutter/20250111_myThirdPage.dart';
import 'package:first_flutter/20250111_mySecondPage.dart';
import 'package:first_flutter/20250111_simpleListView.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter/20250111_simpleListViewDetail.dart';

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
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '20250111 상태 관리'),
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
  int _selIdx = 0;

  _onBotNavTap(idx) {
    print("[CHECK] idx : $idx");

    setState(() {
      _selIdx = idx;
    });
  }

  var pageList = [
    SimpleListViewDetail(title: '2p 화면 이동', id: 901119, pw: '******'),
    ImgListviewPage(),
    SimpleListviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      body: pageList[_selIdx],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selIdx,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: _onBotNavTap,
        items: [
          BottomNavigationBarItem(
            // icon: Icon(Icons.looks_one, color: Colors.blue),
            icon: Icon(Icons.looks_one),
            label: "SimpleListViewDetail",
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.looks_two, color: Colors.blue),
            icon: Icon(Icons.photo_library),
            label: "ImgListviewPage",
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.looks_two, color: Colors.blue),
            icon: Icon(Icons.list),
            label: "SimpleListviewPage",
          ),
        ],
      ),
    );
  }
}
