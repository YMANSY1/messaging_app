import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/user.dart';
import '../models/message.dart'; // Assuming this is the correct path for the Message model

class MessageBubble extends StatelessWidget {
  final Message message;
  final User user;
  late final isSentByMe = message.senderId == user.id;
  MessageBubble({super.key, required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxBubbleWidth = constraints.maxWidth * 0.7;
        return Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
            child: Container(
              decoration: BoxDecoration(
                color: isSentByMe ? const Color(0xFF6DACA7) : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: isSentByMe
                      ? const Radius.circular(0)
                      : const Radius.circular(15),
                  bottomLeft: isSentByMe
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                  bottomRight: const Radius.circular(15),
                ),
              ),
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    message.content!,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        DateFormat.jm().format(message.timeSent!),
                        style: TextStyle(
                          color: isSentByMe ? Colors.white : Colors.black87,
                          fontSize: 10.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      isSentByMe
                          ? Icon(
                              Icons.done_all,
                              color: message.isRead!
                                  ? Colors.blueAccent
                                  : Colors.white,
                              size: 16,
                            )
                          : SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
