import 'package:flutter/material.dart';
import 'package:messaging_app/features/auth/screens/account_information_screen.dart';
import 'package:messaging_app/features/auth/screens/auth_screen.dart';
import 'package:messaging_app/features/chat/screens/all_users_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('InSync'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              // Handle the selected menu item
              if (value == 'account_info') {
                // Navigate to account information screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountInformationScreen(
                      user: widget.user,
                    ),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => AuthScreen()),
                    (_) => false);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'account_info',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.account_circle), // Account info icon
                    SizedBox(width: 8),
                    Text('Account Information'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.logout), // Logout icon
                    SizedBox(width: 8),
                    Text('Log Out'),
                  ],
                ),
              ),
            ],
          ),
        ],
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
          ActiveConversationsView(user: widget.user),
          // Second Tab: All Users
          AllUsersScreen(
            currentUser: widget.user,
          ), // You can add content for the "All Users" tab here
        ],
      ),
    );
  }
}
