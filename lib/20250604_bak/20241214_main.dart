import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: '나의 첫번째 Flutter 앱'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // _counter = _counter + 2;
      _counter += 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 너비
    double imageWidth = MediaQuery.of(context).size.width / 5;
    double imageHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // child: Row(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              '팀 이름: [Flutter] 쉽게 배우는 플러터 앱 개발 실무',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),

            // const SizedBox(height: 10),

            const Text(
              '수강생: 이상호',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),

            // const SizedBox(height: 20),

            Container(
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.yellow,

              // margin 설정
              // margin: EdgeInsets.all(50),
              // margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              // margin: EdgeInsets.only(right: 10, bottom: 40),
              // margin: EdgeInsets.fromLTRB(10.0, 20.0, 30.0, 40.0),

              // padding 설정
              // padding: EdgeInsets.all(50),
              // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              // padding: EdgeInsets.only(right: 10, bottom: 40),
              // padding: EdgeInsets.fromLTRB(10.0, 20.0, 30.0, 40.0),

              child: const Text(
                'You have pushed the button this many times: (변경)',
                style: TextStyle(
                  // color: Colors.pink,
                  color: Colors.black,
                  fontSize: 18,
                  // backgroundColor: Colors.yellow,
                  fontWeight: FontWeight.w500,
                  // fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // const SizedBox(height: 20),

            // const Text(
            //   '안용제 - 재미있으면 좋겠습니다.',
            // ),
            Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                // borderRadius: BorderRadius.horizontal(left: Radius.zero, right: Radius.circular(100)),
                // borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(100)),
                // borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),

                border: Border.all(
                  color: Colors.white,
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.75),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      // color: Colors.blueAccent,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            // const SizedBox(height: 20),

            Icon(
              Icons.access_alarm,
              color: Colors.orange,
              size: 80,
            ),

            // const SizedBox(height: 20),

            // Image.asset("images/점프 투 파이썬.jpg"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가로축 중앙 정렬
              crossAxisAlignment: CrossAxisAlignment.center, // 세로축 중앙 정렬
              children: [
                Column(
                  children: [
                    Image.asset(
                      "images/k172737777_2.jpg",
                      width: imageWidth,
                      // width: 100,
                      // height: 50,
                      // fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5), // 이미지와 제목 간 간격
                    const Text(
                      "파일 기반 이미지 조회",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Image.network(
                      "https://image.aladin.co.kr/product/29423/74/cover200/k622837324_2.jpg",
                      width: imageWidth,
                      // width: 100,
                    ),
                    const SizedBox(height: 5), // 이미지와 제목 간 간격
                    const Text(
                      "네트워크 기반 이미지 조회",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Image.network(
                      "https://image.aladin.co.kr/product/25694/59/cover200/k472736561_1.jpg",
                      width: imageWidth,
                      // width: 100,
                    ),
                    const SizedBox(height: 5), // 이미지와 제목 간 간격
                    const Text(
                      "네트워크 기반 이미지 조회",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),


            Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 150, height: 150, color: Colors.red),
                Container(width: 100, height: 100, color: Colors.yellow),
                Container(width: 70, height: 70, color: Colors.green),
                Container(width: 50, height: 50, color: Colors.blue),

                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 60,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
