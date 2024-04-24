import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../constant/color.dart';
import '../../../../global/common/toasts.dart';
import '../../../core/screens/main_screen.dart';

class UpdateLogin extends StatefulWidget {
  const UpdateLogin({Key? key}) : super(key: key);

  @override
  State<UpdateLogin> createState() => _UpdateLoginState();
}

class _UpdateLoginState extends State<UpdateLogin> {
  final TextEditingController updateLoginController = TextEditingController();
  final TextEditingController updatePasswordController = TextEditingController();
  bool _isObscure = true;
  Color buttonColor = gray;

  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async{
    if (user != null && !user!.emailVerified){
      await user!.sendEmailVerification();
      print("Verification Email has been sent");
      showToast(message: "Verification Email has been sent");
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      updateLoginController.text = user.email ?? '';
    }
  }

  @override
  void dispose() {
    updateLoginController.dispose();
    updatePasswordController.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _updateButtonColor() {
    setState(() {
      if (updateLoginController.text.isNotEmpty &&
          updatePasswordController.text.isNotEmpty) {
        buttonColor = primary;
      } else {
        buttonColor = gray;
      }
    });
  }


  Future<void> _updateLoginAndPassword() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await currentUser.updateEmail(updateLoginController.text);
        await currentUser.updatePassword(updatePasswordController.text);
        showToast(message: "Login updated successfully");
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen(selectedIndex: 0,)),
        );
      } catch (error) {
        print(error);
        showToast(message: "Failed to update login");
      }
    }
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
                const Text(
                  'Change Login',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: modalSheetColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            keyboardType: TextInputType.emailAddress,
                            controller: updateLoginController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              contentPadding:
                              EdgeInsets.only(top: 10, left: 8),
                              labelText: "Login",
                              labelStyle: TextStyle(fontSize: 13, color: Colors.white),
                            ),
                            cursorHeight: 15,
                            cursorColor: Colors.white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            keyboardType: TextInputType.text,
                            controller: updatePasswordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              contentPadding:
                              const EdgeInsets.only(top: 10, left: 8),
                              labelText: "Password",
                              labelStyle: const TextStyle(fontSize: 13, color: Colors.white),
                              suffixIcon: GestureDetector(
                                onTap: _toggleObscure,
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            cursorHeight: 15,
                            cursorColor: Colors.white,
                            onChanged: (_) => _updateButtonColor(),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: _updateLoginAndPassword,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: buttonColor),
                              child: const Center(
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        user!.emailVerified ? InkWell(
                          onTap: (){
                            verifyEmail();
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: gray),
                              child: const Center(
                                  child: Text(
                                    "Verify Email",
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  )),
                            ),
                          ),
                        ) : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "back",
                              style: TextStyle(
                                color: primary,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
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
