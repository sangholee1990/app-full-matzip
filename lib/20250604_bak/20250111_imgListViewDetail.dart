// import '20250104_main.dart';
import 'package:first_flutter/20250104_main.dart';
import 'package:first_flutter/20250104_myThirdPage.dart';
import 'package:flutter/material.dart';

/**
 * 2p 화면
 */
class ImgListViewDetail extends StatelessWidget {
  const ImgListViewDetail(
      {super.key,
      required this.idx,
      required this.name,
      required this.imgUrl,
      required this.title});

  // final int idx;
  // final String name;
  // final String imgUrl;
  final dynamic idx;
  final dynamic name;
  final dynamic imgUrl;
  final dynamic title;

  @override
  Widget build(BuildContext context) {
    // return Placeholder();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                imgUrl,
                height: 500,
                fit: BoxFit.cover,
              ),
              Text(
                imgUrl,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}
