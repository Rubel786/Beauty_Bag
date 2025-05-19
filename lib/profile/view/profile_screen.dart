import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../init_screen.dart';
import '../../utils/constants.dart';
import '../viewmodel/user_profile_viewmodel.dart';
import 'components/profile_custom_card.dart';
import 'components/profile_top_container.dart';
import 'components/profile_top_shimmer.dart';


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
        child: Scaffold(
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
          body: Consumer<UserProfileViewmodel>(
            builder: (context, viewModel, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (viewModel.isLoading)
                      const ProfileTopShimmer() // Custom shimmer widget
                    else if (viewModel.user != null)
                      ProfileTopContainer(user: viewModel.user!)
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(viewModel.errorMessage ?? 'User not found'),
                      ),
                    const SizedBox(height: 10),
                    ProfileCustomCard(), // Always rendered
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
