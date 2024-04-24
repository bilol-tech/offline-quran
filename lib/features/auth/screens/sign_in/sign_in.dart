import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../../constant/color.dart';
import '../../../../global/common/toasts.dart';
import '../../../core/screens/main_screen.dart';
import '../../firebase/flutter_auth_services.dart';
import '../forgot_password/forgot_password.dart';
import '../sign_up/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController loginController = TextEditingController();
  bool _isObscure = true;

  late TextEditingController _passwordController;
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    loginController.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Color buttonColor = gray;

  void _updateButtonColor() {
    setState(() {
      if (loginController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        buttonColor = primary;
      } else {
        buttonColor = gray;
      }
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Sign in',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: white.withOpacity(0.8)),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: white),
                ),
                Text(
                  'To continue sign in to system',
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
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: TextStyle(color: white, fontSize: 13),
                            keyboardType: TextInputType.text,
                            controller: loginController,
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
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: TextStyle(color: white, fontSize: 13),
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: text),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 10, left: 8),
                              label: const Text("Password"),
                              labelStyle: TextStyle(fontSize: 13, color: text),
                              suffixIcon: GestureDetector(
                                onTap: _toggleObscure,
                                child: Icon(
                                  _isObscure
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
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            InkWell(
                              onTap: (){
                                if(loginController.text.isNotEmpty){
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => ForgotPassword(email: loginController.text,),
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
                                } else {
                                  showToast(message: "Email/Password is required");
                                }
                              },
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(color: white, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () {
                            if (loginController.text.isEmpty) {
                              showToast(message: 'Email is required.');
                            } else if (_passwordController.text.isEmpty) {
                              showToast(message: 'Password is required.');
                            } else {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                  email: loginController.text,
                                  password: _passwordController.text)
                                  .then(
                                    (value) {
                                  showToast(message: 'Successfully Signed in');
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                      const MainScreen(selectedIndex: 0),
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
                                if (error.code == 'wrong-password') {
                                  showToast(
                                      message: 'Incorrect password');
                                } else if (error.code == 'user-not-found') {
                                  showToast(message: "Don't have an account");
                                } else {
                                  showToast(
                                      message: 'Account not found');
                                }
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
                                "Sign in",
                                style: TextStyle(color: white, fontSize: 12),
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const SignUp(),
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
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                "Sign up",
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
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: white)),
                      child: Image.asset(
                        "assets/images/apple.png",
                        width: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    GestureDetector(
                      onTap: (){
                        _signInWithGoogle();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: white)),
                        child: Image.asset(
                          "assets/images/google.png",
                          width: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: white)),
                      child: Image.asset(
                        "assets/images/facebook.png",
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        print("User signed in successfully");
        // Check if context is available before navigation
        if (context != null) {
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
          print("Context is null. Navigation failed.");
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      showToast(message: "Some error occurred: $e");
    }
  }

}
