import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/features/core/user.dart';
import 'package:messaging_app/features/core/user_service.dart';

import '../widgets/user_grid_item.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserService(dio: Dio()).getAllUsers(widget.currentUser.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns in the grid
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8, // Adjust as needed
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserGridItem(
                  user: user,
                  onStartConversation: () {
                    //  implement the action here.
                    print('Start conversation with ${user.username}');
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No users found.'));
          }
        },
      ),
    );
  }
}
