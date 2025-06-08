import 'dart:convert';

import 'package:devcoean_flutter/models/email_model.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class EmailController {
  static final EmailController _instance = EmailController._internal();

  factory EmailController() {
    return _instance;
  }

  EmailController._internal() {
    // 초기화 로직 넣으면 됨
  }

  Future<bool> sendEmail(EmailModel note) async {
    bool is_success = true;
    try {
      var fastApiUrl;
      fastApiUrl = Uri.parse(baseUrl + '/comm/send_email');
      http.Response response = await http.post(
        fastApiUrl,
        body: jsonEncode(
          {
            "user_email": note.email_address,
            "title": note.title,
            "content": note.content
          },
        ),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );

      final responseData = json.decode(utf8.decode(response.bodyBytes));

      is_success = responseData ?? false;

      if (response.statusCode != 200) {
        final errorMessage = responseData['detail'];
        print("error : $errorMessage");
        // throw Exception(errorMessage);
      }

      return is_success;
    } catch (error) {
      throw error;
    }
  }
}
