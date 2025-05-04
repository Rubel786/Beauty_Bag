import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beauty_bag/login/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://dummyjson.com';

  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['accessToken'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
