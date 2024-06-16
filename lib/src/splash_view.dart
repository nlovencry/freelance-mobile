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
            isLoggedIn ? '/login' : '/login',
            arguments: roles));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 60,
            ),
            SizedBox(
              height: 180,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    height: 70,
                    child: Image.asset('assets/images/img_splashscreen.png')),
                Constant.xSizedBox24,
              ],
            )
          ],
        ),
      ),
    );
  }
}
