import 'dart:math';

int add(int a, int b) {
  return a + b;
}

int add2({required int a, required int b}) => a + b;

int add3({int? a, int? b}) => a! + b!;

int add4({int? a, int? b}) => (a ?? 1) + (b ?? 2);

int add5({int a=1, int b=2}) => a + b;

int add6({int a=1, required int b}) => a + b;

List searchByName(List<Map<String, dynamic>> students, {required String name}) {
  return students
      .where((student) => student['name'].contains(name))
      .map((student) => student['name'])
      .toList();
}

List searchByGrade(List<Map<String, dynamic>> students, {required int grade}) {
  return students
      .where((student) => student['score'] >= grade)
      .map((student) => student['name'])
      .toList();
}

void main() {
  dynamic addVal;

  addVal = add(1, 3);
  print('[CHECK] addVal : $addVal');

  addVal = add(10, 20);
  print('[CHECK] addVal : $addVal');

  addVal = add2(a:1, b:3);
  print('[CHECK] addVal : $addVal');

  // addVal = add2(a:null, b:20);
  // print('[CHECK] addVal : $addVal');

  // addVal = add3(a:null, b:20);
  // print('[CHECK] addVal : $addVal');

  addVal = add4(a:null, b:20);
  print('[CHECK] addVal : $addVal');

  addVal = add5();
  print('[CHECK] addVal : $addVal');

  addVal = add6(a: 10, b:2);
  print('[CHECK] addVal : $addVal');

  // 학생부 정리하기
  List<Map<String, dynamic>> students = [
    {"name": "김민준", "score": 85},
    {"name": "이서윤", "score": 92},
    {"name": "박지우", "score": 78},
    {"name": "최예은", "score": 89},
    {"name": "정하윤", "score": 91},
    {"name": "강서연", "score": 74},
    {"name": "윤도윤", "score": 88},
    {"name": "조현우", "score": 95},
    {"name": "오하은", "score": 77},
    {"name": "신우진", "score": 83},
    {"name": "홍서준", "score": 82},
    {"name": "임주원", "score": 94},
    {"name": "류채은", "score": 72},
    {"name": "김하람", "score": 86},
    {"name": "문예준", "score": 80},
    {"name": "최지호", "score": 90},
    {"name": "박다인", "score": 79},
    {"name": "이준우", "score": 88},
    {"name": "김유찬", "score": 87},
    {"name": "윤태민", "score": 93},
    {"name": "전도현", "score": 81},
    {"name": "서연우", "score": 92},
    {"name": "한수민", "score": 76},
    {"name": "유시현", "score": 89},
    {"name": "최지안", "score": 84},
    {"name": "신예지", "score": 85},
    {"name": "장하준", "score": 74},
    {"name": "정세준", "score": 78},
    {"name": "송윤아", "score": 90},
    {"name": "양지호", "score": 87},
    {"name": "백다온", "score": 82},
    {"name": "하지후", "score": 88},
    {"name": "강민재", "score": 93},
    {"name": "정유진", "score": 75},
    {"name": "이재윤", "score": 91},
    {"name": "박민혁", "score": 79},
    {"name": "김태윤", "score": 80},
    {"name": "이도현", "score": 84},
    {"name": "오주원", "score": 77},
    {"name": "조아인", "score": 92},
    {"name": "송다인", "score": 86},
  ];

  // List getList;
  dynamic getList;

  getList = searchByName(students, name: "윤");
  print('[CHECK] searchByName : $getList');

  getList = searchByGrade(students, grade: 90);
  print('[CHECK] searchByGrade : $getList');
}
