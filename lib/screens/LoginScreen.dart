import 'package:chat_demo/screens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class LoginScreen extends StatefulWidget {
  final String appId;

  const LoginScreen({super.key, required this.appId});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();

  void _login(String userIdInput) async {
    String userId;
    if (userIdInput == '1') {
      userId = 'John';
    } else if (userIdInput == '2') {
      userId = 'William';
    } else {
      print('Invalid input');
      return;
    }

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
              decoration: const InputDecoration(
                  labelText: 'Enter 1 for John or 2 for William'),
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
