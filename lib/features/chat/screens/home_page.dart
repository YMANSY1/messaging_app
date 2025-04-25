import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/features/chat/models/conversation.dart';
import 'package:messaging_app/features/chat/screens/all_users_screen.dart';
import 'package:messaging_app/features/chat/services/conversation_service.dart';

import '../../core/user.dart';
import 'active_conversations_view.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Conversation>> _future;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.user.id != null) {
      _future = ChatService(Dio())
          .fetchAllConversationsForUser(user1Id: widget.user.id!);
    } else {
      // Handle error if user.id is null
      _future = Future.error("User ID is null");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InSync'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active Conversations'),
            Tab(text: 'All Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // First Tab: Active Conversations
          ActiveConversationsView(future: _future, user: widget.user),
          // Second Tab: All Users (currently empty)
          AllUsersScreen(
            currentUser: widget.user,
          ), // You can add content for the "All Users" tab here
        ],
      ),
    );
  }
}
