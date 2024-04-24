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
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        }, child: Icon(Icons.arrow_back, size: 20, color: text,)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forget Password?',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: white),
                ),
                Text(
                  'Enter your email address',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: white.withOpacity(0.7)),
                ),
                const SizedBox(
                  height: 10,
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
                        const SizedBox(height: 20,),
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: TextStyle(color: white, fontSize: 13),
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
                              const EdgeInsets.only(top: 10, left: 8),
                              label: const Text("Login"),
                              labelStyle: TextStyle(fontSize: 13, color: text),
                            ),
                            cursorHeight: 15,
                            cursorColor: white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        const SizedBox(height: 30,),
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
                            const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: buttonColor),
                              child: Center(
                                  child: Text(
                                    "Reset Password",
                                    style: TextStyle(color: white, fontSize: 12),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
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
