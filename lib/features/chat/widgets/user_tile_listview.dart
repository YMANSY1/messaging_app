import 'package:flutter/material.dart';
import 'package:messaging_app/features/chat/models/conversation.dart';

import '../../core/user.dart';
import 'user_tile.dart';

class UserTileListView extends StatelessWidget {
  const UserTileListView({
    super.key,
    required this.conversations,
    required this.user,
  });

  final List<Conversation> conversations;

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (BuildContext context, int index) {
        final conversation = conversations[index];
        return UserTile(
          conversation: conversation,
          user: user,
        );
      },
    );
  }
}
