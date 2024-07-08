import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/common/component/custom_container.dart';
import 'package:hy_tutorial/common/component/custom_dropdown.dart';
import 'package:hy_tutorial/common/component/custom_textField.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/auth/provider/auth_provider.dart';
import 'package:hy_tutorial/src/auth/view/login2_view.dart';
import 'package:hy_tutorial/src/home/view/home1_view.dart';
import 'package:hy_tutorial/src/home/view/main_home.dart';
import 'package:hy_tutorial/src/splash_view.dart';
import 'package:hy_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register2View extends StatefulWidget {
  const Register2View({super.key});

  @override
  State<Register2View> createState() => _Register2ViewState();
}

class _Register2ViewState extends State<Register2View> {
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
              Image.asset("assets/icons/ic-register.png"),
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
                "Register",
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
                  "Silakan daftar dan masukan data diri anda, lalu tunggu sampai disetujui oleh admin",
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
                  Text("Nama",
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
                    controller: authP.nameC,
                    fillColor: Colors.white,
                    hintColor: Constant.quarteryColor,
                    hintText: "Nama",
                    labelFontSize: 20,
                    labelFontWeight: FontWeight.bold,
                    labelColor: Constant.primaryColor,
                    borderColor: Constant.primaryColor.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("NIP",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropdown.normalDropdown(
                    // readOnly: !woAgreementP.isCreate,
                    required: true,
                    // enabled: woAgreementP.isCreate,
                    controller: authP.selectedDevisionC,
                    // labelText: "Work Type",
                    selectedItem: authP.selectedDevisionV,
                    hintText: authP.selectedDivision?.Name ?? "Select",
                    list: [
                      DropdownMenuItem(value: "EG", child: Text("Enginer")),
                      DropdownMenuItem(
                          value: "PM", child: Text("Predictive Maintenance")),
                      DropdownMenuItem(value: "BD", child: Text("Breakdown")),
                      DropdownMenuItem(value: "AC", child: Text("Accident")),
                    ],
                    onChanged: (val) {
                      // if (val == "BD" || val == "SD") {
                      //   woAgreementP.isDowntime = true;
                      // }
                      // woAgreementP.workTypeV = val;
                      // woAgreementP.workTypeShortC.text = val ?? "";
                      // if (val == "CM") {
                      //   woAgreementP.workTypeC.text = "Corrective Maintenance";
                      // }
                      // if (val == "PDM") {
                      //   woAgreementP.workTypeC.text = "Predictive Maintenance";
                      // }
                      // if (val == "BD") {
                      //   woAgreementP.workTypeC.text = "Breakdown";
                      // }
                      // if (val == "AC") {
                      //   woAgreementP.workTypeC.text = "Accident";
                      // }
                      // if (val == "SD") {
                      //   woAgreementP.workTypeC.text = "Shutdown";
                      // }
                      setState(() {});
                      // woAgreementP.workTypeV = val;
                    },
                  ),
                  // CustomTextField.borderTextField(
                  //   borderRadius: BorderRadius.circular(5),
                  //   controller: authP.emailC,
                  //   fillColor: Colors.white,
                  //   hintColor: Constant.quarteryColor,
                  //   hintText: "NIP",
                  //   labelFontSize: 20,
                  //   labelFontWeight: FontWeight.bold,
                  //   labelColor: Constant.primaryColor,
                  //   borderColor: Constant.primaryColor.withOpacity(0.5),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Username",
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
                    hintText: "Username",
                    labelFontSize: 20,
                    labelFontWeight: FontWeight.bold,
                    labelColor: Constant.primaryColor,
                    borderColor: Constant.primaryColor.withOpacity(0.5),
                    // obscureText: authP.obscurePass,
                    // onEditingComplete: () async {
                    //   try {
                    //     final result = await context.read<AuthProvider>().login();
                    //     if (result.Success == true) {
                    //       Navigator.pushReplacementNamed(context, '/home',
                    //           arguments: "");
                    //     } else {
                    //       Utils.showFailed(msg: result.Message ?? "Error");
                    //     }
                    //   } catch (e) {
                    //     Utils.showFailed(
                    //         msg: e.toString().toLowerCase().contains("doctype")
                    //             ? "Maaf, Terjadi Galat!"
                    //             : "$e");
                    //   }
                    // },
                    // suffixIcon: InkWell(
                    //   onTap: () => authP.toggleObscurePass(),
                    //   child: Icon(
                    //     authP.obscurePass ? Icons.visibility_off_outlined : Icons.visibility,
                    //     color: Constant.primaryColor,
                    //   ),
                    // ),
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
              CustomButton.mainButton("Daftar", () async {
                // try {
                //   final result = await context.read<AuthProvider>().register();
                //   if (result.Success == true) {
                //     Navigator.pushReplacementNamed(context, '/home',
                //         arguments: "");
                //   } else {
                //     Utils.showFailed(msg: result.Message ?? "Error");
                //   }
                // } catch (e) {
                //   Utils.showFailed(
                //       msg: e.toString().toLowerCase().contains("doctype")
                //           ? "Maaf, Terjadi Galat!"
                //           : "$e");
                // }
              },
                  borderRadius: BorderRadius.circular(10),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sudah memiliki akun?"),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login2View()));
                    },
                    child: Text(
                      "Masuk",
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
