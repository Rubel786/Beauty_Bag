import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_profile_model.dart';


class UserProfileService {
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
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (
    error) {
      throw Exception('Failed to login: $error');
    }
  }
}
