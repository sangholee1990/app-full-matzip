import 'dart:math';

void main() {
  // List의 예
  // 자료형의 명시적 지정 (정적 자료형)
  List<String> lists = ["문자열 항목1", "문자열 항목2", "문자열 항목3"];
  print(lists);

  print(lists[0]);
  print(lists[lists.length - 1]);

  print(lists.runtimeType);
  print(lists is List<String>);

  // 자료형의 암묵적 지정 (동적 자료형)
  // var listsVar = ["문자열 항목1", "문자열 항목2", "문자열 항목3"];
  List<String> listsVar = ["문자열 항목1", "문자열 항목2", "문자열 항목3"];
  print(listsVar);

  print(listsVar[0]);
  print(listsVar[listsVar.length - 1]);

  print(listsVar.runtimeType);
  print(listsVar is List<String>);

  for (String item in listsVar) {
    print(item);
  }

  var list2 = ["항목1", "항목2", "항목3"];
  for (var item in list2) {
    print(item);
  }

  // 실습 - 장바구니 총합 계산
  Map<String, int> foods = {
    '김치찌개': 9000,
    '비빔밥': 12000,
    '단무지': 500,
    '마라탕': 15000,
  };

  int total = foods.values.reduce((sum, price) => sum + price);
  print('장바구니의 총 가격은 $total원 입니다.');

  int total2 = 0;
  for (var price in foods.values) {
    total2 += price;
  }
  print('장바구니의 총 가격은 $total2원 입니다.');

  // 실습 - 랜덤 점심 메뉴 출력
  List<String> menu = ['김치찌개', '비빔밥', '돈까스'];
  final random = Random();
  String selectedMenu = menu[random.nextInt(menu.length)];
  print('오늘의 점심 메뉴는 $selectedMenu 입니다.');
}
