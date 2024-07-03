import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/helper/constant.dart';
import 'auth/view/login_view.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    init();
    super.didChangeDependencies();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn =
        prefs.getString(Constant.kSetPrefToken)?.isNotEmpty ?? false;
    final roles = prefs.getString(Constant.kSetPrefRoles);

    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed(
            isLoggedIn ? '/home' : '/login',
            arguments: roles));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/images/img_splashscreen.png',
                width: 200,
                height: 200,
              ),
            ),
            // SizedBox(height: 180),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text("App Name: ${AppConfig.shared.appName}"),
            //     Text("Base URL: ${AppConfig.shared.baseUrl}"),
            //     Text("Flavor: ${AppConfig.shared.flavor}"),
            //     Container(
            //         color: const Color.fromARGB(255, 156, 154, 157),
            //         width: 70,
            //         height: 70),
            //     Constant.xSizedBox24,
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
