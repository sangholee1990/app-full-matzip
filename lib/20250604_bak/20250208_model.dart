// model.dart 전체 소스
class ChatMessage {      // 개별 메세지를 저장하기 위한 클래스 모델
  ChatMessage({          // 생성자
    required this.isMe,
    required this.text,
    required this.sentAt,
  });

  final bool isMe;       // 인자들
  String text;
  final DateTime sentAt;
}

class ChatRoom {             // 채팅방에 여러 메세지를 저장하기 위한 클래스 모델
  ChatRoom({                 // 생성자
    required this.chats,
    required this.createdAt,
  });

  List<ChatMessage> chats;   // 인자들
  final DateTime createdAt;
}