class Person {
  // Person(this.name, this.age);
  // Person({required this.name, required this.age});
  // Person({required this.name, this.age=20});
  Person({required String name, this.age = 20, required this.sex}) : _name = name;

  final String _name;
  final int age;
  final String sex;

  String get name => _name;

  // void sayHello() {
  //   print("안녕하세요, $age세 $sex $name 입니다.");
  // }
  void sayHello() => print("안녕하세요, $age세 $sex $name입니다.");
}

class Animal {
  void eat() => print("남남");
}

class Cat extends Animal {
  @override
  void eat() => print("남남 냥냥");
  void sound() => print("야옹");
}

mixin Flyable {
  void fly() => print("날다");
}

class Bird extends Cat with Flyable {

}

abstract class Shape {
  double getArea();
}

class Circle extends Shape {
  Circle(this.radius);

  double radius;
  @override
  double getArea() => 3.14 * radius * radius;
}

class Rect extends Shape {
  Rect(this.height, this.width);

  double height;
  double width;

  @override
  double getArea() => height * width;
}

void main() {
  // 캡슐화
  final boy = Person(name: "홍길동", age: 10, sex: "남성");
  boy.sayHello();

  final boy2 = Person(name: "홍길동2", sex: "여성");
  boy2.sayHello();

  // 상속
  Cat cat = Cat();
  cat.eat();
  cat.sound();

  // 인터페이스
  Bird bird = Bird();
  bird.fly();
  bird.eat();
  bird.sound();

  // 추상화
  Circle circle = Circle(5);
  print(circle.getArea());

  Rect rect = Rect(5, 4);
  print(rect.getArea());
}
