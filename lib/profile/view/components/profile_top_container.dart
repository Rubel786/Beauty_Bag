import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/constants.dart';
import '../../model/user_profile_model.dart';

class ProfileTopContainer extends StatefulWidget {
  final UserProfileModel user;

  const ProfileTopContainer({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileTopContainer> createState() => _ProfileTopContainerState();
}

class _ProfileTopContainerState extends State<ProfileTopContainer> {
  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (_profileImage != null) {
      imageProvider = FileImage(_profileImage!);
    } else if (widget.user.image.isNotEmpty) {
      imageProvider = NetworkImage(widget.user.image);
    } else {
      imageProvider = const AssetImage('assets/images/default_avatar.jpg');
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, kPrimaryShadowColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      height: 170,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 32,
              backgroundImage: imageProvider,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${widget.user.firstName} ${widget.user.lastName}',
            style: const TextStyle(
              color: Colors.brown,
              fontSize: 20
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.user.phone,
            style: const TextStyle(
            fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontSize: 15
            ),
          ),
        ],
      ),
    );
  }
}