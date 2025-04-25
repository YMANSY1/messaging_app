import 'package:intl/intl.dart';

class Message {
  BigInt? id;
  BigInt? senderId;
  BigInt? receiverId;
  String? content;
  DateTime? timeSent;
  bool? isRead;
  BigInt? conversationId;

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
    id = json['id'] != null ? _parseBigInt(json['id']) : null;
    senderId = json['senderId'] != null ? _parseBigInt(json['senderId']) : null;
    receiverId =
        json['receiverId'] != null ? _parseBigInt(json['receiverId']) : null;
    content = json['content'] as String?;
    timeSent = _parseDateTime(json['timeSent']);
    isRead = json['isRead'] as bool?;
    conversationId = json['conversationId'] != null
        ? _parseBigInt(json['conversationId'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id?.toString();
    data['senderId'] = senderId?.toString();
    data['receiverId'] = receiverId?.toString();
    data['content'] = content;
    data['timeSent'] = timeSent?.toIso8601String();
    data['isRead'] = isRead;
    data['conversationId'] = conversationId?.toString();
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

  static BigInt? _parseBigInt(dynamic value) {
    if (value == null) return null;
    try {
      if (value is int) {
        return BigInt.from(value);
      } else if (value is String) {
        return BigInt.tryParse(value);
      }
      return null;
    } catch (e) {
      print('Error parsing BigInt: $e, value: $value');
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
