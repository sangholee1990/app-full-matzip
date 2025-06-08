void main() {
  for (var i = 0; i < 10; i++) {
    print('hello ${i + 1}');
  }

  print("Hello Dart");

  // 한줄 주석
  // print("Hello Dart");

  /* 다중 주석
  print("Hello Dart");
  print("Hello Dart");
  print("Hello Dart");
  */

  // 숫자
  int myAge = 34;
  print("myAge : $myAge");

  myAge = 35;
  print("myAge : $myAge");

  // 변수
  String nameVar = "변경 가능한 이름 변수";
  nameVar = "변경된 이름 변수";
  print("nameVar : $nameVar");

  // 상수
  const String nameConst = "변경 불가능한 상수-주로 불변 객체를 만들 때 사용";
  print("nameConst : $nameConst");

  final String nameFinal = "변경 불가능한 상수-주로 인자를 받을 때 사용";
  print("nameFinal : $nameFinal");

  final now = DateTime.now();
  print("현재 시간: $now");

  // 오류: const는 컴파일 시점에 값이 고정되어야 함
  // const currentTime = DateTime.now();
  // print("현재 시간: $const");

  String lang = "Dart";
  String framework = "Flutter";
  String formatted = "$framework 프레임워크의 $lang 언어";
  print("formatted : $formatted");

  int num1 = 10;
  int num2 = 20;
  formatted = "$num1 + $num2 = ${num1 + num2}";
  print("formatted : $formatted");

  // 예제
  print("'singleQuote'");
  print('"doubleQuote"');

  // 현재
  print('single"Quote');
  print("double'Quote");

  // 과거
  print('single\'Quote');
  print("double\"Quote");

  String sAge = "42";
  print("sAge : $sAge");

  int iAge = int.parse(sAge);
  print("iAge : $iAge");

  // 자료형의 명시적 지정 (정적 자료형)
  List<String> lists = ["문자열 항목1", "문자열 항목2", "문자열 항목3"];
  print(lists);

  print(lists[0]);
  print(lists[1]);
  print(lists[2]);

  print(lists[lists.length - 1]);

  print(lists.runtimeType);
  print(lists is List<String>);

  // 자료형의 암묵적 지정 (동적 자료형)
  // var listsVar = ["문자열 항목1", "문자열 항목2", "문자열 항목3"];
  // print(listsVar);

  // print(listsVar[0]);
  // print(listsVar[listsVar.length - 1]);

  // print(listsVar.runtimeType);
  // print(listsVar is List<String>);
}
