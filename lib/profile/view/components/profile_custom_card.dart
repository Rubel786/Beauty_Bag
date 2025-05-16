import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants.dart';
import '../../../utils/logout_confirmation_dialog.dart';

class ProfileCustomCard extends StatelessWidget {
  const ProfileCustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _builCardItem(context, 0, 'assets/icons/edit_profile.svg', 'Edit Profile'),
          _builCardItem(context, 1, 'assets/icons/settings.svg', 'Settings'),
          _builCardItem(context ,2, 'assets/icons/help_center.svg', 'Help center'),
          _builCardItem(context, 3, 'assets/icons/privacy_policy.svg', 'Privacy Policy'),
          _builCardItem(context, 4, 'assets/icons/logout.svg', 'Log Out'),
        ],
      ),
    );
  }

  Widget _builCardItem(BuildContext context, int index, String assetPath, String title) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shadowColor: kPrimaryColor,
      margin: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () => _navigateToScreen(context, index),
        borderRadius: BorderRadius.circular(4.0),
        splashColor: kPrimaryColor.withAlpha(51),
        highlightColor: kPrimaryColor.withAlpha(25),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    assetPath,
                    height: 30,
                    width: 30,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.brown),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    final disabledIndexes = <int>{0,1,2,3};
    if (disabledIndexes.contains(index)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This feature is temporarily disabled')),
      );
      return;
    }
    switch (index) {
      case 4:
        showLogoutDialog(context);
        break;
    }
  }
}
