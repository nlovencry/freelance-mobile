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
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/img-splash.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.only(top: 80),
                child: Center(
                    child: Image.asset('assets/icons/ic-bimops-rectangle2.png',
                        width: 200))),
            Column(
              children: [
                Text("Powered by", style: Constant.whiteRegular12),
                Constant.xSizedBox16,
                SizedBox(
                    width: 130,
                    child: Image.asset('assets/icons/ic-pelindo.png')),
                Constant.xSizedBox32,
                Constant.xSizedBox8,
              ],
            )
          ],
        ),
      ),
    );
  }
}
