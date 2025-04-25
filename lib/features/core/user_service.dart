import 'package:dio/dio.dart';
import 'package:messaging_app/features/core/service_mixin.dart';
import 'package:messaging_app/features/core/user.dart';

class UserService with ServiceMixin {
  final Dio dio;

  UserService({required this.dio});

  Future<List<User>> getAllUsers(BigInt id) async {
    try {
      final response = await dio.get(
        authUrl,
        queryParameters: {
          'except': id,
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> usersJson = response.data;
        List<User> users =
            usersJson.map((userData) => User.fromJson(userData)).toList();
        return users;
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }
}
