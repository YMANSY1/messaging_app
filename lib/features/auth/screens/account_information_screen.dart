import 'package:flutter/material.dart';
import 'package:messaging_app/features/auth/screens/auth_screen.dart';
import 'package:messaging_app/features/chat/widgets/profile_pic.dart';

import '../../core/user.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.08;
    final remainingSpace = screenHeight * 0.2;

    return Scaffold(
      backgroundColor: Color(0xff505361),
      appBar: AppBar(
        title: const Text(
          'Account Information',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2d3748), // Dark gray AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ProfilePic(
                    user: user,
                    radius: screenWidth * 0.15,
                    fontSize: screenWidth * 0.1),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: double.infinity,
                height: containerHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFF4a5568), // Darker container color
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Username: ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                          Text(user.username!,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                          const Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ))
                        ],
                      ),
                    )),
              ),
              Container(
                width: double.infinity,
                height: containerHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFF4a5568),
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Email: ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                        Text(user.email!,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white)),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: containerHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFF4a5568),
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Password: ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                          const Text('********',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                          const Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ))
                        ],
                      ),
                    )),
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: (screenWidth - 32) * 0.5,
                      height: containerHeight,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4a5568),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(30)),
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1.0),
                          right: BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                Text("Delete",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red)),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => AuthScreen()),
                          (_) => false),
                      child: Container(
                        width: (screenWidth - 32) * 0.5,
                        height: containerHeight,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4a5568),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30)),
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Row(
                                children: [
                                  Text("Logout",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.login_outlined,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: remainingSpace),
            ],
          ),
        ),
      ),
    );
  }
}
