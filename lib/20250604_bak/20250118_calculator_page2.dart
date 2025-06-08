import 'package:flutter/material.dart';

class CalculatorPage2 extends StatefulWidget {
  const CalculatorPage2({super.key});

  @override
  State<CalculatorPage2> createState() => _CalculatorPage2State();
}

class _CalculatorPage2State extends State<CalculatorPage2> {
  TextEditingController number1Controller = TextEditingController();
  TextEditingController number2Controller = TextEditingController();
  TextEditingController operatorController = TextEditingController();
  TextEditingController resultController = TextEditingController();
  TextEditingController errorMessageController = TextEditingController(); // 오류 메시지 관리

  calculate() {
    setState(() {
      errorMessageController.text = ""; // 이전 오류 메시지 초기화
    });

    try {
      double number1 = double.parse(number1Controller.text);
      double number2 = double.parse(number2Controller.text);
      double result = 0;

      if (operatorController.text == "+") {
        result = number1 + number2;
      } else if (operatorController.text == "-") {
        result = number1 - number2;
      } else if (operatorController.text == "*") {
        result = number1 * number2;
      } else if (operatorController.text == "/") {
        result = number1 / number2;
      } else {
        setState(() {
          errorMessageController.text = "유효하지 않은 연산자입니다. +, -, *, /만 입력하세요.";
        });
        return;
      }

      resultController.text = result.toString();
    } catch (e) {
      setState(() {
        errorMessageController.text = "숫자와 연산자를 올바르게 입력하세요.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double textFieldLength = MediaQuery.of(context).size.width / 5;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: textFieldLength,
                child: TextField(
                  controller: number1Controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "숫자1",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                width: textFieldLength,
                child: TextField(
                  controller: operatorController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "연산자",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                width: textFieldLength,
                child: TextField(
                  controller: number2Controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "숫자2",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: calculate,
                child: Text(
                  "=",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: textFieldLength,
                child: TextField(
                  controller: resultController,
                  textAlign: TextAlign.center,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "결과",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            // 추가됨
            child: TextField(
              controller: errorMessageController,
              textAlign: TextAlign.center,
              enabled: false,
              decoration: InputDecoration(
                labelText: "메세지",
                border: OutlineInputBorder(),
                // labelStyle: TextStyle(color: Colors.red), // 오류 메시지의 라벨 색상을 빨간색으로 설정
              ),
              style: TextStyle(color: Colors.red), // 텍스트 색상을 빨간색으로 설정
            ),
          ),
        ],
      ),
    );
  }
}