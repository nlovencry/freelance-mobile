import 'package:bimops/common/base/base_state.dart';
import 'package:bimops/common/component/custom_button.dart';
import 'package:bimops/common/component/custom_textfield.dart';
// import 'package:bimops/src/auth/view/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/component/custom_alert.dart';
import '../../../common/helper/constant.dart';
import '../../../common/helper/widgets.dart';
import '../../../utils/utils.dart';
import '../provider/auth_provider.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseState<LoginView> {
  @override
  void initState() {
    context.read<AuthProvider>().loginKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    Widget form() {
      return Padding(
        padding: EdgeInsets.only(top: 13),
        child: Form(
          key: auth.loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                child: Center(
                    child: Image.asset('assets/icons/ic-bimops-rectangle2.png',
                        width: 200)),
              ),
              SizedBox(height: 120),
              Container(
                // height: 500,
                padding: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 30,
                            color: Constant.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Login to your account",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    CustomTextField.borderTextField(
                      controller: auth.usernameC,
                      fillColor: Colors.white,
                      hintColor: Constant.quarteryColor,
                      hintText: "Username",
                      labelFontSize: 20,
                      labelFontWeight: FontWeight.bold,
                      labelColor: Constant.primaryColor,
                      borderColor: Constant.primaryColor,
                    ),
                    SizedBox(height: 20),
                    CustomTextField.borderTextField(
                      controller: auth.passC,
                      fillColor: Colors.white,
                      hintColor: Constant.quarteryColor,
                      hintText: "Password",
                      labelFontSize: 20,
                      labelFontWeight: FontWeight.bold,
                      labelColor: Constant.primaryColor,
                      borderColor: Constant.primaryColor,
                      obscureText: auth.obscurePass,
                      onEditingComplete: () async {
                        // FocusScope.of(context).requestFocus(new FocusNode());
                        // // Validate returns true if the form is valid, or false otherwise.
                        // if (auth.loginKey.currentState!.validate()) {
                        //   // If the form is valid, display a snackbar. In the real world,
                        //   // you'd often call a server or save the information in a database.
                        //   WrapLoading(auth.login()).then((value) {
                        //     // Navigator.pushReplacementNamed(context, '/home');
                        //     Navigator.restorablePushReplacementNamed(
                        //         context, '/home');
                        //   }).onError((error, stackTrace) {
                        //     CustomAlert.showSnackBar(
                        //       context,
                        //       error.toString().toLowerCase().contains("doctype")
                        //           ? "Maaf, Terjadi Galat!"
                        //           : error.toString(),
                        //       true,
                        //     );
                        //   });
                        // }
                        try {
                          final result =
                              await context.read<AuthProvider>().login();
                          if (result.success == true) {
                            await context
                                .read<AuthProvider>()
                                .updateFirebaseToken();
                            Navigator.pushReplacementNamed(context, '/home',
                                arguments: "");
                          } else {
                            Utils.showFailed(msg: result.message ?? "Error");
                          }
                        } catch (e) {
                          Utils.showFailed(
                              msg:
                                  e.toString().toLowerCase().contains("doctype")
                                      ? "Maaf, Terjadi Galat!"
                                      : "$e");
                        }
                      },
                      suffixIcon: InkWell(
                        onTap: () => auth.toggleObscurePass(),
                        child: Icon(
                          auth.obscurePass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Constant.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    CustomButton.mainButton(
                      "Login",
                      () async {
                        // FocusScope.of(context).requestFocus(new FocusNode());
                        // // Validate returns true if the form is valid, or false otherwise.
                        // if (auth.loginKey.currentState!.validate()) {
                        //   // If the form is valid, display a snackbar. In the real world,
                        //   // you'd often call a server or save the information in a database.
                        //   WrapLoading(auth.login()).then((value) {
                        //     // Navigator.pushReplacementNamed(context, '/home');
                        //     Navigator.restorablePushReplacementNamed(
                        //         context, '/home');
                        //   }).onError((error, stackTrace) {
                        //     CustomAlert.showSnackBar(
                        //       context,
                        //       error.toString().toLowerCase().contains("doctype")
                        //           ? "Maaf, Terjadi Galat!"
                        //           : error.toString(),
                        //       true,
                        //     );
                        //   });
                        // }
                        try {
                          final result =
                              await context.read<AuthProvider>().login();
                          if (result.success == true) {
                            Navigator.pushReplacementNamed(context, '/home',
                                arguments: "");
                          } else {
                            Utils.showFailed(msg: result.message ?? "Error");
                          }
                        } catch (e) {
                          Utils.showFailed(
                              msg:
                                  e.toString().toLowerCase().contains("doctype")
                                      ? "Maaf, Terjadi Galat!"
                                      : "$e");
                        }
                      },
                      textStyle: Constant.whiteExtraBold18,
                      contentPadding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    SizedBox(height: 42),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/img-splash.jpg'), // Ganti dengan URL gambar Anda
              fit: BoxFit.cover, // Menyesuaikan ukuran gambar dengan Container
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [form()],
          ),
        ),
      ),
    );
  }
}
