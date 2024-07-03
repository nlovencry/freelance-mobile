import 'package:hy_tutorial/common/component/custom_dropdown.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/data/provider/data_add_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/common/component/custom_navigator.dart';
import 'package:hy_tutorial/common/component/custom_textfield.dart';

import '../provider/user_provider.dart';

class UserAddView extends StatefulWidget {
  bool isEdit;
  UserAddView({super.key, this.isEdit = false});

  @override
  State<UserAddView> createState() => _UserAddViewState();
}

class _UserAddViewState extends State<UserAddView> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProvider>();
    List<Widget> form = [
      Text("Input data user", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data user pada field di bawah", style: Constant.grayMedium),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: p.nameC,
        labelText: "Nama",
        readOnly: widget.isEdit,
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: p.divisionC,
        labelText: "Divisi / Jabatan",
        readOnly: widget.isEdit,
      ),
      Constant.xSizedBox16,
      CustomDropdown.normalDropdown(
          isDense: true,
          readOnly: widget.isEdit,
          contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          list: p.role
              .map((e) => DropdownMenuItem(child: Text(e), value: e))
              .toList(),
          onChanged: (v) {
            if (!widget.isEdit) {
              p.roleSelected = v;
              setState(() {});
            }
          },
          selectedItem: p.roleSelected,
          controller: p.divisionC,
          labelText: "Role"),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: p.usernameC,
        labelText: "Username",
        readOnly: widget.isEdit,
      ),
      Constant.xSizedBox16,
    ];
    ;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
          context, "${widget.isEdit ? "Edit" : "Tambah"} Data"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ListView(
          children: [...form],
        ),
      ),
    );
  }
}
