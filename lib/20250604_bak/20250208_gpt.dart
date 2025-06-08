// main.dart 전체 소스 (Firebase Vertex AI를 활용한 멀티모달 코드는 주석 처리되어 있음)
// 소스코드를 읽으며 절차적으로 이해되지 않는 부분에 설명을 위한 주석을 달았습니다.
// 주석으로 설명이 달리지 않은 코드들은 위에서 아래로 차근차근 읽으면 이해가 될 것입니다.
//import 'dart:convert';
//import 'dart:io';
//import 'package:http/http.dart' as http;
//import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
//import 'package:path_provider/path_provider.dart';

//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_vertexai/firebase_vertexai.dart';
//import 'firebase_options.dart';

import '20250208_model.dart';           // 채팅 내역과 채팅방 클래스 import

// final _apiKey = "Your API Key";// Google AI Studio에서 발급받은 API Key로 문자열 변경하세요.
final _apiKey = "AIzaSyD0o6NXXsx8m3ob4XndphSCa67ghMARHcI";// Google AI Studio에서 발급받은 API Key로 문자열 변경하세요.
//final imageUrl = "https://firebasestorage.googleapis.com/v0/b/totemic-fulcrum-420006.firebasestorage.app/o/uploads%2F1000004288.png?alt=media&token=d367e371-9624-418f-a3f4-5f3b7a49dc8a";
//final imageUrl = "https://firebasestorage.googleapis.com/v0/b/flutter-firebase-4d610.firebasestorage.app/o/cropped_1.jpg?alt=media&token=8e071853-6275-43ac-832e-7f1bfa1c22fc";
//final imageUrl = "https://68f0-1-223-173-94.ngrok-free.app/static/cropped_images/cropped_0.jpg";

void main() async {
  // // Firebase 초기화 시작
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // ); // Firebase 초기화의 끝

  runApp(const MyApp());
}

// Initialize the Vertex AI service and the generative model
// Specify a model that supports your use case
// Gemini 1.5 models are versatile and can be used with all API capabilities
//final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FPL LLM Chatbot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FPL LLM Chatbot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _canSendMessage = false;

  ChatRoom _chatRoom = ChatRoom(chats: [], createdAt: DateTime.now());

  void _sendMessage() {
    if (!_canSendMessage) return;

    _focusNode.unfocus();

    final ChatMessage chat = ChatMessage(
      isMe: true,
      text: _messageController.text,
      sentAt: DateTime.now(),
    );

    setState(() {
      _chatRoom.chats.add(chat);
      _canSendMessage = false;
    });

    _generateResponse(_messageController.text);

    _messageController.clear();
  }
  /*
  Future<String> urlToFilePath(String imageUrl) async {     // 비동기로 사용할 함수 정의
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/downloaded_image.jpg';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return filePath;
    } else {
      throw Exception("Failed to download image");
    }
  }
  */
  void _generateResponse(String prompt) async {
    _chatRoom.chats.add(
      ChatMessage(
        isMe: false,
        text: "",
        sentAt: DateTime.now(),
      ),
    );

    Gemini.instance.streamGenerateContent(prompt).listen((event) {
      setState(() {
        _chatRoom.chats.last.text += (event.output ?? "");
      });
    });
    /*
    final imageFilePath = await urlToFilePath(imageUrl);
    final geminiPrompt = TextPart(prompt);
    //final image = await File('image0.jpg').readAsBytes();
    final image = await File(imageFilePath).readAsBytes();
    final imagePart = InlineDataPart('image/png', image);

    final response = await model.generateContentStream([
      Content.multi([geminiPrompt,imagePart])
    ]);

    await for (final chunk in response) {
      print(chunk.text);
      setState(() {
        _chatRoom.chats.last.text += (chunk.text ?? "");
      });
    }
    */
  }

  @override
  void initState() {
    super.initState();
    Gemini.init(apiKey: _apiKey);
  }

  @override
  void dispose() {
    _messageController.dispose();   // 앞으로는 TextEditingController도 dispose합시다.
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.grey[100],
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          if (_chatRoom.chats.isEmpty)
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "images/logo_gpt.png",
                width: 40,
                height: 40,
              ),
            ),
          ListView(
            children: [
              for (var chat in _chatRoom.chats)
                if (chat.isMe)
                  _buildMyChatBubble(chat)
                else
                  _buildBotChatBubble(chat)
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildMessageTextField(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTextField() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Image.asset('images/logo_ask.png', width: 14 * 1.5, height: 14 * 1.5),
          SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              onSubmitted: (_) {
                _sendMessage();
              },
              onChanged: (text) {
                setState(() {
                  _canSendMessage = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: '메시지 FPL LLM Chatbot',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                suffixIcon: IconButton(
                  icon: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _canSendMessage ? Colors.black : Colors.black12,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyChatBubble(ChatMessage chat) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 250,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(chat.text),
      ),
    );
  }

  Widget _buildBotChatBubble(ChatMessage chat) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 20,
            top: 5,
          ),
          child: Image.asset(
            "images/logo_response.png",
            width: 20,
            height: 20,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 300,
            ),
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 5,
              bottom: 40,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(chat.text),
          ),
        ),
      ],
    );
  }
}