import 'package:intl/intl.dart';

class Message {
  int? id;
  BigInt? senderId;
  int? receiverId;
  String? content;
  DateTime? timeSent;
  bool? isRead;
  int? conversationId;

  Message({
    this.id,
    this.senderId,
    this.receiverId,
    this.content,
    this.timeSent,
    this.isRead,
    this.conversationId,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    senderId = json['senderId'] != null
        ? BigInt.tryParse(json['senderId'].toString())
        : null;
    receiverId = json['receiverId'] as int?;
    content = json['content'] as String?;
    timeSent = _parseDateTime(json['timeSent']);
    isRead = json['isRead'] as bool?;
    conversationId = json['conversationId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
        <String, dynamic>{}; // Use <String, dynamic> for clarity
    data['id'] = id;
    data['senderId'] = senderId?.toString(); // Send BigInt as String
    data['receiverId'] = receiverId;
    data['content'] = content;
    data['timeSent'] = timeSent?.toIso8601String();
    data['isRead'] = isRead;
    data['conversationId'] = conversationId;
    return data;
  }

  static DateTime? _parseDateTime(dynamic timeSentJson) {
    if (timeSentJson == null) return null;
    try {
      if (timeSentJson is String) {
        return DateTime.parse(timeSentJson);
      } else if (timeSentJson is int) {
        return DateTime.fromMillisecondsSinceEpoch(timeSentJson);
      }
      return null;
    } catch (e) {
      print('Error parsing DateTime: $e, value: $timeSentJson');
      return null;
    }
  }
}

extension MessageExtensions on Message {
  String formatMessageTimestamp() {
    if (timeSent == null) {
      return 'Invalid time';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday =
        today.subtract(const Duration(days: 1)); // Use const for Duration
    final messageDate =
        DateTime(timeSent!.year, timeSent!.month, timeSent!.day);

    if (messageDate == today) {
      return DateFormat.jm().format(timeSent!);
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(timeSent!);
    }
  }
}
