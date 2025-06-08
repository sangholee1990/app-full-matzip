// http_listview_page.dart 파일 코드
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// stful 코드조각으로 추가된 HttpListviewPage 클래스 코드
class HttpListviewPage extends StatefulWidget {
  const HttpListviewPage({super.key});

  @override
  State<HttpListviewPage> createState() => _HttpListviewPageState();
}

class _HttpListviewPageState extends State<HttpListviewPage> {
  String textHTML = "서버로 부터 HTML을 가져오기 전";
  // var parsedJson;
  var users;

  requestResponseServer() async {
    // String serverUrl = "https://jsonplaceholder.typicode.com/posts";
    // String serverUrl = "http://localhost:9000";
    // String serverUrl = "http://192.168.0.161:9000";
    // String serverUrl = "https://jsonplaceholder.typicode.com/users/1";
    // String serverUrl = "https://jsonplaceholder.typicode.com/users";
    String serverUrl = "http://localhost:9000/api/users";
    // String serverUrl = "http://192.168.0.161:9000/api/users";

    var response = await http.get(Uri.parse(serverUrl));
    setState(() {
      // textHTML = response.body;
      users = jsonDecode(response.body);
      // print('[CHECK] users : $users');
    });
  }

  @override
  void initState() {
    super.initState();
    requestResponseServer();
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: textHTML == "서버로 부터 HTML을 가져오기 전" // http.get() 완료 전이면
    //       ? CircularProgressIndicator()                    // 로딩 표시
    //       : Text(
    //     textHTML,
    //     style: TextStyle(fontSize: 30),
    //   ),
    // );
    return users == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            // Parsing된 json 즉 Map(딕셔너리)을 ListView에 출력
            itemCount: users.length, // Data가 하나라서 1을 강제 지정
            itemBuilder: (context, index) {
              var user = users[index];

              return Card(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "ID: ${user['id']}", // parsedJson을 Map의 형태로 보여줌
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        "이름: ${user['name']}",
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        "사용자명: ${user['username']}",
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        "메일주소: ${user['email']}",
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
