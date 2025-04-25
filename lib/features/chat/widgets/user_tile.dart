import 'package:flutter/material.dart';
import 'package:messaging_app/features/chat/models/conversation.dart';
import 'package:messaging_app/features/chat/models/message.dart';
import 'package:messaging_app/features/chat/screens/chat_screen.dart';
import 'package:messaging_app/features/chat/widgets/profile_pic.dart';

import '../../core/user.dart';

class UserTile extends StatelessWidget {
  UserTile({
    super.key,
    required this.conversation,
    required this.user,
  });

  final User user;

  late final otherUser = conversation.user1?.id == user.id
      ? conversation.user2
      : conversation.user1;

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        splashColor: Colors.grey.withValues(alpha: 0.4),
        highlightColor: Colors.grey.withValues(alpha: 0.15),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              otherUser: otherUser!,
              user: user,
            ),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16.0, bottom: 16, left: 8, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePic(
                user: otherUser ?? User(),
                radius: 25,
                fontSize: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          otherUser?.username ?? "No name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          conversation.lastMessage?.formatMessageTimestamp() ??
                              "no date",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${conversation.lastMessage!.senderId == user.id ? 'You' : otherUser?.username ?? 'Unknown'}: ${conversation.lastMessage!.content}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        conversation.lastMessage!.senderId == user.id
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.done_all,
                                  color: Colors.blueGrey,
                                  size: 20,
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
