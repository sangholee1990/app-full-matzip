// main.dart 파일 코드
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart'; // image_picker 라이브러리 import
import 'dart:io'; // File IO를 위해 import
import 'package:dio/dio.dart'; // 이미지/동영상 Upload를 위한 라이브러리 import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '나의 첫번째 Flutter 앱'),
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
  var image; // 이미지 경로를 저장하는 변수
  var video; // 동영상을 저장할 변수
  var images; // 여러장의 이미지를 저장하기 위한 변수

  upload(media) async {
    // 동영상 혹은 이미지 upload를 위한 비동기 함수 추가
    if (media != null) {
      String fileName = media.path.split('/').last;
      var formData = FormData.fromMap({
        // 이 코드가 upload할 데이터를 만드는 핵심입니다.
        "file": await MultipartFile.fromFile(media.path, filename: fileName),
      });

      try {
        // dio는 status code가 200이 아닌 경우 Exception을 발생시킵니다
        var dio = Dio(); // Flutter Server 통신시 설명한 것들로 http대신 dio를 사용합니다.
        // String serverUri = "http://localhost:8087/upload";
        String serverUri = "http://localhost:9000/upload";
        // String serverUri = "http://192.168.0.161:9000/upload";
        // String serverUri = "https://397f-203-229-246-206.ngrok-free.app/upload";

        // 안드로이드
        if (Platform.isAndroid) {
          // serverUri = "http://10.0.2.2:8087/upload";
          serverUri = "http://10.0.2.2:9000/upload";
          // serverUri = "https://397f-203-229-246-206.ngrok-free.app/upload";
        }

        var response = await dio.post(serverUri, data: formData);

        print("미디어(이미지/비디오) 업로드 성공");
      } catch (e) {
        print("미디어(이미지/비디오) 업로드 실패: ${e}");
      }
    }
  }

  pickMultipleImages() async {
    var picker = ImagePicker();
    var pickedImages = await picker.pickMultiImage(); // 기존 코드와 함수가 달라짐

    if (pickedImages.isNotEmpty) {
      // 가져온 사진이 있으면
      setState(() {
        // 가져온 사진의 파일 Pass를 리스트로 변환
        images =
            pickedImages.map((pickedFile) => File(pickedFile.path)).toList();
      });
    } else {
      // 가져온 사진이 없으면
      setState(() {
        images = null; // null을 저장하여 비어 있음을 알림
      });
    }
  }

  pickVideo() async {
    var picker = ImagePicker(); // picker.pickImage가 picker.pickVideo로 바뀜
    var pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    // 나머지 코드들은 image가 video로 바뀐것 정도가 다름
    if (pickedVideo != null) {
      setState(() {
        video = File(pickedVideo.path);
      });
    }
  }

  takeVideo() async {
    var picker = ImagePicker(); // picker.pickImage가 picker.pickVideo로 바뀜
    var pickedVideo = await picker.pickVideo(source: ImageSource.camera);

    if (pickedVideo != null) {
      setState(() {
        video = File(pickedVideo.path);
      });
    }
  }

  pickImage() async {
    var picker = ImagePicker(); // 갤러리에서 이미지 한장을 가져 오는 코드
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // 갤러리에서 이미지를 정상적으로 가져온 경우
      setState(() {
        image = File(pickedImage.path); // 갤러리에서 가져온 이미지 경로를 변수에 저장
      });
    }
  }

  takePicture() async {
    var picker = ImagePicker(); // 사진기로 이미지 한장을 촬영하는 코드로
    var pickedImage = await picker.pickImage(source: ImageSource.camera);
    // ImageSource.gallery가 ImageSource.camera로
    if (pickedImage != null) {
      // 바뀐 것만 달라짐
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image == null
                ? Text('사진을 선택하세요.')
                : Column(
                    children: [
                      Image.file(
                        image,
                        width: 300,
                        height: 300,
                      ),
                      ElevatedButton(
                        // 이미지가 있는 경우 업로드 버튼을 활성화하고
                        onPressed: () {
                          upload(image);
                        }, // upload 함수에 image를 넘겨
                        child: Text('이미지 업로드'), // 업로드합니다.
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('갤러리에서 사진 선택'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: takePicture,
              child: Text('사진 촬영'),
            ),
            video == null
                ? Text('동영상을 선택하세요.')
                : Column(
                    children: [
                      Text('비디오 파일: ${video.path}'),
                      ElevatedButton(
                        // 동영상이 있는 경우 업로드 버튼을 활성화하고
                        onPressed: () {
                          upload(video);
                        }, // upload 함수에 video를 넘겨
                        child: Text('동영상 업로드'), // 업로드합니다.
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickVideo,
              child: Text('갤러리에서 동영상 선택'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: takeVideo,
              child: Text('동영상 촬영'),
            ),
          ],
        ),
      ),
    );
  }
}
