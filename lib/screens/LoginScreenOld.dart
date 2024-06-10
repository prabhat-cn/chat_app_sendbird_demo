import 'package:chat_demo/screens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class LoginScreenOld extends StatefulWidget {
  final String appId;

  const LoginScreenOld({super.key, required this.appId});

  @override
  _LoginScreenOldState createState() => _LoginScreenOldState();
}

class _LoginScreenOldState extends State<LoginScreenOld> {
  final TextEditingController _userIdController = TextEditingController();

  void _login(String userId) async {
    try {
      SendbirdSdk(appId: widget.appId);
      User user = await SendbirdSdk().connect(userId);
      print('Login successful: ${user.userId}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            userId: userId,
            appId: widget.appId,
            // otherUserIds: const ["Tanisha"],
          ),
        ),
      );
    } catch (e) {
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _login(_userIdController.text),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
