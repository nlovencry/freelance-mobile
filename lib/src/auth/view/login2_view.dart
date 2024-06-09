import 'package:mata/common/component/custom_button.dart';
import 'package:mata/common/component/custom_container.dart';
import 'package:mata/common/component/custom_textField.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/auth/provider/auth_provider.dart';
import 'package:mata/src/home/view/home1_view.dart';
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: Column(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email", style: Constant.grayRegular13.copyWith(fontSize: 14)),
                  SizedBox(
                    height: 5,
                  ),
                  CustomTextField.borderTextField(
                    controller: authP.usernameC,
                    fillColor: Colors.white,
                    hintColor: Constant.quarteryColor,
                    hintText: "Email",
                    labelFontSize: 20,
                    labelFontWeight: FontWeight.bold,
                    labelColor: Constant.primaryColor,
                    borderColor: Constant.primaryColor,
                  ),
                  SizedBox(height: 20),
                  Text("Password", style: Constant.grayRegular13.copyWith(fontSize: 14)),
                  SizedBox(
                    height: 5,
                  ),
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
                        if (result.success == true) {
                          await context.read<AuthProvider>().updateFirebaseToken();
                          Navigator.pushReplacementNamed(context, '/home',
                              arguments: "");
                        } else {
                          Utils.showFailed(msg: result.message ?? "Error");
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
                  SizedBox(height: 20),
                ],
              ),

              CustomButton.mainButton(contentPadding: EdgeInsets.all(7),"Masuk", () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Home1View()));
              },
                  borderRadius: BorderRadius.circular(10)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SplashView()));
                      },
                      child: Text("Belum Punya akun?")),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () async {},
                    child: Text(
                      "Daftar",
                      style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
