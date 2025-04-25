import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_app/features/chat/models/message.dart';
import 'package:messaging_app/features/chat/services/conversation_service.dart'; // Import your ChatService
import 'package:messaging_app/features/chat/widgets/message_bubble.dart';
import 'package:messaging_app/features/chat/widgets/message_input_widget.dart';
import 'package:messaging_app/features/chat/widgets/profile_pic.dart';
import 'package:messaging_app/features/core/user.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.user, required this.otherUser});

  final User user;
  final User otherUser;
  //  late Future<RxList<Message>> future; // You won't need this anymore
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final chatService = ChatService(Dio()); // Initialize your ChatService
  RxList<Message> messages = RxList<Message>([]); // Use RxList directly
  Rx<BigInt?> conversationId = Rx<BigInt?>(null); // Track the conversationId

  @override
  void initState() {
    super.initState();
    fetchConversationAndMessages(); // Call the new method here
  }

  Future<void> fetchConversationAndMessages() async {
    // Fetch the conversation ID
    final conversations = await chatService.fetchAllConversationsForUser(
      user1Id: widget.user.id!,
      user2Id: widget.otherUser.id!,
    );

    if (conversations.isNotEmpty) {
      conversationId.value = BigInt.from(conversations
          .first.id!); // Assuming the first conversation is the correct one
      // Fetch the messages for the conversation
      if (conversationId.value != null) {
        final fetchedMessages =
            await chatService.getConversation(conversationId.value!);
        messages.value = RxList<Message>(fetchedMessages);
      }
    } else {
      // Handle the case where no conversation exists between the users
      // You might want to create a new conversation here or show an appropriate message
      print(
          "No conversation found between ${widget.user.username} and ${widget.otherUser.username}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ProfilePic(
              user: widget.user,
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
        backgroundColor: const Color(0xFF00796B), // Teal
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
            onSendPressed: () {
              //  messages.add( // You'll likely want to send this message to the server
              //   Message(
              //    content: messageController.text,
              //    timeSent: DateTime.now(),
              //    isRead: false,
              //  ),
              // );
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
