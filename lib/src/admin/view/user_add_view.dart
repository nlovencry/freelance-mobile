import 'package:flutter/material.dart';
import 'package:hy_tutorial/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../../common/helper/constant.dart';
import '../provider/user_manage_provider.dart';
import '../../../common/component/custom_appbar.dart';
import '../../../common/component/custom_button.dart';
import 'user_detail_view.dart';

class UserAddView extends StatefulWidget {
  const UserAddView({super.key});

  @override
  State<UserAddView> createState() => _UserAddViewState();
}

class _UserAddViewState extends State<UserAddView> {
  @override
  void initState() {
    //final p = context.read<UserAddProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserManageProvider>();

    Widget modalHapus() {
      return CustomButton.secondaryButton('Hapus', () async {
        Utils.showYesNoDialogWithWarning(
            context: context,
            title: "Konfirmasi Penghapusan",
            desc: "Apakah anda yakin ingin\nmenghapus user yang dipilih?",
            yesCallback: () async {
              Navigator.pop(context);
            },
            noCallback: () async {
              Navigator.pop(context);
            });
      });
    }

    Widget modalSimpan() {
      return CustomButton.secondaryButton(
        'Simpan',
        () async {
          Utils.showYesNoDialog(
            context: context,
            title: "Simpan Perubahan",
            desc: "Apakah anda yakin\ningin menyimpan perubahan?",
            yesCallback: () async {
              Navigator.pop(context);
            },
            noCallback: () async {
              Navigator.pop(context);
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Tambah User"),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(children: [
            Expanded(
              child: ListView(
                children: [
                  ...p.userForm(),
                  modalHapus(),
                  Constant.xSizedBox16,
                  modalSimpan(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => UserDetailView(id: "01J1WQEDH0SZYZWAC1Z9QDTXCK"))));
                  }
                },
              ),
            ),
          ])),
    );
  }
}
