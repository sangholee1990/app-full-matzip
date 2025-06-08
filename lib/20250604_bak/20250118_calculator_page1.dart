import 'package:flutter/material.dart';

class CalculatorPage1 extends StatefulWidget {
  const CalculatorPage1({super.key});

  @override
  State<CalculatorPage1> createState() => _CalculatorPage1State();
}

class _CalculatorPage1State extends State<CalculatorPage1> {
  TextEditingController number1Controller = TextEditingController();
  TextEditingController number2Controller = TextEditingController();
  TextEditingController operatorController = TextEditingController();
  TextEditingController resultController = TextEditingController();

  calculate() {
    double number1 = double.parse(number1Controller.text);  // 연산을 위하여 문자를 double로 변환합니다.
    double number2 = double.parse(number2Controller.text);
    double result = 0;

    if(operatorController.text == "+")          // 이것이 핵심 로직입니다.
      result = number1 + number2;
    else if(operatorController.text == "-")
      result = number1 - number2;
    else if(operatorController.text == "*")
      result = number1 * number2;
    else if(operatorController.text == "/")     // 예제를 단순하게 구성하기 위하여
      result = number1 / number2;               // else를 사용하지 않았는데
    // 다음 예제에서 보완됩니다.
    resultController.text = result.toString();
  }

  @override
  Widget build(BuildContext context) {
    double textFieldLength = MediaQuery.of(context).size.width / 5;  // MediaQuery를 사용하여 Widget의 크기를 조정합니다.

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(      // TextField Widget은 크기를 제한하지 않으면 오류가 발생합니다.
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
              enabled: false,                // 읽기 전용 필드로 만들어 줍니다.
              decoration: InputDecoration(
                labelText: "결과",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}