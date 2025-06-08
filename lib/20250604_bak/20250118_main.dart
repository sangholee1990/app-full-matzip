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
  TextEditingController textEditingController =
      TextEditingController(); // 콘트롤러 추가
  bool contentLoaded = false;
  // var selectedElement = "요소2";
  var selectedElement = "2번째 항목";

  var strList = [
    "1번째 항목",
    "2번째 항목",
    "3번째 항목",
    "4번째 항목",
    "5번째 항목",
    "6번째 항목",
    "7번째 항목",
    "8번째 항목",
    "9번째 항목",
    "10번째 항목",
    "11번째 항목",
    "12번째 항목",
    "13번째 항목",
    "14번째 항목",
    "15번째 항목",
    "16번째 항목",
    "17번째 항목",
    "18번째 항목",
    "19번째 항목",
    "20번째 항목"
  ];

  @override
  void initState() {
    super.initState();
    textEditingController.text = "초기값";
  }

  void _incrementCounter() {
    setState(() {
      // _counter = _counter + 2;
      _counter += 2;
      contentLoaded = true;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("[CHECK] build 함수 수행");
    // 화면 너비
    // double imageWidth = MediaQuery.of(context).size.width / 5;
    double imageHeight = MediaQuery.of(context).size.height;
    double imageWidth = (MediaQuery.of(context).size.width - 30) / 3;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // backgroundColor: Colors.green,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Center(
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

                // TextField(
                //   decoration: InputDecoration(
                //     labelText: "필드이름",
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                //
                // SizedBox(       // SizedBox Widget으로
                //   width: 200,   // 입력필드의 길이를 200 논리적 픽셀로 지정
                //   child: TextField(
                //     decoration: InputDecoration(
                //       labelText: "필드이름",
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                // ),
                //
                // SizedBox(
                //   width: 200,
                //   child: TextField(
                //     controller: textEditingController,   // TextField와 Controller 연결
                //     decoration: InputDecoration(
                //       labelText: "필드이름",
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                // ),

                // SizedBox(
                //   height: 200,
                //   child: ListView.builder(
                //       itemCount: strList.length,
                //       itemBuilder: (context, index) {
                //         return GestureDetector(
                //           onTap: () {
                //             // 오류 발생을 예방하기 위하여 주석 처리
                //             // Navigator.of(context).push(
                //             //     MaterialPageRoute(builder: (_) => SimpleListViewDetailPage(id: index, password: strList[index]))
                //             // );
                //           },
                //           child: Card(
                //             child: Center(
                //               child: Text(
                //                 strList[index],
                //                 style: TextStyle(fontSize: 40),
                //               ),
                //             ),
                //           ),
                //         );
                //       }),
                // ),

                // SizedBox(
                //   height: 200,
                //   // child: ListView.builder(
                //   //     itemCount: strList.length,
                //   //     itemBuilder: (context, index) {
                //   //       return GestureDetector(
                //   //         onTap: () {
                //   //           // 오류 발생을 예방하기 위하여 주석 처리
                //   //           // Navigator.of(context).push(
                //   //           //     MaterialPageRoute(builder: (_) => SimpleListViewDetailPage(id: index, password: strList[index]))
                //   //           // );
                //   //         },
                //   //         child: Card(
                //   //           child: Center(
                //   //             child: Text(
                //   //               strList[index],
                //   //               style: TextStyle(fontSize: 20),
                //   //             ),
                //   //           ),
                //   //         ),
                //   //       );
                //   //     }),
                //
                //   child: ListView(
                //     children: [
                //       for (var element in strList)
                //         Card(
                //           child: Center(
                //             child: Text(element,
                //               style: TextStyle(fontSize: 20),
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),


                SizedBox(
                  width: 200,
                  child: Center(
                    child: DropdownButton<String>(     // DropdownButton Widget 추가
                      value: selectedElement,          // DropdownButton의 선택과 변수를 연결
                      onChanged: (String? newValue) {  // DropdownButton 선택시 이벤트 처리기
                        print(newValue);               // 인자가 Null로 넘어올 수 있어 ?로 허용
                        setState(() {              // DropdownButton에 연결된 변수값 상태 변경
                          selectedElement = newValue!;  // 값이 Null 아닌 것을 !로 확인후 사용
                        });
                      },
                      items: [
                        // for (var element in ["요소1","요소2","요소3"])   // for 반복 표현식
                        for (var element in strList)   // for 반복 표현식
                          DropdownMenuItem<String>(  // DropdownButton의 요소 Widget 추가
                            value: element,
                            child: Text(element),
                          ),
                      ],
                    ),
                  ),
                ),

                // if (contentLoaded ) Text("콘텐츠가 로드되었습니다.") // 콘텐츠 로드된 경우
                // else CircularProgressIndicator(),
                contentLoaded
                    ? Text("콘텐츠가 로드되었습니다.")
                    : CircularProgressIndicator(),
                SizedBox(
                  width: 200,
                  child: TextField(
                    onSubmitted: (_) {
                      print(textEditingController.text);
                    },
                    controller: textEditingController,
                    decoration: InputDecoration(
                      labelText: "필드이름",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

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
        ),

        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),

        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // 왼쪽 버튼 (-1 감소)
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: FloatingActionButton(
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
            ),
          ),
          // 오른쪽 버튼 (+2 증가)
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ])
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
