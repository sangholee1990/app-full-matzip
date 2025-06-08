// import '20250104_main.dart';
import 'package:first_flutter/20250104_main.dart';
import 'package:first_flutter/20250104_mySecondPage.dart';
import 'package:flutter/material.dart';

class MyThirdPage extends StatelessWidget {
  const MyThirdPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
          actions: [
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).popUntil(
                      (route) => route.isFirst
                  );
                }
            ),
          ]
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "3번째 페이지입니다.",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
