import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  final dynamic name;
  final dynamic url;

  BookDetailPage({super.key, required this.name, required this.url});

  var bookUrls = {
    "파이썬 + AI":
        "https://image.aladin.co.kr/product/34207/82/cover200/896088457x_1.jpg",
    "점프 투 파이썬":
        "https://image.aladin.co.kr/product/31794/10/cover200/k362833219_1.jpg",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(name),
        // title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              child: Hero(
                tag: name,
                child: Image.network(
                  // url,
                  "${bookUrls[name]}",
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
