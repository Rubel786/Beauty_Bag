import 'package:beauty_bag/profile/view/components/profile_custom_card.dart';
import 'package:flutter/material.dart';
import 'package:beauty_bag/profile/viewmodel/user_profile_viewmodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'components/profile_top_container.dart';
import '../../init_screen.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushReplacementNamed(context, InitScreen.routeName);
      },
      child: ChangeNotifierProvider(
        create: (_) => UserProfileViewmodel(context)..loadUser(),
        child: Consumer<UserProfileViewmodel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: kPrimaryColor,
                  size: 50,
                ),
              );
            }
            if (viewModel.user == null) {
              return Center(child: Text(viewModel.errorMessage ?? "User not found"));
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                backgroundColor: kPrimaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileTopContainer(user: viewModel.user!),
                    const SizedBox(height: 10),
                    ProfileCustomCard(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}