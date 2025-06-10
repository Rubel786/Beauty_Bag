import 'package:flutter/material.dart';
import '../model/user_profile_model.dart';
import '../service/user_profile_service.dart';

class UserProfileViewmodel extends ChangeNotifier {
  UserProfileModel? user;
  bool isLoading = true;
  String? errorMessage;
  final BuildContext context;

  UserProfileViewmodel(this.context); // Injected context used by the service

  Future<void> loadUser() async {
    isLoading = true;
    notifyListeners();

    try {
      user = await UserProfileService(context).fetchUser();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      user = null;
      // Session expiration dialog is already handled globally in the service
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
