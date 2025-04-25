import 'package:flutter/material.dart';

import '../../core/user.dart';
import '../models/conversation.dart';
import '../widgets/user_tile_listview.dart';

class ActiveConversationsView extends StatelessWidget {
  const ActiveConversationsView({
    super.key,
    required this.future,
    required this.user,
  });

  final Future<List<Conversation>> future;
  final User user;

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
                child:
                    UserTileListView(conversations: snapshot.data!, user: user),
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
