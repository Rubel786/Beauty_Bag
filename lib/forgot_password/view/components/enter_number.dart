import 'package:beauty_bag/forgot_password/view/components/enter_otp.dart';
import 'package:beauty_bag/login/view/login_screen.dart';
import 'package:beauty_bag/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterNumber extends StatefulWidget {

  @override
  State<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final TextEditingController _phoneController = TextEditingController();

  void _onContinuePressed() {
    final phone = _phoneController.text.trim();
    print('Phone number entered: $phone, length: ${phone.length}');
    if (phone.length != 10) {
      print('Invalid phone number length. Showing SnackBar.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit number')),
      );
      return;
    }
    print('Navigating to EnterOtp screen.');
    final phoneNumber = '+91$phone';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterOtp(phoneNumber: phoneNumber),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      },
      child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: BottomConcaveClipper(),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 60),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black,),
                        ],
                        border: Border.all(color: Colors.black12,)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            readOnly: true,
                            decoration: const InputDecoration(
                              hintText: "(+91) India",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown, width: 1.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown, width: 1.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: const InputDecoration(
                              counterText: '',
                              hintText: "Enter your mobile number",
                              hintStyle: TextStyle(fontSize: 16),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown, width: 1.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown, width: 1.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            'We will send you one time\npassword (OTP)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.brown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                   Positioned(
                    bottom: -28,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _onContinuePressed,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.arrow_forward, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}

class BottomConcaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double radius = 38;
    final double centerX = size.width / 2;
    final double centerY = size.height;

    path.moveTo(0, 0);
    path.lineTo(0, size.height - radius);
    path.arcToPoint(
      Offset(centerX - radius, size.height),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(centerX + radius, size.height),
      radius: Radius.circular(radius),
    );
    path.arcToPoint(
      Offset(size.width, size.height - radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
