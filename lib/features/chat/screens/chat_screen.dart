import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_app/features/chat/models/message.dart';
import 'package:messaging_app/features/chat/services/chat_service.dart';
import 'package:messaging_app/features/chat/widgets/message_bubble.dart';
import 'package:messaging_app/features/chat/widgets/message_input_widget.dart';
import 'package:messaging_app/features/chat/widgets/profile_pic.dart';
import 'package:messaging_app/features/core/user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user, required this.otherUser});

  final User user;
  final User otherUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final chatService = ChatService(Dio());
  RxList<Message> messages = RxList<Message>([]);
  Rx<BigInt?> conversationId = Rx<BigInt?>(null);

  @override
  void initState() {
    super.initState();
    fetchConversationAndMessages();
  }

  @override
  void dispose() {
    chatService.closeWebSocket();
    super.dispose();
  }

  Future<void> fetchConversationAndMessages() async {
    final conversations = await chatService.fetchAllConversationsForUser(
      user1Id: widget.user.id!,
      user2Id: widget.otherUser.id!,
    );

    if (conversations.isNotEmpty) {
      // Existing conversation case - your code works fine here
      conversationId.value = conversations.first.id != null
          ? BigInt.from(conversations.first.id!)
          : BigInt.from(1);
      chatService.connectToWebSocket(
        widget.user.id!,
        widget.otherUser.id!,
      );

      chatService.listenForMessages((newMessage) {
        if (newMessage.conversationId == conversationId.value) {
          messages.add(newMessage);
        }
      });

      if (conversationId.value != null) {
        final fetchedMessages =
            await chatService.getConversation(conversationId.value!);
        messages.value = RxList<Message>(fetchedMessages);
      }
    } else {
      // No existing conversation - connect to WebSocket to create one
      chatService.connectToWebSocket(
        widget.user.id!,
        widget.otherUser.id!,
      );

      // Wait a moment for the backend to create the conversation
      await Future.delayed(const Duration(milliseconds: 500));

      // Fetch the newly created conversation
      final newConversations = await chatService.fetchAllConversationsForUser(
        user1Id: widget.user.id!,
        user2Id: widget.otherUser.id!,
      );

      if (newConversations.isNotEmpty) {
        conversationId.value = newConversations.first.id != null
            ? BigInt.from(newConversations.first.id!)
            : null;

        print("New conversation created with ID: ${conversationId.value}");
      }

      // Now listen for messages with the updated conversation ID
      chatService.listenForMessages((newMessage) {
        messages.add(newMessage);
      });
    }
  }

  void _sendMessage() {
    if (conversationId.value != null &&
        messageController.text.trim().isNotEmpty) {
      // Send the message as plain text
      chatService.sendMessage(
        messageController.text,
      );

      // Add the message to the local list immediately, with the correct sender.
      messages.add(
        Message(
          senderId: widget.user.id!, // Use BigInt
          receiverId: widget.otherUser.id!, // Use BigInt
          content: messageController.text,
          timeSent: DateTime.now(),
          isRead: false,
          conversationId: conversationId.value!,
        ),
      );
      messageController.clear();
    } else {
      print(
          "Conversation ID is null or message is empty. Cannot send message.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ProfilePic(
              user: widget.otherUser,
              radius: 20,
              fontSize: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.otherUser.username!,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00796B),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.separated(
                reverse: true,
                itemBuilder: (context, index) {
                  final message = messages.reversed.toList()[index];
                  return MessageBubble(
                    message: message,
                    user: widget.user,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: messages.length,
              );
            }),
          ),
          MessageInputWidget(
            controller: messageController,
            onSendPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

extension MessageFromJson on Message {
  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] != null ? _parseBigInt(json['id']) : null,
      senderId:
          json['senderId'] != null ? _parseBigInt(json['senderId']) : null,
      receiverId:
          json['receiverId'] != null ? _parseBigInt(json['receiverId']) : null,
      content: json['content'],
      timeSent: json['timeSent'] != null
          ? DateTime.parse(json['timeSent'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      conversationId: json['conversationId'] != null
          ? _parseBigInt(json['conversationId'])
          : null,
    );
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
