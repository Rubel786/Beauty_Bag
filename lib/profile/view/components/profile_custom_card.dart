import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants.dart';

class ProfileCustomCard extends StatelessWidget {
  const ProfileCustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _builCardItem(0, 'assets/icons/edit_profile.svg', 'Edit Profile'),
          _builCardItem(1, 'assets/icons/settings.svg', 'Settings'),
          _builCardItem(2, 'assets/icons/help_center.svg', 'Help center'),
          _builCardItem(3, 'assets/icons/settings.svg', 'Privacy Policy'),
          _builCardItem(4, 'assets/icons/logout.svg', 'Log Out'),
        ],
      ),
    );
  }

  Widget _builCardItem(int index, String assetPath, String title) {
    return GestureDetector(
      onTap: () {
        //_navigateToScreen(index);
      }, // Adds a popping effect
      child: Card(
        color: Colors.white,
        shadowColor: kPrimaryColor,
        margin: const EdgeInsets.all(10.0),
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
}
