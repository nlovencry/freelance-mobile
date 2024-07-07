import 'package:flutter/material.dart';
import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/admin/view/user_add_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/utils.dart';
import '../../auth/provider/auth_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends BaseState<ProfileView> {
  String? name;
  String? division;

  @override
  void initState() {
    getData();
    super.initState;
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString(Constant.kSetPrefName);
    division = prefs.getString(Constant.kSetPrefRoles);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(context, "Profile",
          leading: SizedBox(),
          titleSpacing: 24,
          isLeading: false,
          textStyle: TextStyle(color: Colors.white),
          color: Constant.primaryColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              height: 110,
              color: Constant.primaryColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/icons/ic-user.png',
                    scale: 4,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name ?? "Andre Taulany",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          division ?? "Turbine Engineer",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/icons/ic-edit-prof.png',
                    scale: 4,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // height: 50,
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Akun",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'assets/icons/ic-edit.png',
                        scale: 3,
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ubah informasi akun",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Ganti nama, password, dan lainnya",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.withOpacity(0.5),
                              )),
                          child: Image.asset(
                            'assets/icons/ic-edit.png',
                            scale: 4,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // height: 50,
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'assets/icons/ic-shield.png',
                        scale: 3.5,
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kebijakan Privasi",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Pelajari kebijakan privasi pengguna aplikasi",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // height: 50,
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'assets/icons/ic-info.png',
                        scale: 3.5,
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        flex: 6,
                        child: InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => UserAddView())));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tentang Aplikasi",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Versi 1.0",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                await Utils.showYesNoDialog(
                  context: context,
                  title: "Konfirmasi",
                  desc: "Apakah Anda Yakin Ingin Keluar?",
                  yesCallback: () => handleTap(() async {
                    Navigator.pop(context);
                    try {
                      // final result =
                      await context.read<AuthProvider>().logout();
                      // if (result.success == true) {
                      Navigator.pushReplacementNamed(context, '/login');
                      // } else {
                      //   Utils.showFailed(msg: result.message);
                      // }
                    } catch (e) {
                      Utils.showFailed(
                          msg: e.toString().toLowerCase().contains("doctype")
                              ? "Maaf, Terjadi Galat!"
                              : "$e");
                    }
                  }),
                  noCallback: () => Navigator.pop(context),
                );
                // CusNav.nPush(context, UserManageView());
              },
              child: Container(
                // height: 50,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          'assets/icons/ic-logout.png',
                          scale: 3.5,
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Keluar",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Keluar akun dengan aman",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
