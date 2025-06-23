import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MatzipApiService {
  final String _baseUrl = dotenv.get('BASE_URL', fallback: 'http://125.251.52.42:9000');

  Future<Map<String, dynamic>> fetchData({required String apiUrl, required Map<String, dynamic> apiParam}) async {

    final Map<String, String> apiParamQuery = apiParam.map(
          (key, value) => MapEntry(key, value.toString()),
    );

    apiParamQuery.removeWhere((key, value) => key == 'sgg' && value == '전국');
    print(apiUrl);
    print(apiParamQuery);

    final Uri url = Uri.http(
      _baseUrl.split('//').last,
      apiUrl,
      apiParamQuery,
    );

    final Map<String, String> headers = {
      'accept': 'application/json',
      'api': dotenv.get('API_KEY', fallback: '20240922-topbds'),
    };

    final response = await http.post(
      url,
      headers: headers,
      body: '',
    );

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);

      final Map<String, dynamic> decodedData = json.decode(responseBody);
      // print(decodedData);

      if (decodedData['status'] == 'fail') {
        throw Exception(decodedData['message']);
      }

      return decodedData;

    } else {
      throw Exception('에러 발생하였습니다.');
    }
  }
}