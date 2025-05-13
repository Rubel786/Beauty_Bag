import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_profile_model.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart'; // For showing the alert dialog

class UserProfileService {
  final BuildContext context; // Need context to show dialog

  UserProfileService(this.context);

  Future<UserProfileModel> fetchUser(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/auth/me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response Data: $data');
        return UserProfileModel.fromJson(data);
      } else if (response.statusCode == 401) {
        // Token has expired
        _showSessionExpiredAlert();
        throw Exception('Session expired'); // Or a custom exception
      } else {
        throw Exception('Failed to fetch user profile: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to fetch user profile: $error');
    }
  }

  void _showSessionExpiredAlert() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Expired'),
          content: Text('Your session has expired. Please log in again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Navigate to the login screen and clear any user data/tokens
                Navigator.of(context).pushReplacementNamed('/login'); // Replace '/login' with your actual login route
              },
            ),
          ],
        );
      },
    );
  }
}
