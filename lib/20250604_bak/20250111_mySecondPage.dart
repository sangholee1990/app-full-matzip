// import '20250104_main.dart';
import 'package:first_flutter/20250104_main.dart';
import 'package:first_flutter/20250104_myThirdPage.dart';
import 'package:flutter/material.dart';

/**
 * 2p 화면
 */
class MySecondPage extends StatelessWidget {

  const MySecondPage({super.key, required this.title, required this.id, required this.pw});

  final String title;
  final int id;
  final String pw;
  // final dynamic title;
  // final dynamic id;
  // final dynamic pw;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "ID : $id / PW : $pw",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),

            Text(
              "2번째 페이지입니다.",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MyHomePage(title: '1p 화면 이동')));
                // Navigator.of(context).pop();
              },
              child: Text(
                "1번째 페이지로 이동",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.pinkAccent,
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (_) => MyHomePage(title: '1p 화면 이동')));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MyThirdPage(title: '3p 화면 이동')));
                // Navigator.pop(context);
              },
              child: Text(
                "3번째 페이지로 이동",
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
