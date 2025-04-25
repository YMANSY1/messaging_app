import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:messaging_app/features/chat/models/conversation.dart';
import 'package:messaging_app/features/chat/models/message.dart';
import 'package:messaging_app/features/core/service_mixin.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService with ServiceMixin {
  final Dio dio;
  WebSocketChannel? channel;

  ChatService(this.dio);

  Future<List<Conversation>> fetchAllConversationsForUser({
    BigInt? user1Id,
    BigInt? user2Id,
  }) async {
    final response = await dio.get(
      chatUrl,
      queryParameters: {
        "user1Id": user1Id,
        "user2Id": user2Id,
      },
    );

    print("fetchAllConversationsForUser - Status Code: ${response.statusCode}");
    print("fetchAllConversationsForUser - Raw Data: ${response.data}");
    print(
        "fetchAllConversationsForUser - Response Data Type: ${response.data.runtimeType}");

    try {
      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> conversationJson = []; // Initialize as an empty list

        if (response.data is List<dynamic>) {
          conversationJson = response.data;
        } else if (response.data is Map<String, dynamic>) {
          conversationJson = [response.data]; // Wrap the Map in a List
        } else {
          print(
              "fetchAllConversationsForUser - Unexpected response type: ${response.data.runtimeType} (Expected List or Map)");
          return [];
        }

        List<Conversation> conversations = conversationJson
            .map((json) => Conversation.fromJson(json))
            .toList();

        print(
            "fetchAllConversationsForUser - Parsed ${conversations.length} conversations");
        return conversations;
      } else {
        print("fetchAllConversationsForUser - Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("fetchAllConversationsForUser - Error fetching conversations: $e");
      return [];
    }
  }

  Future<List<Message>> getConversation(BigInt conversationId) async {
    final response = await dio.get(
      '$chatUrl/conversation',
      queryParameters: {
        'conversationId': conversationId,
      },
    );
    try {
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List<dynamic>) {
          List<Message> messages = (response.data
                  as List<dynamic>) // *** Explicit cast ***
              .map((messageJson) =>
                  Message.fromJson(messageJson)) // *** Parse each message ***
              .toList();
          print("getConversation - Fetched ${messages.length} messages");
          return messages;
        } else {
          print(
              "getConversation - Unexpected response type: ${response.data.runtimeType} (Expected List)");
          return [];
        }
      } else {
        print("getConversation - Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("getConversation - Error fetching messages: $e");
      return [];
    }
  }

  void connectToWebSocket(BigInt senderId, BigInt receiverId) {
    final wsUrl = 'ws://10.0.2.2:8080/ws?sender=$senderId&receiver=$receiverId';
    try {
      print("WebSocket URL: $wsUrl");
      print("Sender ID (type: ${senderId.runtimeType}): $senderId");
      print("Receiver ID (type: ${receiverId.runtimeType}): $receiverId");
      channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      channel?.ready.then((_) {
        print("WebSocket connected successfully!");
        print("Sending initial message (if any)");
      }, onError: (error) {
        print("WebSocket connection error: $error");
      });
    } catch (e) {
      print('Error connecting to WebSocket: $e');
    }
  }

  void sendMessage(String content) {
    if (channel != null) {
      channel?.sink.add(content);
    } else {
      print('WebSocket is not connected.');
    }
  }

  void listenForMessages(Function(Message) onMessageReceived) {
    channel?.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      final newMessage = Message.fromJson(decodedMessage);
      onMessageReceived(newMessage);
    }, onError: (error) {
      print('WebSocket Error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  void closeWebSocket() {
    channel?.sink.close();
    channel = null;
  }
}
