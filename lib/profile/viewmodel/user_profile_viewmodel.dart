import 'package:flutter/material.dart';
import 'package:beauty_bag/profile/model/user_profile_model.dart';

import '../../login/service/auth_service.dart';
import '../service/user_profile_service.dart';



class UserProfileViewmodel extends ChangeNotifier {
  UserProfileModel? user;
  bool isLoading = true;
  String? errorMessage;

  Future<void> loadUser() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await AuthService().getSavedToken();
      if (token == null) {
        throw Exception("Access token not found");
      }

      user = await UserProfileService().fetchUser(token);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      user = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}