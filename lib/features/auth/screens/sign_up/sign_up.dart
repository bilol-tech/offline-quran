import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../constant/color.dart';
import '../../../../global/common/toasts.dart';
import '../../../core/screens/main_screen.dart';
import '../sign_in/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController name = TextEditingController();

  bool _isObscurePassword = true;
  bool _isObscureReEnterPassword = true;
  late TextEditingController passwordController;
  late TextEditingController repeatPasswordController;
  bool isSigningUp = false;

  Color buttonColor = gray;

  void _updateButtonColor() {
    setState(() {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          name.text.isNotEmpty &&
          repeatPasswordController.text.isNotEmpty) {
        buttonColor = primary;
      } else {
        buttonColor = gray;
      }
    });
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: gray,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    name = TextEditingController();
    repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    name.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  void _toggleObscurePassword() {
    setState(() {
      _isObscurePassword = !_isObscurePassword;
    });
  }

  void _toggleObscureReEnterPassword() {
    setState(() {
      _isObscureReEnterPassword = !_isObscureReEnterPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.020, vertical: screenHeight * 0.015),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: screenHeight * 0.022, fontWeight: FontWeight.bold, color: light ? black : white),
                ),
                SizedBox(
                  height: screenHeight * 0.035,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: light ? const Color(0xffEFEFEF) : modalSheetColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                         SizedBox(height: screenHeight * 0.015),
                        SizedBox(
                          height: screenHeight * 0.042,
                          child: TextFormField(
                            style: TextStyle(color: light ? black : white, fontSize: screenHeight * 0.013),
                            keyboardType: TextInputType.text,
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: text),
                              ),
                              contentPadding: EdgeInsets.only(top: screenHeight * 0.010, left: screenHeight * 0.008),
                              label: const Text("Email *"),
                              labelStyle: TextStyle(fontSize: screenHeight * 0.013, color: light ? Colors.black87 : text),
                            ),
                            cursorHeight: screenHeight * 0.015,
                            onChanged: (_) => _updateButtonColor(),
                            cursorColor: light ? black : white,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.033,
                        ),
                        SizedBox(
                          height: screenHeight * 0.042,
                          child: TextFormField(
                            style: TextStyle(color: light ? black : white, fontSize: screenHeight * 0.013),
                            keyboardType: TextInputType.text,
                            controller: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: light ? Colors.black87 : text),
                              ),
                              contentPadding: EdgeInsets.only(top: screenHeight * 010, left: screenHeight * 0.008),
                              label: const Text("Name/Surname*"),
                              labelStyle: TextStyle(fontSize: screenHeight * 0.013, color: light ? Colors.black87 : text),
                            ),
                            cursorHeight: screenHeight * 0.015,
                            onChanged: (_) => _updateButtonColor(),
                            cursorColor: light ? black : white,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.033,
                        ),
                        SizedBox(
                          height: screenHeight * 0.042,
                          child: TextFormField(
                            style: TextStyle(color: light ? black : white, fontSize: screenHeight * 0.013),
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            obscureText: _isObscurePassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: light ? Colors.black87 : text),
                              ),
                              contentPadding: EdgeInsets.only(top: screenHeight * 0.010, left: screenHeight * 0.008),
                              label: const Text("Password *"),
                              labelStyle: TextStyle(fontSize: screenHeight * 0.013, color: light ? Colors.black87 : text),
                              suffixIcon: GestureDetector(
                                onTap: _toggleObscurePassword,
                                child: Icon(
                                  _isObscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: screenHeight * 0.020,
                                  color: light ? Colors.black87 : text,
                                ),
                              ),
                            ),
                            cursorHeight: screenHeight * 0.015,
                            cursorColor: light ? black : white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.033,
                        ),
                        SizedBox(
                          height: screenHeight * 0.042,
                          child: TextFormField(
                            style: TextStyle(color: light ? black : white, fontSize: screenHeight * 0.013),
                            keyboardType: TextInputType.text,
                            controller: repeatPasswordController,
                            obscureText: _isObscureReEnterPassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: light ? Colors.black87 : text),
                              ),
                              contentPadding: EdgeInsets.only(top: screenHeight * 0.010, left: screenHeight * 0.008),
                              label: const Text("Password again *"),
                              labelStyle: TextStyle(fontSize: screenHeight * 0.013, color: light ? Colors.black87 : text),
                              suffixIcon: GestureDetector(
                                onTap: _toggleObscureReEnterPassword,
                                child: Icon(
                                  _isObscureReEnterPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: screenHeight * 0.020,
                                  color: light ? Colors.black87 : text,
                                ),
                              ),
                            ),
                            cursorHeight: screenHeight * 0.015,
                            cursorColor: light ? black : white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.030,
                        ),
                      InkWell(
                        onTap: () async {
                          if (emailController.text.isEmpty) {
                            showToast(message: 'Email is required.');
                          } else if (!_isValidEmail(emailController.text)) {
                            showToast(message: 'Email is not valid.');
                          } else if (name.text.isEmpty) {
                            showToast(message: 'Name/Surname is required.');
                          } else if (passwordController.text.isEmpty) {
                            showToast(message: 'Password is required.');
                          } else if (passwordController.text.length < 6) {
                            showToast(message: 'Password should be at least 6 characters long.');
                          } else if (repeatPasswordController.text.isEmpty) {
                            showToast(message: 'Repeat password is required.');
                          } else if (passwordController.text != repeatPasswordController.text) {
                            showToast(message: 'Passwords do not match.');
                          } else {
                            try {
                              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              showToast(message: 'Successfully Signed up');
                              if (userCredential.additionalUserInfo!.isNewUser) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(selectedIndex: 0,),
                                  ), (route) => true,
                                );
                              } else {
                                showToast(message: 'Already have an account');
                              }
                            } catch (error) {
                              print('Error creating user: ${error.toString()}');
                              showToast(message: 'Already have an account');
                            }
                          }
                        },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.040),
                            child: Container(
                              height: screenHeight * 0.040,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(5)),
                                  color: buttonColor),
                              child: Center(
                                  child: Text(
                                "Continue",
                                style: TextStyle(color: white, fontSize: screenHeight * 0.012),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.020,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const SignIn(),
                              ), (route) => true,
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: light ? black : white,
                                  fontSize: screenHeight * 0.012,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                "Sign in",
                                style: TextStyle(
                                  color: primary,
                                  fontSize: screenHeight * 0.012,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.005,
                        ),
                      ],
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
