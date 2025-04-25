import 'package:dio/dio.dart';
import 'package:messaging_app/features/core/service_mixin.dart';

import '../../core/user.dart';

class AuthService with ServiceMixin {
  final Dio dio;

  AuthService(this.dio);

  Future<User?> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await dio.post(
        '$authUrl/register',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          'email': email,
          'password': password,
          'username': username,
        },
      );

      if (response.statusCode == 201) {
        print('✅ Registration successful');
        // Assuming that the response contains the user data as JSON
        return User.fromJson(response.data);
      } else {
        print(
            '❌ Unexpected response: ${response.statusCode} - ${response.data}');
        throw Exception('Unexpected error');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data.toString();

        if (statusCode == 400) {
          throw Exception("⚠️ Missing fields: $message");
        } else if (statusCode == 409) {
          throw Exception("❌ Email or username already taken: $message");
        } else if (statusCode == 500) {
          throw Exception("🚨 Server error: $message");
        } else {
          throw Exception("❓ Unknown error (${statusCode}): $message");
        }
      } else {
        throw Exception("❌ No response from server: ${e.message}");
      }
    } catch (e) {
      throw Exception("❌ Unexpected error: ${e.toString()}");
    }
  }

  Future<User?> loginUser({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$authUrl/login',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          'email_or_username': emailOrUsername,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print('✅ Login Successful');
        return User.fromJson(response.data);
      } else {
        print(
            '❌ Unexpected response: ${response.statusCode} - ${response.data}');
        throw Exception('Unexpected error');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data.toString();

        if (statusCode == 400) {
          throw Exception("⚠️ Missing fields: $message");
        } else if (statusCode == 401) {
          throw Exception("❌ Invalid credentials: $message");
        } else if (statusCode == 500) {
          throw Exception("🚨 Server error: $message");
        } else {
          throw Exception("❓ Unknown error ($statusCode): $message");
        }
      } else {
        throw Exception("❌ No response from server: ${e.message}");
      }
    } catch (e) {
      throw Exception("❌ Unexpected error: ${e.toString()}");
    }
  }
}
