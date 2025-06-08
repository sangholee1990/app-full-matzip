// login_page.dart에 만든 LoginPage Stateful Widget 클래스 코드
import 'package:flutter/material.dart';
import "20250201_main.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// class _LoginPageState extends State<LoginPage> {
class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double idPasswordOpacity = 0;  // 처음에 불투명도를 0으로 즉, 완전히 투명하게 설정
  var animationController;   // animationController 변수
  var animation;             // 어떤 Animation을 할지 결정함

  @override
  void initState() {
    super.initState();

    // Animation Controller에 3초 Animation을 설정/Animation 대상은 이 객체(vsync: this)
    animationController = AnimationController(duration: Duration(seconds: 3), vsync: this);
    // 0도 에서 360도(pi * 2) 돌아가는 Animation을 Animation Controller에 설정. (3초에 한바퀴)
    animation = Tween<double>(begin:0,end: pi * 2).animate(animationController);
    animationController.repeat(); // animation Controller로 Animation 시작
    // animation이 수치상으로 발생하고
    // 이를 가져다 화면에 보여주는 Widget은 AnimatedBuilder임


    userIdController.text = "test";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Timer를 Widget에 전달하여 실행
      Timer(Duration(seconds: 1), () {
        // 2초뒤
        setState(() {
          // 완전히 불투명하게 설정
          idPasswordOpacity = 1; // 불투명도를 1로
        });
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose(); // 할당받은 Animation Controller 자원을 반납함
    // TODO: implement dispose
    super.dispose(); // Parent들이 해제할 자원을 맨뒤에 해제(initState()와 반대로 뒤에 배치)
  } // super.initState()는 앞에 배치되어 Parent가 할당할 자원을 먼저 할당

  loginCheck(String userId, String password) async {
    // 로그인 체크 함수 추가
    // String serverUrl = "http://10.0.2.2:8087/login-check"; // Flutter Server의
    String serverUrl = "http://localhost:9000/api/login-check";
    // String serverUrl = "http://192.168.0.161:9000/api/login-check";

    // login check url
    var response = await http.post(
      // Post 방식으로 호출
      Uri.parse(serverUrl),
      headers: {
        // Post 방식 호출을 위해서 headers 정보 필요
        'Content-Type': 'application/x-www-form-urlencoded', // 응용프로그램/폼 인코드
      },
      body: {
        // Request Parameter로 userId와 password를 넘겨줌
        'userId': userId,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // 오류없이 잘 읽어온 경우
      // var loginStatus = response.body;
      // var parseJson = json.decode(response.body);
      List<dynamic> jsonResponse = json.decode(response.body);
      var parseJson = jsonResponse[0];

      bool loginSuccess = parseJson['loginSuccess'];
      print('[CHECK] loginSuccess : $loginSuccess');

      if (loginSuccess) {
        // 아이디와 비밀번호가 일치하여 'true' 반환된 경우
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                const MyHomePage(title: 'Flutter Demo Home Page')));
      } else {
        // // 아이디와 비밀번호가 불일치하여 'false'인 경우
        showAlertDialog("로그인 실패", "아이디가 존재하지 않거나 비밀번호가 일치하지 않습니다.");
      }
    } else {
      // Flutter 서버에서 로그인 체크하다가 알 수 없는 오류가 발생한 경우
      showAlertDialog(
          "서버 오류", "Flutter Server의 정상 동작 여부를 점검하세요.(${response.statusCode})");
    }
  }

  showAlertDialog(title, message) {
    // 경고창을 보여주는 기능을 함수로 분리
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title), // 경고창의 타이틀 추가
            content: Text(message),
            actions: [
              // 경고창에 Ok 버튼 추가
              TextButton(
                onPressed: () {
                  // Ok 버튼 누르면 이전 창으로 돌아감
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/LG전자 DX School.png"),
            SizedBox(height: 50),
            SizedBox(
              height: 200,
              child: AnimatedOpacity(           // AnimatedOpacity Widget으로 감쌈
                opacity: idPasswordOpacity,     // 불투명도를 앞에서 지정한 변수로 지정
                duration: Duration(seconds: 3), // 3초간 서서히 나타나도록 설정
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        // TextField 사용
                        controller: userIdController,
                        decoration: InputDecoration(
                          // InputDecoration사용
                          labelText: "아이디",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        // TextField 사용
                        controller: passwordController,
                        obscureText: true, // 입력하는 암호가 필드에 보이지 않게 처리함
                        decoration: InputDecoration(
                          // InputDecoration사용
                          labelText: "비밀번호",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            // TextButton 사용
                            onPressed: () {
                              loginCheck(userIdController.text,passwordController.text);
                              // if (userIdController.text == "test" &&
                              //     passwordController.text ==
                              //         "test") // 입력된 값을 Check하여 두값이 모두 test일 경우 로그인하도록 수정
                              //   Navigator.of(context).pushReplacement(
                              //       MaterialPageRoute(
                              //           builder: (context) => const MyHomePage(
                              //               title: 'Flutter Demo Home Page')));
                              // else // 일치하지 않는 경우 알림창 출력
                              //   showDialog(
                              //       context: context,
                              //       builder: (context) {
                              //         return AlertDialog(
                              //             content: Text(
                              //                 "아이디가 존재하지 않거나 비밀번호가 일치하지 않습니다."));
                              //       });
                            },
                            child: Text("로그인")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Image.asset("images/lab4dx.png"),
            AnimatedBuilder(                     // image 객체를 AnimatedBuilder로 감쌈
                animation: animationController,  // animationController를 사용하여 Animation
                builder: (context, widget) {     // context : 현재 화면, widget : 감싸진 Widget
                  return Transform.rotate(       // animation에 설정된 각도 정보를 가지고 회전시킴
                    angle: animation.value,      // 각도 정보가 포함된 animation을 사용
                    child: widget,               // AnimatedBuilder로 감싸진 Widget
                  );
                },
                child: Image.asset("images/lab4dx.png"),
            ),

          ],
        ),
      ),
    );
  }
}
