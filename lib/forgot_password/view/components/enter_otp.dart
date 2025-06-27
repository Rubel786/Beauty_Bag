import 'package:beauty_bag/forgot_password/view/forgot_password_screen.dart';
import 'package:beauty_bag/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/constants.dart'; // For SVG assets

// Placeholder

class EnterOtp extends StatefulWidget {
  static String routeName = "/otp_screen";
  final String phoneNumber;

  const EnterOtp({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<EnterOtp> createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  bool _isSendingOtp = false; // To prevent multiple OTP send requests
  bool _isLoading = false; // For showing a loading indicator during verification

  // Controllers for each OTP input field
  final List<TextEditingController> _otpControllers =
  List.generate(6, (index) => TextEditingController());
  // Focus nodes for each OTP input field
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Delay sending OTP slightly to ensure widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendOTP();
    });
  }

  @override
  void dispose() {
    // Dispose of all controllers and focus nodes when the widget is removed
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Function to show a custom message box
  void _showMessageBox(String title, String message) {
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
              },
            ),
          ],
        );
      },
    );
  }

  void _sendOTP() async {
    if (_isSendingOtp) return; // Prevent multiple calls
    setState(() {
      _isSendingOtp = true;
      _isLoading = true; // Show loading while sending OTP
    });

    _showMessageBox('Sending OTP', 'Sending verification code to ${widget.phoneNumber}...');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(seconds: 60), // Increased timeout for better reliability
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval on Android
          setState(() {
            _isLoading = true; // Keep loading until sign-in completes
          });
          try {
            await _auth.signInWithCredential(credential);
            _goToNext();
          } on FirebaseAuthException catch (e) {
            _showMessageBox('Verification Failed', "Failed to sign in: ${e.message}");
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isSendingOtp = false;
            _isLoading = false;
          });
          String errorMessage;
          if (e.code == 'invalid-phone-number') {
            errorMessage = 'The provided phone number is not valid.';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'Too many requests. Please try again later.';
          } else {
            errorMessage = 'Verification failed: ${e.message ?? 'Unknown error'}';
          }
          _showMessageBox('Verification Failed', errorMessage);
          print("Firebase Auth Error: ${e.code} - ${e.message}"); // For debugging
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isSendingOtp = false;
            _isLoading = false;
          });
          _showMessageBox('OTP Sent', 'A 6-digit code has been sent to ${widget.phoneNumber}.');
          print("OTP Code Sent. Verification ID: $_verificationId"); // For debugging
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
            _isSendingOtp = false;
            _isLoading = false;
          });
          _showMessageBox('Auto-retrieval Timeout', 'Auto-retrieval timed out. Please enter the OTP manually.');
        },
      );
    } catch (e) {
      setState(() {
        _isSendingOtp = false;
        _isLoading = false;
      });
      _showMessageBox('Error', 'An unexpected error occurred while sending OTP: $e');
      print("Error sending OTP: $e"); // For debugging
    }
  }

  void _verifyOTP() async {
    // 1. Correctly get the OTP from all _otpControllers
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (_verificationId == null || otp.length != 6) {
      _showMessageBox('Missing Information', 'Please ensure you have received an OTP and entered all 6 digits.');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading during verification
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      _goToNext();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'invalid-verification-code') {
        errorMessage = 'The OTP entered is invalid. Please try again.';
      } else if (e.code == 'session-expired') {
        errorMessage = 'The verification code has expired. Please resend OTP.';
      } else {
        errorMessage = 'Verification failed: ${e.message ?? 'Unknown error'}';
      }
      _showMessageBox('Verification Failed', errorMessage);
      print("Firebase Auth Error during OTP verification: ${e.code} - ${e.message}"); // For debugging
    } catch (e) {
      _showMessageBox('Error', 'An unexpected error occurred during verification: $e');
      print("Error during OTP verification: $e"); // For debugging
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToNext() {
    // Ensure you have defined these routes or replace with direct navigation
    Navigator.pushReplacementNamed(context, InitScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, ForgotPasswordScreen.routeName);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Enter Verification Code',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - 16, // Adjust height
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    SvgPicture.asset(
                      "assets/icons/otp.svg",
                      height: 100,
                      width: 100,
                      colorFilter: const ColorFilter.mode(Colors.brown, BlendMode.srcIn), // Use colorFilter for SVG
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'We have sent OTP to ${widget.phoneNumber}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    RawKeyboardListener(
                      focusNode: FocusNode(), // A focus node for the listener itself
                      onKey: (RawKeyEvent event) {
                        // Handle paste event (Ctrl+V or Cmd+V)
                        if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyV && (event.isControlPressed || event.isMetaPressed)) {
                          Clipboard.getData(Clipboard.kTextPlain).then((ClipboardData? data) {
                            final String? pasteData = data?.text?.trim();
                            if (pasteData != null && RegExp(r'^\d{6}$').hasMatch(pasteData)) {
                              setState(() {
                                for (int i = 0; i < pasteData.length; i++) {
                                  _otpControllers[i].text = pasteData[i];
                                }
                                // Move focus to the last input after pasting
                                _focusNodes[5].requestFocus();
                              });
                            } else if (pasteData != null && pasteData.isNotEmpty) {
                              // Only show message if something was pasted but it's invalid OTP
                              _showMessageBox('Invalid Input', 'Invalid OTP format. Please paste a 6-digit number.');
                              // Clear all fields if invalid paste
                              setState(() {
                                for (var controller in _otpControllers) {
                                  controller.clear();
                                }
                              });
                            }
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 40,
                            height: 40,
                            child: TextFormField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                              maxLength: 1, // Max length of 1 character per field
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                              ],
                              decoration: InputDecoration(
                                counterText: '', // Hide the character counter
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 2), // Gray-300
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.brown, width: 2), // Brown focus
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 2), // Gray-300
                                ),
                                contentPadding: EdgeInsets.zero, // Remove extra padding
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  // If a digit is entered, move focus to the next field
                                  if (index < _focusNodes.length - 1) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else {
                                    // If it's the last field, unfocus and verify
                                    _focusNodes[index].unfocus();
                                    // Automatically attempt verification only if all fields are filled
                                    if (_otpControllers.every((c) => c.text.isNotEmpty)) {
                                      _verifyOTP();
                                    }
                                  }
                                } else if (value.isEmpty) {
                                  // If backspace/delete, move focus to the previous field
                                  if (index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                    // Clear the previous field if moving back
                                    _otpControllers[index - 1].clear();
                                  }
                                }
                              },
                              onEditingComplete: () {
                                // This can be used to move focus or submit when 'Done' is pressed
                                _focusNodes[index].unfocus();
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Verify OTP Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOTP, // Disable button while loading
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown, // Brown button
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 4, // Shadow for the button
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Resend OTP text
                    GestureDetector(
                      onTap: _isLoading ? null : _sendOTP, // Disable resend while loading
                      child: Text.rich(
                        TextSpan(
                          text: "Didn't receive the code? ",
                          style: TextStyle(fontSize: 14, color: _isLoading ? Colors.grey : const Color(0xFF6B7280)), // Gray-500
                          children: [
                            TextSpan(
                              text: 'Resend OTP',
                              style: TextStyle(
                                color: _isLoading ? Colors.grey : Colors.brown, // Brown resend link
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading) // Overlay for general loading, e.g., during initial OTP send
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
      ),
    );
  }
}
