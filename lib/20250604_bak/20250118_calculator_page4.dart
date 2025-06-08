import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // 수식 연산을 위하여 import

class CalculatorPage4 extends StatefulWidget {
  const CalculatorPage4({super.key});

  @override
  State<CalculatorPage4> createState() => _CalculatorPage4State();
}

class _CalculatorPage4State extends State<CalculatorPage4> {
  TextEditingController expressionController = TextEditingController();
  TextEditingController errorMessageController = TextEditingController();

  calculate() {
    var evaluator = const ExpressionEvaluator(); // 수식 연산을 위하여 Evaluator가 필요합니다.

    try {
      // 수식이 올바르지 않을때 예외(Exception) 발생을 처리
      var result = // Evaluator를 사용하여 연산을 합니다.
          evaluator.eval(Expression.parse(expressionController.text), {});

      errorMessageController.text = "";
      expressionController.text += "=${result.toString()}";
    } catch (e) {
      // 예외(Exception)가 발생하면 즉 수식이 올바르지 않으면
      errorMessageController.text = "계산식이 올바르지 않습니다. Clear한 후 다시 시도하세요.";
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: TextField(
              controller: expressionController,
              textAlign: TextAlign.center,
              enabled: false,
              decoration: InputDecoration(
                labelText: "계산식",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  expressionController.text = "";
                },
                child: Text(
                  "C",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "/";
                },
                child: Text(
                  "/",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "7";
                },
                child: Text(
                  "7",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "8";
                },
                child: Text(
                  "8",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "9";
                },
                child: Text(
                  "9",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "*";
                },
                child: Text(
                  "*",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "4";
                },
                child: Text(
                  "4",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "5";
                },
                child: Text(
                  "5",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "6";
                },
                child: Text(
                  "6",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "-";
                },
                child: Text(
                  "-",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "1";
                },
                child: Text(
                  "1",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "2";
                },
                child: Text(
                  "2",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "3";
                },
                child: Text(
                  "3",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "+";
                },
                child: Text(
                  "+",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  expressionController.text += "0";
                },
                child: Text(
                  "0",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: calculate,
                child: Text(
                  "=",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          SizedBox(
            child: TextField(
              controller: errorMessageController,
              textAlign: TextAlign.center,
              enabled: false,
              decoration: InputDecoration(
                labelText: "메세지",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
