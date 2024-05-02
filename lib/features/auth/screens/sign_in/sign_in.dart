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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      appBar: AppBar(
        backgroundColor: light ? white : gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: screenHeight * 0.010),
          child: Text(
            'Sign in',
            style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.bold,
                color: light ? Colors.black87 : white.withOpacity(0.8)),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.020, vertical: screenHeight * 0.015),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                      fontSize: screenHeight * 0.022, fontWeight: FontWeight.bold, color: light ? black : white),
                ),
                Text(
                  'To continue sign in to system',
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
                        SizedBox(
                          height: screenHeight * 0.042,
                          child: TextFormField(
                            style: TextStyle(color: light ? black : white, fontSize: screenHeight * 0.013),
                            keyboardType: TextInputType.text,
                            controller: loginController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: light ? Colors.black87 : text),
                              ),
                              contentPadding:  EdgeInsets.only(top: screenHeight * 0.010, left: screenHeight * 0.008),
                              label: const Text("Login"),
                              labelStyle: TextStyle(fontSize: screenHeight * 0.013, color: light ? Colors.black87 : text),
                            ),
                            cursorHeight: screenHeight * 0.015,
                            cursorColor: light ? black : white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.012,
                        ),
                        SizedBox(
                          height: screenHeight * 0.042,
                          child: TextFormField(
                            style: TextStyle(color: light ? black : white, fontSize: screenHeight * 0.013),
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: light ? Colors.black87 : text),
                              ),
                              contentPadding: EdgeInsets.only(top: screenHeight * 0.010, left: screenHeight * 0.008),
                              label: const Text("Password"),
                              labelStyle: TextStyle(fontSize: screenHeight * 0.013, color: light ? Colors.black87 : text),
                              suffixIcon: GestureDetector(
                                onTap: _toggleObscure,
                                child: Icon(
                                  _isObscure
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
                          height: screenHeight * 0.008,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            InkWell(
                              onTap: (){
                                if(loginController.text.isNotEmpty){
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(email: loginController.text,),
                                    ), (route) => true,
                                  );
                                } else {
                                  showToast(message: "Email/Password is required");
                                }
                              },
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(color: light ? black : white, fontSize: screenHeight * 0.010),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.025,
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
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const MainScreen(selectedIndex: 0,),
                                    ), (route) => true,
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
                            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.040),
                            child: Container(
                              height: screenHeight * 0.040,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: buttonColor),
                              child: Center(
                                  child: Text(
                                "Sign in",
                                style: TextStyle(color: white, fontSize: screenHeight * 0.012),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.015,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ), (route) => true,
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: light ? black : white,
                                  fontSize: screenHeight * 0.012,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                "Sign up",
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
                SizedBox(
                  height: screenHeight * 0.024,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: light ? black : white)),
                      child: Image.asset(
                        "assets/images/apple.png",
                        width: screenHeight * 0.020,
                      ),
                    ),
                    SizedBox(
                      width: screenHeight * 0.017,
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
                            border: Border.all(color: light ? black : white)),
                        child: Image.asset(
                          "assets/images/google.png",
                          width: screenHeight * 0.020,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenHeight * 0.017,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: light ? black : white)),
                      child: Image.asset(
                        "assets/images/facebook.png",
                        width: screenHeight * 0.020,
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
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainScreen(selectedIndex: 0,),
            ), (route) => true,
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
