import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class MiddleContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      top: 90, // Adjust to overlap the container
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/face.jpg',
                      width: 50.0,
                      height: 45.0,
                    ),
                    Text("FACE", style: TextStyle(fontSize: 20)),
                  ],
                ),

                Column(
                  children: [
                    // Icon(Icons.remove_red_eye_sharp, color: Colors.orange),
                    Image.asset(
                      'assets/images/eye.jpg',
                      width: 50.0,
                      height: 45.0,
                    ),
                    Text("EYE", style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/lips.jpg',
                      width: 50.0,
                      height: 45.0,
                    ),
                    Text("LIPS", style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/skin.jpg',
                      width: 50.0,
                      height: 45.0,
                    ),
                    Text("SKIN", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
