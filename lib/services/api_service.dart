import 'dart:convert';
import 'package:http/http.dart' as http;

class MatzipApiService {
  // FastAPI 서버 주소 (실제 개발 환경에 맞게 변경하세요)
  // Android 에뮬레이터에서는 10.0.2.2를 사용해야 로컬 PC의 localhost에 접속할 수 있습니다.
  final String _baseUrl = "http://10.0.2.2:8000";

  // 홈 화면 데이터를 Map으로 가져오는 API
  Future<Map<String, dynamic>> getHomeData() async {
    final response = await http.get(Uri.parse('$_baseUrl/home-data'));

    if (response.statusCode == 200) {
      // UTF-8로 디코딩하여 한글 깨짐 방지
      final String responseBody = utf8.decode(response.bodyBytes);
      // JSON 문자열을 Map<String, dynamic>으로 변환하여 반환
      return json.decode(responseBody);
    } else {
      // 에러가 발생하면 예외를 던집니다.
      throw Exception('Failed to load home data');
    }
  }
}