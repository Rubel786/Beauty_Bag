// UserProfileService.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/global_api_client.dart';
import '../model/user_profile_model.dart';

class UserProfileService {
  final BuildContext context;

  UserProfileService(this.context);

  Future<UserProfileModel> fetchUser() async {
    final api = GlobalApiClient(context);
    final response = await api.get('/auth/me');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfileModel.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
