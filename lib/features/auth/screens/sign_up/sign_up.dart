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
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: white),
                ),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: modalSheetColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: TextStyle(color: white, fontSize: 13),
                            keyboardType: TextInputType.text,
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: text),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 10, left: 8),
                              label: const Text("Email *"),
                              labelStyle: TextStyle(fontSize: 13, color: text),
                            ),
                            cursorHeight: 15,
                            onChanged: (_) => _updateButtonColor(),
                            cursorColor: white,
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: TextStyle(color: white, fontSize: 13),
                            keyboardType: TextInputType.text,
                            controller: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: text),
                              ),
                              contentPadding:
                              const EdgeInsets.only(top: 10, left: 8),
                              label: const Text("Name/Surname*"),
                              labelStyle: TextStyle(fontSize: 13, color: text),
                            ),
                            cursorHeight: 15,
                            onChanged: (_) => _updateButtonColor(),
                            cursorColor: white,
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: TextStyle(color: white, fontSize: 13),
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            obscureText: _isObscurePassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: text),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 10, left: 8),
                              label: const Text("Password *"),
                              labelStyle: TextStyle(fontSize: 13, color: text),
                              suffixIcon: GestureDetector(
                                onTap: _toggleObscurePassword,
                                child: Icon(
                                  _isObscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                  color: text,
                                ),
                              ),
                            ),
                            cursorHeight: 15,
                            cursorColor: white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: TextStyle(color: white, fontSize: 13),
                            keyboardType: TextInputType.text,
                            controller: repeatPasswordController,
                            obscureText: _isObscureReEnterPassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: text),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 10, left: 8),
                              label: const Text("Password again *"),
                              labelStyle: TextStyle(fontSize: 13, color: text),
                              suffixIcon: GestureDetector(
                                onTap: _toggleObscureReEnterPassword,
                                child: Icon(
                                  _isObscureReEnterPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                  color: text,
                                ),
                              ),
                            ),
                            cursorHeight: 15,
                            cursorColor: white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
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
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => const MainScreen(selectedIndex: 0),
                                    transitionsBuilder: (_, animation, __, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(5)),
                                  color: buttonColor),
                              child: Center(
                                  child: Text(
                                "Continue",
                                style: TextStyle(color: white, fontSize: 12),
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const SignIn(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      // Start from right side
                                      end: Offset.zero, // Move to the center
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                "Sign in",
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
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
