import 'package:dio/dio.dart';
import 'package:messaging_app/features/chat/models/conversation.dart';
import 'package:messaging_app/features/chat/models/message.dart';
import 'package:messaging_app/features/core/service_mixin.dart';

class ChatService with ServiceMixin {
  final Dio dio;

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
}
