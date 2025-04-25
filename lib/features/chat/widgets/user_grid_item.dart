import 'package:flutter/material.dart';
import 'package:messaging_app/features/chat/widgets/profile_pic.dart';

import '../../core/user.dart';

class UserGridItem extends StatelessWidget {
  const UserGridItem({
    super.key,
    required this.user,
    required this.onStartConversation,
  });

  final User user;
  final VoidCallback onStartConversation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Card(
        elevation: 12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePic(user: user, radius: 40, fontSize: 35),
            const SizedBox(height: 8),
            Text(
              user.username ?? 'Unknown',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  10, 8, 10, 0), // Reduced bottom padding
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onStartConversation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text(
                    'Start Chat',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
