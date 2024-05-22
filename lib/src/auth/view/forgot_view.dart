// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:chatour/common/component/custom_alert.dart';
// import 'package:chatour/common/component/custom_button.dart';
// import 'package:chatour/common/component/custom_textField.dart';
// import 'package:chatour/common/helper/constant.dart';
// import 'package:chatour/common/base/base_state.dart';
// import 'package:provider/provider.dart';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'dart:async';

// import '../provider/auth_provider.dart';

// class ForgotView extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return ForgotViewState();
//   }
// }

// class ForgotViewState extends BaseState<ForgotView> {
//   Widget mainLogo() {
//     return Align(
//       alignment: Alignment.center,
//       child: Image(
//         image: AssetImage(
//           'assets/icons/LOGO CHATOUR ot.png',
//         ),
//         width: 120,
//         height: 120,
//       ),
//     );
//   }

//   Widget remindPass() {
//     return Align(
//       alignment: Alignment.center,
//       child: InkWell(
//         onTap: () => Navigator.pop(context),
//         child: Text(
//           "Ingat akun anda? Masuk Disini",
//           style: TextStyle(
//             color: Constant.primaryColor,
//             fontSize: Constant.fontSizeRegular,
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: InkWell(
//         onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               reverse: true,
//               child: Container(
//                 margin: EdgeInsets.all(Constant.paddingSize + 24),
//                 child: Form(
//                   key: auth.forgotKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(height: 50),
//                       mainLogo(),
//                       SizedBox(height: 50),
//                       Text(
//                         "Masukkan email Anda untuk melakukan pengaturan ulang kata sandi",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: Constant.fontSizeBig, color: Colors.grey),
//                       ),
//                       SizedBox(height: Constant.paddingSize + 8),
//                       CustomTextField.normalTextField(
//                           padding: EdgeInsets.zero,
//                           controller: auth.emailForgotC,
//                           hintText: "Email"),
//                       SizedBox(height: Constant.paddingSize + 12),
//                       CustomButton.mainButton("Atur Ulang", () {
//                         if (auth.forgotKey.currentState!.validate()) {
//                           FocusManager.instance.primaryFocus?.unfocus();
//                           context
//                               .read<AuthProvider>()
//                               .postForgot()
//                               .then((value) {
//                             CustomAlert.showSnackBar(
//                                 context, value.message, false);
//                             Future.delayed(Duration(seconds: 2), () {
//                               Navigator.pushNamed(context, '/token',
//                                   arguments: auth.emailForgotC.text);
//                             });
//                           }).onError((error, stackTrace) {
//                             FirebaseCrashlytics.instance.log(
//                                 "Forgot Password Error : " + error.toString());
//                             CustomAlert.showSnackBar(
//                                 context,
//                                 error
//                                         .toString()
//                                         .toLowerCase()
//                                         .contains("doctype")
//                                     ? "Maaf, Terjadi Galat!"
//                                     : error.toString(),
//                                 true);
//                           });
//                         }
//                       }),
//                       SizedBox(height: Constant.paddingSize + 12),
//                       remindPass(),
//                       Flexible(
//                           child: SizedBox(
//                               height: MediaQuery.of(context).viewInsets.bottom))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
