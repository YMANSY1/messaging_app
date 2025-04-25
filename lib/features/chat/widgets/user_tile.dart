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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          otherUser?.username ?? "No name",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          conversation.lastMessage?.formatMessageTimestamp() ??
                              "no date",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          // Wrap the Text widget with Expanded
                          child: Text(
                            '${conversation.lastMessage!.senderId == user.id ? 'You' : otherUser?.username ?? 'Unknown'}: ${conversation.lastMessage!.content}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        conversation.lastMessage!.senderId == user.id
                            ? const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.done_all,
                                  color: Colors.blueGrey,
                                  size: 20,
                                ),
                              )
                            : const SizedBox()
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
