import '../../core/user.dart';
import 'message.dart';

class Conversation {
  int? id;
  User? user1;
  User? user2;
  Message? lastMessage;

  Conversation({this.id, this.user1, this.user2, this.lastMessage});

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user1 = json['user1'] != null ? User.fromJson(json['user1']) : null;
    user2 = json['user2'] != null ? User.fromJson(json['user2']) : null;
    lastMessage = json['lastMessage'] != null
        ? Message.fromJson(json['lastMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    if (user1 != null) {
      data['user1'] = user1!.toJson();
    }
    if (user2 != null) {
      data['user2'] = user2!.toJson();
    }
    if (lastMessage != null) {
      data['lastMessage'] = lastMessage!.toJson();
    }
    return data;
  }
}
