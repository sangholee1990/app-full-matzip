// import 'package:first_flutter/20250111_myThirdPage.dart';
import 'package:first_flutter/20250111_simpleListViewDetail.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SimpleListviewPage extends StatelessWidget {
  SimpleListviewPage({super.key});

  var strList = List.generate(40, (index) => "${index + 1}번째 항목",);

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return ListView.builder(
        itemCount: strList.length,
        // scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // return Canter(
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                  SimpleListViewDetail(title: "[상세보기] ${strList[index]}", id: index, pw: strList[index])));
            },
            child: Card(
              child: Center(
                child: Text(
                  strList[index],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        });
  }
}
