import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MatzipApiService {
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

    final Map<String, String> headers = {
      'accept': 'application/json',
      'api': dotenv.get('API_KEY', fallback: null),
    };

    final response = await http.post(
      url,
      headers: headers,
      body: '',
    );

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);

      final Map<String, dynamic> decodedData = json.decode(responseBody);
      if (decodedData['status'] == 'fail') {
        throw Exception(decodedData['message']);
      }

      return decodedData;

    } else {
      throw Exception('에러 발생하였습니다.');
    }
  }
}