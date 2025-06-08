// import '20250104_mySecondPage.dart';
import 'package:first_flutter/20250104_bookDetailPage.dart';
import 'package:first_flutter/20250104_mySecondPage.dart';
import 'package:flutter/material.dart';

// flutter clean
// flutter pub get
// flutter run

/**
 * 메인
 */
void main() {
  runApp(const MyApp());
}

/**
 * 메인 화면
 */
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
      home: const MyHomePage(title: '1p 화면 이동'),
    );
  }
}

/**
 * 1p 화면
 */
class MyHomePage extends StatefulWidget {
  // 생성자
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void btnClick() {
    print("btnClick");
  }

  @override
  Widget build(BuildContext context) {
    // double imageWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.pinkAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "1번째 페이지입니다.",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    print("파이썬 + AI 책이 클릭되었습니다.");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BookDetailPage(
                              name: "파이썬 + AI",
                              url:
                                  "https://image.aladin.co.kr/product/34207/82/cover200/896088457x_1.jpg",
                            )));
                  },
                  child: Hero(
                    tag: "파이썬 + AI",
                    child: Image.network(
                        "https://image.aladin.co.kr/product/34207/82/cover200/896088457x_1.jpg"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("점프 투 파이썬 책이 클릭되었습니다.");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BookDetailPage(
                              name: "점프 투 파이썬",
                              url: "https://image.aladin.co.kr/product/34207/82/cover200/896088457x_1.jpg",
                            )));
                  },
                  child: Hero(
                    tag: "점프 투 파이썬",
                    child: Image.network(
                        "https://image.aladin.co.kr/product/31794/10/cover200/k362833219_1.jpg"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MySecondPage(
                          title: '2p 화면 이동',
                          id: 901119,
                          pw: '******',
                        )));
                // Navigator.pop(context);
              },
              child: Text(
                "2번째 페이지로 이동",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
