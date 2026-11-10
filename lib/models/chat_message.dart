class ChatMessage {
  final String id;
  final String channelId;
  final String senderId;
  final String senderName;
  final String text;
  final String timestamp;
  final bool isStaff;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.isStaff = false,
    this.isRead = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelId': channelId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp,
      'isStaff': isStaff,
      'isRead': isRead,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json, [String? fallbackId]) {
    return ChatMessage(
      id: json['id'] as String? ?? fallbackId ?? '',
      channelId: json['channelId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? 'Fellow Believer',
      text: json['text'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      isStaff: json['isStaff'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? true,
    );
  }
}
