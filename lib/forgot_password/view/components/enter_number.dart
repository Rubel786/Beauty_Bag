import 'package:beauty_bag/forgot_password/view/components/enter_otp.dart';
import 'package:beauty_bag/login/view/login_screen.dart';
import 'package:beauty_bag/utils/constants.dart'; // Ensure this contains kPrimaryColor
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../init_screen.dart'; // For SVG assets in EnterOtp


// =======================================================
// EnterNumber Screen - Modified for Firebase Phone Auth Check
// =======================================================

class EnterNumber extends StatefulWidget {
  @override
  State<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false; // State to manage loading indicator

  // Function to show a custom message box instead of alert() or snackbar directly
  void _showMessageBox(String title, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.indigo, fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onOk?.call(); // Call optional callback
              },
            ),
          ],
        );
      },
    );
  }

  void _onContinuePressed() async {
    final phone = _phoneController.text.trim();
    print('Phone number entered: $phone, length: ${phone.length}');

    if (phone.length != 10) {
      _showMessageBox('Invalid Input', 'Please enter a valid 10-digit mobile number.');
      return;
    }

    // Prefix with country code (assuming India +91)
    final phoneNumberWithCode = '+91$phone';

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Initiate phone number verification
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumberWithCode,
        timeout: const Duration(seconds: 60), // Increased timeout
        verificationCompleted: (PhoneAuthCredential credential) async {
          // This callback is fired automatically on Android if the SMS code is auto-retrieved.
          // It implies the number is valid and the process completed.
          setState(() {
            _isLoading = true; // Keep loading until sign-in completes
          });
          try {
            await _auth.signInWithCredential(credential);
            // If sign-in is successful here, it means the user is authenticated.
            // Navigate to InitScreen.
            if (mounted) {
              Navigator.pushReplacementNamed(context, InitScreen.routeName);
            }
          } on FirebaseAuthException catch (e) {
            _showMessageBox('Verification Failed', "Failed to sign in: ${e.message}");
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // This callback is fired when there's an error during verification.
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
          String errorMessage;
          if (e.code == 'invalid-phone-number') {
            // This is the key check for "not registered" in this context
            errorMessage = 'Sorry! This number is not registered or is invalid. Please check the number or register.';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'Too many requests. Please try again later.';
          } else if (e.code == 'network-request-failed') {
            errorMessage = 'Network error. Please check your internet connection.';
          }
          else {
            errorMessage = 'Verification failed: ${e.message ?? 'Unknown error'}';
          }
          _showMessageBox('Error', errorMessage);
          print("Firebase Auth Error: ${e.code} - ${e.message}"); // For debugging
        },
        codeSent: (String verificationId, int? resendToken) {
          // This callback is fired when the SMS code has been successfully sent.
          // It means the phone number is recognized by Firebase for sending OTP.
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
          print("OTP Code Sent. Verification ID: $verificationId"); // For debugging
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnterOtp(
                  phoneNumber: phoneNumberWithCode,
                  initialVerificationId: verificationId,
                  initialResendToken: resendToken,
                ),
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // This callback is fired when SMS code auto-retrieval times out.
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
          _showMessageBox('Auto-retrieval Timeout', 'Auto-retrieval timed out. Please enter the OTP manually.');
          if (mounted) {
            // Still navigate to OTP screen, but user will need to enter manually
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnterOtp(
                  phoneNumber: phoneNumberWithCode,
                  initialVerificationId: verificationId, // Pass verification ID
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator on unexpected error
      });
      _showMessageBox('Error', 'An unexpected error occurred: $e');
      print("Error initiating phone verification: $e"); // For debugging
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      },
      child: Stack( // Use Stack to overlay loading indicator
        children: [
          SingleChildScrollView(
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
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
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
                              'We will send you a one-time\npassword (OTP)',
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
                          onTap: _isLoading ? null : _onContinuePressed, // Disable tap when loading
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isLoading ? Colors.grey : kPrimaryColor, // Change color when disabled
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
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 3,
                              ) // Show loading indicator
                                  : const Icon(Icons.arrow_forward, color: Colors.white),
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
          // Overlay for full screen loading, if needed for initial processes
          if (_isLoading && !(_phoneController.text.length == 10)) // Only show if not specifically handled by button
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
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
