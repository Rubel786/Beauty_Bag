import 'package:beauty_bag/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:beauty_bag/init_screen.dart';
import 'package:provider/provider.dart';
import '../../utils/exit_handler.dart';
import '../viewmodel/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ExitHandler _exitHandler = ExitHandler();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (void didPop) async {
        _exitHandler.pressExit(context);
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image (Replace with your image path)
            Image.asset(
              'assets/images/bg.jpg', // Ensure you have this image in your assets
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ChangeNotifierProvider(
                  create: (context) => LoginViewModel(),
                  child: Consumer<LoginViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.user != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(context, InitScreen.routeName);
                        });
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Welcome back, Eloise.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(height: 10),
                          // Regular Container (No Clipper)
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    hintText: 'Enter your username',
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: '********',
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                     TextButton(
                                       onPressed: () {
                                        // Handle forgot password
                                         },
                                      child: Text(
                                          'Forgot Password',
                                        style: TextStyle(
                                          color: Colors.brown,
                                          fontFamily: "Mulish",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: viewModel.isLoading
                                      ? null // Disable button when loading
                                      : () {
                                    viewModel.login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink.shade50,
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  child: viewModel.isLoading
                                      ? CircularProgressIndicator()
                                      :Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontFamily: "Mulish",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                if (viewModel.errorMessage != null) // Error Display in Container
                                   Text(
                                      viewModel.errorMessage!,
                                      style: TextStyle(color: Colors.red),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}