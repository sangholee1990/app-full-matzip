import 'package:flutter/material.dart';

class CalculatorPage3 extends StatefulWidget {
  const CalculatorPage3({super.key});

  @override
  State<CalculatorPage3> createState() => _CalculatorPage3State();
}

class _CalculatorPage3State extends State<CalculatorPage3> {
  var validOperators = ["+", "-", "*", "/"];
  TextEditingController number1Controller = TextEditingController();
  TextEditingController number2Controller = TextEditingController();
  TextEditingController resultController = TextEditingController();
  TextEditingController errorMessageController = TextEditingController();
  String selectedOperator = "+";

  calculate() {
    setState(() {
      errorMessageController.text = ""; // 이전 오류 메시지 초기화
    });

    try {
      double number1 = double.parse(number1Controller.text);
      double number2 = double.parse(number2Controller.text);
      double result = 0;

      if (selectedOperator == "+") {
        result = number1 + number2;
      } else if (selectedOperator == "-") {
        result = number1 - number2;
      } else if (selectedOperator == "*") {
        result = number1 * number2;
      } else if (selectedOperator == "/") {
        if (number2 == 0) {
          setState(() {
            errorMessageController.text = "0으로 나눌 수 없습니다.";
          });
          return;
        }
        result = number1 / number2;
      }

      resultController.text = result.toString();
    } catch (e) {
      setState(() {
        errorMessageController.text = "숫자를 올바르게 입력하세요.";
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
                child: Center( // 중앙 정렬
                  child: DropdownButton<String>(
                    value: selectedOperator,
                    items: validOperators.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOperator = newValue!;
                      });
                    },
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
            child: TextField(
              controller: errorMessageController,
              textAlign: TextAlign.center,
              enabled: false,
              decoration: InputDecoration(
                labelText: "메세지",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.red), // 오류 메시지 색상
            ),
          ),
        ],
      ),
    );
  }
}
