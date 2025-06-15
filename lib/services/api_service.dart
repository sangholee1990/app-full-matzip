import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MatzipApiService {
  // FastAPI 서버 주소 (실제 개발 환경에 맞게 변경하세요)
  // Android 에뮬레이터에서는 10.0.2.2를 사용해야 로컬 PC의 localhost에 접속할 수 있습니다.

  final String _baseUrl = dotenv.get('BASE_URL', fallback: null);

  // 2. 새로운 API 명세에 맞는 함수 작성
  Future<Map<String, dynamic>> fetchData({required String apiUrl, required Map<String, dynamic> apiParam}) async {

    final Map<String, String> apiParamQuery = apiParam.map(
          (key, value) => MapEntry(key, value.toString()),
    );

    apiParamQuery.removeWhere((key, value) => key == 'sgg' && value == '전국');

    final Uri url = Uri.http(
      _baseUrl.split('//').last,
      apiUrl,
      apiParamQuery,
    );
    print(url);

    // 3. 커스텀 헤더 정의
    final Map<String, String> headers = {
      'accept': 'application/json',
      'api':  dotenv.get('API_KEY', fallback: null),
    };

    // 4. GET 대신 POST 메소드 사용, 헤더와 빈 body 전달
    final response = await http.post(
      url,
      headers: headers,
      body: '', // curl 명령어의 -d '' 부분
    );

    // print(response.statusCode);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      // print(responseBody);

      final Map<String, dynamic> decodedData = json.decode(responseBody);


      // API 응답에서 실제 데이터 리스트가 'items' 또는 'data' 키 아래에 있다고 가정합니다.
      // 실제 응답 키에 맞게 'items'를 수정하세요.
      // return decodedData as List<dynamic>;
      // return decodedData;

      if (decodedData['status'] == 'fail') {
        throw Exception(decodedData['message']);
      }

      // 성공 시에만 데이터 Map 전체를 반환
      return decodedData;

    } else {
      throw Exception('에러 발생하였습니다.');
    }
  }
}