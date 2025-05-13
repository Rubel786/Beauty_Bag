import 'package:flutter/material.dart';
import '../../login/service/auth_service.dart';
import '../model/user_profile_model.dart';
import '../service/user_profile_service.dart'; // Adjust the import path

class UserProfileViewmodel extends ChangeNotifier {
  UserProfileModel? user;
  bool isLoading = true;
  String? errorMessage;
  BuildContext context; // Add a BuildContext

  UserProfileViewmodel(this.context); // Constructor to receive the context

  Future<void> loadUser() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await AuthService().getSavedToken();
      if (token == null) {
        throw Exception("Access token not found");
      }

      // Pass the context when creating UserProfileService
      user = await UserProfileService(context).fetchUser(token);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      user = null;
      // Optionally handle specific exceptions here, e.g., "Session expired"
      if (errorMessage == 'Session expired') {
        // The alert and navigation are already handled in UserProfileService
        // You might want to clear local data here if needed.
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}