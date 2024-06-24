import 'dart:io';

import 'package:mata/src/data/view/data_add_view.dart';
import 'package:mata/src/home/model/home_model.dart';
import 'package:mata/src/home/view/home1_view.dart';
import 'package:mata/src/home/view/home_view.dart';
import 'package:mata/src/profil/view/profile_view.dart';
import 'package:mata/src/report/view/report_view.dart';

import 'package:mata/src/transaction/view/transaction_view.dart';
import 'package:mata/src/work_order/view/work_order_view.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/helper/constant.dart';
import '../../../utils/utils.dart';
import '../../turbine/view/riwayat_view.dart';

class MainHome extends StatefulWidget {
  final int? index;

  const MainHome({super.key, this.index});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int currentIndex = 0;
  late HomeModel homeModel;
  String? roles;

  @override
  void initState() {
    getData();
    // setIndex();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    roles = ModalRoute.of(context)?.settings.arguments as String?;
    // getData();
    super.didChangeDependencies();
  }

  getData() async {
    setIndex();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // roles = prefs.getString(Constant.kSetPrefRoles);
    // await Utils.showLoading();
    // await context.read<HomeProvider>().fetchHome();
    // await context.read<ProfileProvider>().fetchProfile(context: context);
    // await context.read<JamaahProvider>().fetchJamaah();
    // if (roles == "agen") await context.read<SubAgenProvider>().fetchSubAgen();
    // await context.read<ProfileProvider>().fetchSosmed();
    // await context.read<NotifikasiProvider>().fetchNotif();
    // await Utils.dismissLoading();
    setState(() {});
  }

  setIndex() {
    setState(() {
      if (widget.index != null) {
        currentIndex = widget.index ?? 0;
      }
    });
  }

  void jumpToJamaah() {
    setState(() {
      currentIndex = 1;
    });
  }

  void jumpToRiwayat() {
    setState(() {
      currentIndex = 2;
    });
  }

  void jumpToProfile() {
    setState(() {
      currentIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget customBottomNav() {
      return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        // padding: EdgeInsets.only(top: 5),
        child: BottomNavigationBar(
          // backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          backgroundColor: Colors.white,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          unselectedItemColor: Constant.textHintColor2,
          currentIndex: currentIndex,
          onTap: (index) {
            // context.read<PaketProvider>().clearFilter();
            setState(() => currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(color: Constant.primaryColor),
          selectedItemColor: Constant.primaryColor,
          selectedLabelStyle: Constant.primaryBold15.copyWith(fontSize: 13),
          unselectedLabelStyle:
              TextStyle(fontSize: 13, color: Constant.textHintColor2),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(bottom: 4),
                width: 25,
                height: 25,
                child: FittedBox(
                  child: Image.asset(
                    'assets/icons/ic-home.png',
                    color: currentIndex == 0
                        ? Constant.primaryColor
                        : Color(0xff8A8C8D),
                  ),
                ),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(bottom: 4),
                width: 25,
                height: 25,
                child: FittedBox(
                  child: Image.asset(
                    'assets/icons/ic-form.png',
                    color: currentIndex == 1
                        ? Constant.primaryColor
                        : Color(0xff8A8C8D),
                  ),
                ),
              ),
              label: 'Form',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(bottom: 4),
                width: 25,
                height: 25,
                child: FittedBox(
                  child: Image.asset(
                    'assets/icons/ic-riwayat.png',
                    color: currentIndex == 2
                        ? Constant.primaryColor
                        : Color(0xff8A8C8D),
                  ),
                ),
              ),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  padding: EdgeInsets.only(bottom: 4),
                  width: 25,
                  height: 25,
                  child: FittedBox(
                      child: Image.asset(
                    'assets/icons/ic-profile.png',
                    color: currentIndex == 3
                        ? Constant.primaryColor
                        : Color(0xff8A8C8D),
                  ))),
              label: 'Profile',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      //extendBody: true,
      primary: true,
      bottomNavigationBar: customBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Constant.primaryColor,
          child:
              Image.asset('assets/icons/ic-button.png', width: 40, height: 40),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: WillPopScope(
        onWillPop: () async {
          if (currentIndex != 0) {
            setState(() => currentIndex = 0);
            return false;
          }
          // kalau sudah ada api maka muncul konfirm exit dua kali
          return true;
        },
        child: [
          Home1View(),
          DataAddView(),
          RiwayatView(),
          ProfileView(),
          // ProfileView(jumpToJamaah, jumpToSubAgen)
        ][currentIndex],
      ),
    );
  }
}
