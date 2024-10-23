// class ChatMessage {
//   final String message;
//   final bool isUser;

//   ChatMessage({required this.message, required this.isUser});
// }

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({required this.message, required this.isUser});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'is_user': isUser,
    };
  }

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      message: map['message'],
      isUser: map['is_user'],
    );
  }
}
