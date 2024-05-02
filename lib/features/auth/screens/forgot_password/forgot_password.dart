import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constant/color.dart';
import '../../../../global/common/toasts.dart';
import '../sign_in/sign_in.dart';

class ForgotPassword extends StatefulWidget {
  final String email;
  const ForgotPassword({super.key, required this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController loginController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loginController = TextEditingController();
  }

  @override
  void dispose() {
    loginController.dispose();
    super.dispose();
  }


  Color buttonColor = gray;

  void _updateButtonColor() {
    setState(() {
      if (loginController.text.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      appBar: AppBar(
        backgroundColor: light ? lightBackgroundYellow : background,
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        }, child: Icon(Icons.arrow_back, size: screenHeight * 0.020, color: light ? black : text,)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.020, vertical: screenHeight * 0.015),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forget Password?',
                  style: TextStyle(
                      fontSize: screenHeight * 0.022, fontWeight: FontWeight.bold, color: light ? black : white),
                ),
                Text(
                  'Enter your email address',
                  style: TextStyle(
                      fontSize: screenHeight * 0.014,
                      fontWeight: FontWeight.bold,
                      color: light ? Colors.black87 : white.withOpacity(0.7)),
                ),
                SizedBox(
                  height: screenHeight * 0.010,
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
                        SizedBox(height: screenHeight * 0.020,),
                        SizedBox(
                          height: screenHeight * 0.042,
                          child: TextFormField(
                            style: TextStyle(color: light ? black : white, fontSize: screenHeight * 0.013),
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            initialValue: widget.email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: text),
                              ),
                              contentPadding:
                              EdgeInsets.only(top: screenHeight * 0.010, left: screenHeight * 0.008),
                              label: const Text("Login"),
                              labelStyle: TextStyle(fontSize: screenHeight * 0.013, color: light ? Colors.black87 : text),
                            ),
                            cursorHeight: screenHeight * 0.015,
                            cursorColor: white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.030,),
                        InkWell(
                          onTap: () {
                            if (widget.email.isEmpty) {
                              showToast(message: 'Email is required.');
                            } else {
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                  email: widget.email)
                                  .then(
                                    (value) {
                                  showToast(message: 'Reset Password link sent');
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                      const SignIn(),
                                      transitionsBuilder:
                                          (_, animation, __, child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset
                                                .zero,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ).catchError((error) {
                                print('Error signing in: $error');
                              });
                            }
                          },
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: screenHeight * 0.040),
                            child: Container(
                              height: screenHeight * 0.040,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: buttonColor),
                              child: Center(
                                  child: Text(
                                    "Reset Password",
                                    style: TextStyle(color: white, fontSize: screenHeight * 0.012),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.015,
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
