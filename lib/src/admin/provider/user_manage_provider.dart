import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powers/powers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import '../../../utils/utils.dart';
import '../../../common/base/base_controller.dart';
import '../../../common/helper/constant.dart';
import '../../../common/component/custom_dropdown.dart';
import '../../../common/component/custom_textfield.dart';
import '../model/user_detail_model.dart';

class UserManageProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> userAddKey = GlobalKey<FormState>();

  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController roleC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  String? selectedRole;

  bool _obscurePass = true;

  bool get obscurePass => this._obscurePass;

  toggleObscurePass() {
    this._obscurePass = !obscurePass;
    notifyListeners();
  }

  onChangedRole(String? v) {
    String? selected = v;
    if (selected != null) {
      selectedRole = v;
      roleC.text = selected;
    }
  }

  UserDetailModel _userDetailModel = UserDetailModel();
  UserDetailModel get userDetailModel => this._userDetailModel;
  set userDetailModel (UserDetailModel value) => this._userDetailModel = value;

  Future<UserDetailModel> fetchUserDetail({required String id}) async {
    loading(true);
    final response = await get(Constant.BASE_API_FULL + 'admin/users/$id');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = UserDetailModel.fromJson(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      return message;
    }
  }

  List<Widget> userForm() {
    return [
      Text("Input Data User", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukkan data user pada field dibawah", style: Constant.grayMedium),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: nameC,
        textInputType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
        ],
        labelText: "Nama",
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: nipC,
        required: false,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.digitsOnly,
        ],
        labelText: "NIP",
      ),
      Constant.xSizedBox16,
      CustomDropdown.normalDropdown(
        controller: roleC,
        iconPadding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        contentPadding: EdgeInsets.all(2),
        borderColor: Constant.primaryColor,
        labelText: "Role",
        //selectedItem: selectedRole,
        hintText: "Role",
        list: [
          DropdownMenuItem(child: Text("Admin"), value: "admin"),
          DropdownMenuItem(child: Text("User"), value: "user")
        ],
        onChanged: onChangedRole,
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: usernameC,
        labelText: "Username",
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: passwordC,
        labelText: "Password",
        obscureText: obscurePass,
        suffixIcon: InkWell(
          onTap: () => toggleObscurePass(),
          child: Icon(
            obscurePass ? Icons.visibility_off_outlined : Icons.visibility,
            color: Constant.primaryColor,
          ),
        ),
      ),
      Constant.xSizedBox16,
    ];
  }
  
}
