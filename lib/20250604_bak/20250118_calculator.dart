import 'package:flutter/material.dart';
import '20250118_calculator_page1.dart';
import '20250118_calculator_page2.dart';
import '20250118_calculator_page3.dart';
import '20250118_calculator_page4.dart';

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
  var pages = [
    CalculatorPage1(),
    CalculatorPage2(),
    CalculatorPage3(),
    CalculatorPage4(),
  ];

  int _selectedNaviIndex = 0;

  _onBottomNavigationItemTapped(index) {
    setState(() {
      _selectedNaviIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: pages[_selectedNaviIndex],
      bottomNavigationBar: BottomNavigationBar(
        //showSelectedLabels: false,
        //showUnselectedLabels: false,

        currentIndex: _selectedNaviIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: _onBottomNavigationItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_one),
            label: "Calculator1",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two),
            label: "Calculator2",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3),
            label: "Calculator3",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_4),
            label: "Calculator4",
          ),
        ],
      ),
    );
  }
}

