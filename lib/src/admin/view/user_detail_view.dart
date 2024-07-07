import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../common/component/custom_appbar.dart';
import '../../../common/component/custom_button.dart';
import '../../../common/component/custom_container.dart';
import '../../../common/helper/constant.dart';
import 'package:provider/provider.dart';
import '../../../utils/utils.dart';
import '../provider/user_manage_provider.dart';

class UserDetailView extends StatefulWidget {
  UserDetailView({super.key, required this.id});
  final String id;
  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    context.read<UserManageProvider>().fetchUserDetail(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserManageProvider>().userDetailModel.Data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Detail User"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text("Detail User", style: Constant.blackBold20),
                  Constant.xSizedBox8,
                  Text("Detail data terakhir dari user",
                      style: Constant.grayMedium),
                  Constant.xSizedBox16,
                  Container(
                    color: Color(0xffEFEFEF),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Nama',
                            style: TextStyle(color: Constant.textColorBlack),
                          ),
                        ),
                        Constant.xSizedBox8,
                        Expanded(
                          flex: 5,
                          child: Text(
                            '${user?.Name ?? "Jhon Doe"}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Divisi / Jabatan',
                            style: TextStyle(color: Constant.textColorBlack),
                          ),
                        ),
                        Constant.xSizedBox8,
                        Expanded(
                          flex: 5,
                          child: Text(
                            '${user?.Division ?? "Engineer"}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xffEFEFEF),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Nama',
                            style: TextStyle(color: Constant.textColorBlack),
                          ),
                        ),
                        Constant.xSizedBox8,
                        Expanded(
                          flex: 5,
                          child: Text(
                            '${user?.Role ?? "User"}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Username',
                            style: TextStyle(color: Constant.textColorBlack),
                          ),
                        ),
                        Constant.xSizedBox8,
                        Expanded(
                          flex: 5,
                          child: Text(
                            '${user?.Username ?? "Jhon Doe"}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xffEFEFEF),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Password',
                            style: TextStyle(color: Constant.textColorBlack),
                          ),
                        ),
                        Constant.xSizedBox8,
                        Expanded(
                          flex: 5,
                          child: Text(
                            '${user?.Status ?? "Jhon 123"}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: CustomButton.mainButton(
                'Submit',
                () {
                  final dataP = context.read<UserManageProvider>();
                  FocusManager.instance.primaryFocus?.unfocus();
                  String? msg;
                  //if (dataP.nameC.text.isEmpty) msg = 'Harap Isi Nama Lengkap';
                  //if (dataP.nipC.text.isEmpty) msg = 'Harap Isi NIP';
                  //if (dataP.roleC.text.isEmpty) msg = 'Harap Pilih Role';
                  //if (dataP.usernameC.text.isEmpty) msg = 'Harap Isi Username';
                  //if (dataP.passwordC.text.isEmpty) msg = 'Harap Isi Password';
                  if (msg != null) {
                    Utils.showFailed(msg: msg);
                    return;
                  } else {
                    // Navigator
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
