import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/user.dart';
import '../models/conversation.dart';
import '../services/chat_service.dart';
import '../widgets/user_tile_listview.dart';

class ActiveConversationsView extends StatefulWidget {
  const ActiveConversationsView({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<ActiveConversationsView> createState() =>
      _ActiveConversationsViewState();
}

class _ActiveConversationsViewState extends State<ActiveConversationsView> {
  late Future<List<Conversation>> future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user.id != null) {
      future = ChatService(Dio())
          .fetchAllConversationsForUser(user1Id: widget.user.id!);
    } else {
      // Handle error if user.id is null
      future = Future.error("User ID is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Conversation>>(
      future: future,
      builder:
          (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Oops, something went wrong: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Users yet'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16),
                child: Text(
                  'Active Conversations',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: UserTileListView(
                    conversations: snapshot.data!, user: widget.user),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Unexpected state'));
        }
      },
    );
  }
}
