import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// flutter clean
// flutter pub get
// flutter run

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
      home: const MyHomePage(title: '제스처 위젯'),
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
  void btnClick() {
    print("btnClick");
  }

  void iconClick() {
    print("iconClick");
  }

  void imgClick() {
    print("imgClick");
  }

  void floatClick() {
    print("floatClick");
  }

  @override
  Widget build(BuildContext context) {
    // double imageWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // child: Row(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            Tooltip(
              message: "btnClick",
              child: ElevatedButton(
                onPressed: btnClick,
                child: Text("Elevated Button"),
              ),
            ),
            IconButton(
              onPressed: iconClick,
              icon: Icon(
                Icons.add_alarm,
                color: Colors.orange,
                size: 80,
              ),
              tooltip: 'IconButton',
            ),
            GestureDetector(
              onTap: imgClick,
              child: Tooltip(
                message: "imgClick",
                child: Image.network(
                  "https://image.aladin.co.kr/product/29423/74/cover200/k622837324_2.jpg",
                ),
              ),
            ),
            Text(
              "맑은 고딕",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'MalgunGothic',
              ),
            ),
            Text(
              "휴면 편지체",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Hmfmpyun',
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: floatClick,
        tooltip: 'floatingActionButton',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
