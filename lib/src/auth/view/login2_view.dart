import 'package:mata/common/component/custom_button.dart';
import 'package:mata/common/component/custom_container.dart';
import 'package:mata/common/component/custom_textField.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/auth/provider/auth_provider.dart';
import 'package:mata/src/home/view/home1_view.dart';
import 'package:mata/src/home/view/main_home.dart';
import 'package:mata/src/splash_view.dart';
import 'package:mata/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login2View extends StatefulWidget {
  const Login2View({super.key});

  @override
  State<Login2View> createState() => _Login2ViewState();
}

class _Login2ViewState extends State<Login2View> {
  @override
  Widget build(BuildContext context) {
    final authP = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 50,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Selamat Datang",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
                "Selamat datang, sebelum login pastikan kamu memasukan akun dengan benar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                )),
            SizedBox(
              height: 20,
            ),
            CustomTextField.borderTextField(
              controller: authP.usernameC,
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
              controller: authP.passC,
              fillColor: Colors.white,
              hintColor: Constant.quarteryColor,
              hintText: "Password",
              labelFontSize: 20,
              labelFontWeight: FontWeight.bold,
              labelColor: Constant.primaryColor,
              borderColor: Constant.primaryColor,
              obscureText: authP.obscurePass,
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
                  final result = await context.read<AuthProvider>().login();
                  if (result.Success == true) {
                    await context.read<AuthProvider>().updateFirebaseToken();
                    Navigator.pushReplacementNamed(context, '/home',
                        arguments: "");
                  } else {
                    Utils.showFailed(msg: result.Message ?? "Error");
                  }
                } catch (e) {
                  Utils.showFailed(
                      msg: e.toString().toLowerCase().contains("doctype")
                          ? "Maaf, Terjadi Galat!"
                          : "$e");
                }
              },
              suffixIcon: InkWell(
                onTap: () => authP.toggleObscurePass(),
                child: Icon(
                  authP.obscurePass ? Icons.visibility_off : Icons.visibility,
                  color: Constant.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 30),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SplashView()));
                },
                child: Text("Belum Punya akun?")),
            Text(
              "Daftar disini",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 60),
            CustomButton.mainButton("Masuk", () async {
              try {
                final result = await context.read<AuthProvider>().login();
                if (result.Success == true) {
                  await context.read<AuthProvider>().updateFirebaseToken();
                  Navigator.pushReplacementNamed(context, '/home',
                      arguments: "");
                } else {
                  Utils.showFailed(msg: result.Message ?? "Error");
                }
              } catch (e) {
                Utils.showFailed(
                    msg: e.toString().toLowerCase().contains("doctype")
                        ? "Maaf, Terjadi Galat!"
                        : "$e");
              }
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => MainHome()));
            }, borderRadius: BorderRadius.circular(10))
          ],
        ),
      ),
    );
  }
}
