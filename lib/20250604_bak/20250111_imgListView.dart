// import 'package:first_flutter/20250111_myThirdPage.dart';
import 'package:first_flutter/20250111_simpleListViewDetail.dart';
import 'package:first_flutter/20250111_imgListViewDetail.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ImgListviewPage extends StatelessWidget {
  ImgListviewPage({super.key});

  var imgList = [
    "https://image.aladin.co.kr/product/34207/82/cover200/896088457x_1.jpg",
    "https://image.aladin.co.kr/product/31794/10/cover200/k362833219_1.jpg",
    "https://image.aladin.co.kr/product/3422/90/cover200/8966260993_1.jpg",
    "https://image.aladin.co.kr/product/57/79/cover200/8991268072_2.jpg",
    "https://image.aladin.co.kr/product/34274/43/coversum/scm9462999557200.jpg",
    "https://image.aladin.co.kr/product/26031/38/coversum/k702737950_1.jpg",
  ];

  var imgNameList = [
    "파이썬 + AI",
    "점프 투 파이썬",
    "생각하는 프로그래밍",
    "실용주의 프로그래머",
    "프로그래밍 심리학",
    "UWP 퀵스타트",
  ];

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return ListView.builder(
        itemCount: imgList.length,
        // scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // return Canter(
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                  ImgListViewDetail(title: "[이미지 상세보기] ${imgNameList[index]}", idx: index, name: imgNameList[index], imgUrl: imgList[index])));
            },
            child: Card(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.network(
                        imgList[index],
                        // width: 400,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "${index}",
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            "${imgNameList[index]}",
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
