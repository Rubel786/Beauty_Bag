// lib/network/global_api_client.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GlobalApiClient {
  final BuildContext context;
  final String baseUrl = 'https://dummyjson.com';

  GlobalApiClient(this.context);

  Future<http.Response> get(String path) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _buildHeaders(token),
    );
    _handleSessionExpiration(response);
    return response;
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
    _handleSessionExpiration(response);
    return response;
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  void _handleSessionExpiration(http.Response response) {
    if (response.statusCode == 401) {
      _showSessionExpiredDialog();
    }
  }

  void _showSessionExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Session Expired'),
        content: const Text('Your session has expired. Please log in again.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
