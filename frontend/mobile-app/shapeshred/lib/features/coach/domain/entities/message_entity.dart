import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'timestamp': timestamp,
        'isRead': isRead,
      };

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        id: map['id'] as String? ?? '',
        senderId: map['senderId'] as String? ?? '',
        receiverId: map['receiverId'] as String? ?? '',
        text: map['text'] as String? ?? '',
        timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        isRead: map['isRead'] as bool? ?? false,
      );
}
