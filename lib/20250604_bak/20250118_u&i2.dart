import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
          fontFamily: "sunflower", // 기본 글꼴 지정
          textTheme: TextTheme(
            // Text Theme 정의
            headlineLarge: TextStyle(
              // headline1, headine2, bodyText1, bodyText2 등
              color: Colors.white, // 책에 있는 속성은 Deprecated됨
              fontSize: 80,
              fontWeight: FontWeight.bold,
              fontFamily: "parisienne",
            ),
            headlineMedium: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
            bodyMedium: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          )),
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
  // DateTime firstDay = DateTime(2021, 11, 23); // 처음만난날 초기값 지정
  DateTime firstDay = DateTime(2024, 12, 23);
  DateTime today = DateTime.now();
  int dayCount = 0;

  @override
  void initState() {
    super.initState();

    dayCount = today.difference(firstDay).inDays + 1; // D+몇일째 초기값 지정
  }

  onHeartPressed() {
    showCupertinoDialog(
        // 쿠퍼티노 다이어로그 실행
        context: context, // 보여줄 다이어로그 빌드
        // Stateful Widget에서는 context 변수 정의없이 사용
        barrierDismissible: true, // 날짜 다이어로그 밖을 선택할 때 닫도록 지정
        builder: (context) {
          return Align(
            // 하단 중앙부로 위치 지정
            alignment: Alignment.bottomCenter,
            child: Container(
              // 색상과 크기 지정
              color: Colors.white,
              height: 300,
              child: CupertinoDatePicker(
                  // 날짜 선택하는 다이어로그
                  mode: CupertinoDatePickerMode.date, // 날짜 형식으로 입력 받기
                  initialDateTime: firstDay,
                  onDateTimeChanged: (date) {
                    setState(() {
                      firstDay = date; // dayCount 변수를 사용하여 로직을 직관적으로 변경
                      dayCount = today.difference(firstDay).inDays + 1;
                    });
                  }),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme; // 사용자 정의한 Text Theme 가져옴

    return Scaffold(
      backgroundColor: Colors.pink[100], // 색상 팔레트 50(연함)~900(진함)까지
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // 위 아래 끝에 배치
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Container의 width: double.infinity와 동일
          children: <Widget>[
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  "U&I",
                  style: textTheme.headlineLarge, // 사용자 정의 Text Theme 적용
                ),
                SizedBox(height: 16),
                Text(
                  "우리 처음 만난 날",
                  style: textTheme.bodyLarge, // 사용자 정의 Text Theme 적용
                ),
                Text(
                  firstDay.toString().substring(0, 10),
                  style: textTheme.bodyMedium, // 사용자 정의 Text Theme 적용
                ),
                SizedBox(height: 16),
                IconButton(
                  iconSize: 60,
                  // onPressed: () {},
                  onPressed: onHeartPressed,
                  icon: Icon(
                    color: Colors.red,
                    Icons.favorite,
                  ),
                ),
                Text(
                  "D+${dayCount}",
                  style: textTheme.headlineMedium, // 사용자 정의 Text Theme 적용
                ),
              ],
            ),
            Expanded(
              child: Image.asset(
                "images/middle_image.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
