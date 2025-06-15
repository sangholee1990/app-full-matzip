import 'package:flutter_dotenv/flutter_dotenv.dart';
// lib 폴더에 있는 api_service.dart를 import 합니다.
// 'dart_api_test' 부분은 pubspec.yaml의 name에 맞게 수정해주세요.
import 'package:app_full_matzip/services/api_service.dart';

Future<void> main() async {
  // 1. .env 파일 로드
  // await dotenv.load(fileName: ".env");
  await dotenv.load(fileName: "config/local.env");


  // 2. API 서비스 객체 생성
  final apiService = MatzipApiService();

  // 3. 테스트할 파라미터 설정
  final params = {
    'page': 1,
    'limit': 10,
  };

  print("API 호출 시작: $params");

  // 4. API 호출 및 결과 처리 (에러 핸들링 포함)
  try {
    final Map<String, dynamic> results = await apiService.fetchData(
      apiUrl: '/api/sel-real',
      apiParam: params,
    );

    print("\n✅ API 호출 성공!");
    print("----------------------------------------");
    if (results.isEmpty) {
      print("반환된 데이터가 없습니다.");
    } else {
      // 5. 결과 출력
      print(results);
      // for (var item in results) {
      //   print(item);
      // }
    }
    print("----------------------------------------");

  } catch (e) {
    print("\n❌ API 호출 실패: $e");
  }
}