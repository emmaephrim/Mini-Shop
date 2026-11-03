// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? text,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String id, String source) =>
      Message.fromMap(id, json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, text: $text, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.senderId == senderId &&
        other.text == text &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^ senderId.hashCode ^ text.hashCode ^ timestamp.hashCode;
  }
}
