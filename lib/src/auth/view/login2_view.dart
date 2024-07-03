import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/common/component/custom_container.dart';
import 'package:hy_tutorial/common/component/custom_textField.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/auth/provider/auth_provider.dart';
import 'package:hy_tutorial/src/auth/view/register2_view.dart';
import 'package:hy_tutorial/src/home/view/home1_view.dart';
import 'package:hy_tutorial/src/home/view/main_home.dart';
import 'package:hy_tutorial/src/splash_view.dart';
import 'package:hy_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          padding: EdgeInsets.fromLTRB(20, 120, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 25,
                width: 150,
                decoration: BoxDecoration(
                  color: Constant.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 25,
                width: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFFABA01),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.grey.shade300,
              //   radius: 50,
              // ),
              SizedBox(
                height: 15,
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
                height: 15,
              ),
              Text(
                  "Selamat datang, sebelum login pastikan kamu memasukan akun dengan benar.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w300)),
              SizedBox(
                height: 20,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField.borderTextField(
                    borderRadius: BorderRadius.circular(5),
                    controller: authP.usernameC,
                    fillColor: Colors.white,
                    hintColor: Constant.quarteryColor,
                    hintText: "Email",
                    labelFontSize: 20,
                    labelFontWeight: FontWeight.bold,
                    labelColor: Constant.primaryColor,
                    borderColor: Constant.primaryColor.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Password",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField.borderTextField(
                    borderRadius: BorderRadius.circular(5),
                    controller: authP.passC,
                    fillColor: Colors.white,
                    hintColor: Constant.quarteryColor,
                    hintText: "Password",
                    labelFontSize: 20,
                    labelFontWeight: FontWeight.bold,
                    labelColor: Constant.primaryColor,
                    borderColor: Constant.primaryColor.withOpacity(0.5),
                    obscureText: authP.obscurePass,
                    onEditingComplete: () async {
                      try {
                        final result =
                            await context.read<AuthProvider>().login();
                        if (result.Success == true) {
                          Navigator.pushReplacementNamed(context, '/home',
                              arguments: "");
                        } else {
                          Utils.showFailed(msg: result.Message ?? "Error");
                        }
                      } catch (e) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        Utils.showFailed(
                            msg: e.toString().toLowerCase().contains("doctype")
                                ? "Maaf, Terjadi Galat!"
                                : "$e");
                      }
                    },
                    suffixIcon: InkWell(
                      onTap: () => authP.toggleObscurePass(),
                      child: Icon(
                        authP.obscurePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility,
                        color: Constant.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),
              CustomButton.mainButton("Masuk", () async {
                try {
                  final result = await context.read<AuthProvider>().login();
                  if (result.Success == true) {
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
                  borderRadius: BorderRadius.circular(10),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum Punya akun?"),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Register2View()));
                    },
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
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
