import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_app/features/auth/controllers/auth_controller.dart';
import 'package:messaging_app/features/auth/services/auth_service.dart';
import 'package:messaging_app/features/auth/widgets/auth_button.dart';
import 'package:messaging_app/features/auth/widgets/auth_field.dart';
import 'package:messaging_app/features/auth/widgets/forgot_password_button.dart';
import 'package:messaging_app/features/chat/screens/home_page.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Stack(
              children: [
                // Gradient background
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFF612F),
                        Color(0xFFEA9C46), // Soft peach
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to InSync',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        Obx(() {
                          return Text(
                            authController.isLogin.value ? 'Login' : 'Register',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight * 0.3 * 0.2,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 16.0,
                top: screenHeight * 0.05,
                left: 16,
                right: 16,
              ),
              child: Obx(() {
                return AuthField(
                  controller: _emailController,
                  labelText: authController.isLogin.value
                      ? 'Email or Username'
                      : 'Email',
                  prefixIcon: Icon(Icons.mail),
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                );
              }),
            ),
            Obx(() {
              return !authController.isLogin.value
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                        bottom: 16,
                      ),
                      child: AuthField(
                        controller: _usernameController,
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                    )
                  : SizedBox();
            }),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16,
                bottom: 16,
              ),
              child: Obx(() {
                return AuthField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  obscureText: authController.isObscured.value,
                  postfixIcon: IconButton(
                    icon: Icon(authController.isObscured.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => authController.toggleObscured(),
                  ),
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GreyTextButton(
                onPressed: () {},
                text: 'Forgot Password?',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Obx(() {
                return Center(
                  child: AuthButton(
                    onPressed: () async {
                      if (!authController.isLogin.value) {
                        // Registration logic
                        await registerUser(context);
                      } else {
                        // Login logic
                        await loginUser(context);
                      }
                    },
                    text: authController.isLogin.value ? 'Login' : 'Register',
                    width: screenWidth * 0.5,
                  ),
                );
              }),
            ),
            Obx(() {
              return GreyTextButton(
                onPressed: () {
                  authController.toggleMode();
                  _emailController.clear();
                  _passwordController.clear();
                  _usernameController.clear();
                  authController.isObscured.value = true;
                },
                text: authController.isLogin.value
                    ? 'No account yet? Register now!'
                    : 'Already have an account? Login now!',
              );
            })
          ],
        ),
      ),
    );
  }

  Future<void> loginUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authService = AuthService(Dio());
      try {
        final loggedInUser = await authService.loginUser(
          emailOrUsername: _emailController.text,
          password: _passwordController.text,
        );
        if (loggedInUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Logged in successfully')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => HomePage(user: loggedInUser),
            ),
            (_) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Invalid username or password')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> registerUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authService = AuthService(Dio());
      try {
        final registeredUser = await authService.registerUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🎉 Registered successfully')),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => HomePage(user: registeredUser!),
          ),
          (_) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
