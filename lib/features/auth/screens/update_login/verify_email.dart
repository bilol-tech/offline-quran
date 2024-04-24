// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:quran_bilol_tech/src/global/common/toasts.dart';
//
// class EmailVerificationScreen extends StatefulWidget {
//   const EmailVerificationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
// }
//
// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Email Verification'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Verification email sent to:',
//                 style: TextStyle(fontSize: 18.0),
//               ),
//               SizedBox(height: 10.0),
//               Text(
//                 widget.emailAddress,
//                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20.0),
//               Text(
//                 'Please check your email and follow the instructions to verify your new email address.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16.0),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
