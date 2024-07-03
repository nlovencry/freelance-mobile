import 'dart:convert';
import 'dart:developer';
import 'package:hy_tutorial/src/auth/model/firebase_token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/base/base_controller.dart';
import '../../../common/base/base_response.dart';
import '../../../common/helper/constant.dart';
import '../../division/model/divison_model.dart';
import '../model/config_model.dart';
import '../model/login_model.dart';
import 'package:flutter/material.dart';

class AuthProvider extends BaseController with ChangeNotifier {
  TextEditingController nameC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController passConfirmationC = TextEditingController();
  TextEditingController namaLengkap = TextEditingController();
  TextEditingController selectedDevisionC = TextEditingController();

  String? _selectedDevisionV;

  String? get selectedDevisionV => this._selectedDevisionV;

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  DivisionModelData? _selectedDivision;
  DivisionModelData? get selectedDivision => this._selectedDivision;

  set selectedDivision(DivisionModelData? value) =>
      this._selectedDivision = value;

  //forgot
  TextEditingController emailForgotC = TextEditingController();
  TextEditingController tokenC = TextEditingController();
  TextEditingController passForgotC = TextEditingController();
  TextEditingController confirmPassForgotC = TextEditingController();
  GlobalKey<FormState> forgotKey = GlobalKey<FormState>();
  GlobalKey<FormState> tokenKey = GlobalKey<FormState>();
  GlobalKey<FormState> confirmKey = GlobalKey<FormState>();

  DateTime? tanggal;

  get date => tanggal;

  bool _obscurePass = true;

  bool get obscurePass => this._obscurePass;

  toggleObscurePass() {
    this._obscurePass = !obscurePass;
    notifyListeners();
  }

  FirebaseTokenModel _firebaseTokenModel = FirebaseTokenModel();
  get firebaseTokenModel => this._firebaseTokenModel;

  set firebaseTokenModel(value) {
    this._firebaseTokenModel = value;
    notifyListeners();
  }

  Future<LoginModel> login() async {
    log("USERNAME : ${usernameC.text}");
    log("PASS : ${passC.text}");
    loading(true);
    // if (loginKey.currentState!.validate()) {
    FocusManager.instance.primaryFocus?.unfocus();
    String? fcmId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcmId = prefs.getString(Constant.kSetPrefFcmToken);
    Map<String, String> param = {
      // 'username': "19950601831",
      // 'username': "adminatria",
      // 'password': "123456",
      'Username': usernameC.text,
      'Password': passC.text,
      // 'device_id': fcmId ?? '-1',
    };
    final response =
        await post(Constant.BASE_API_FULL + '/auth/login', body: param);

    if (response.statusCode == 201 || response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final model = LoginModel.fromJson(jsonDecode(response.body));

      // set to shared preferences
      // await prefs.setString(Constant.kSetPrefId, "${model.Data?.Id ?? 0}");
      await prefs.setString(Constant.kSetPrefToken, model.Data?.Token ?? '');
      await prefs.setString(
          Constant.kSetPrefRefreshToken, model.Data?.RefreshToken ?? '');
      await prefs.setString(Constant.kSetPrefName, model.Data?.Name ?? '');
      await prefs.setString(Constant.kSetPrefRoles, model.Data!.Division!);
      // await prefs.setString(Constant.kSetPrefCompany, model.Data!.companyName!);
      usernameC.clear();
      passC.clear();

      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      // return LoginModel();
      throw Exception(message);
    }
    // } else {
    //   loading(false);
    //   throw 'Harap Lengkapi Form';
    // }
  }

  Future<void> getConfig() async {
    loading(true);
    final response =
        await get(Constant.BASE_API_FULL + '/configs/root-location');

    if (response.statusCode == 201 || response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final model = ConfigModel.fromJson(jsonDecode(response.body));

      // set to shared preferences
      await prefs.setDouble(Constant.kSetPrefConfigLat, model.Data?.Lat ?? 0);
      await prefs.setDouble(Constant.kSetPrefConfigLon, model.Data?.Long ?? 0);
      await prefs.setDouble(Constant.kSetPrefConfigRadius,
          (model.Data?.CoverageArea ?? 0).toDouble());
      await prefs.setString(Constant.kSetPrefConfigRadiusType,
          model.Data?.CoverageAreaType ?? '');
      await prefs.setBool(
          Constant.kSetPrefConfigRadiusType, model.Data?.Status ?? false);

      loading(false);
      // return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      // return LoginModel();
      throw Exception(message);
    }
  }

  Future<BaseResponse> register() async {
    loading(true);
    // if (loginKey.currentState!.validate()) {
    if (selectedDivision == null) throw 'Pilih Divisi Terlebih Dahulu';
    FocusManager.instance.primaryFocus?.unfocus();
    String? fcmId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcmId = prefs.getString(Constant.kSetPrefFcmToken);
    Map<String, String> param = {
      // 'username': "19950601831",
      // 'username': "adminatria",
      // 'password': "123456",
      'Name': nameC.text,
      'Username': usernameC.text,
      'DivisionId': selectedDivision?.Id ?? '', //Engineer
      'Password': passC.text,
      'PasswordConfirmation': passConfirmationC.text,
      // 'device_id': fcmId ?? '-1',
    };
    final response =
        await post(Constant.BASE_API_FULL + '/auth/register', body: param);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = BaseResponse.from(jsonDecode(response.body));
      nameC.clear();
      usernameC.clear();
      passC.clear();

      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
    // } else {
    //   loading(false);
    //   throw 'Harap Lengkapi Form';
    // }
  }

  Future<BaseResponse> refreshToken() async {
    loading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString(Constant.kSetPrefRefreshToken);
    Map<String, String> param = {'RefreshToken': refreshToken ?? ''};
    final response = await post(
        Constant.BASE_API_FULL + '/firebase/update-token',
        body: param);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = BaseResponse.from(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future<void> updateFirebaseToken() async {
    loading(true);
    final response =
        await post(Constant.BASE_API_FULL + '/firebase/update-token');

    if (response.statusCode == 201 || response.statusCode == 200) {
      firebaseTokenModel =
          FirebaseTokenModel.fromJson(jsonDecode(response.body));
      loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future<void> logout() async {
    loading(true);
    // final response =
    //     BaseResponse.from(await post(Constant.BASE_API_FULL + '/logout'));

    // if (response.success) {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // set to shared preferences
    await prefs.remove(Constant.kSetPrefToken);
    await prefs.remove(Constant.kSetPrefId);
    await prefs.remove(Constant.kSetPrefName);
    await prefs.remove(Constant.kSetPrefRoles);
    await prefs.clear();

    loading(false);
    // return response;
    // } else {
    //   final message = response.message;
    //   loading(false);
    //   throw Exception(message);
    // }
  }

  Future<BaseResponse> postForgot() async {
    // parameters
    final param = {'email': emailForgotC.text};
    loading(true);
    // response
    final response = BaseResponse.from(
        await post(Constant.BASE_API_FULL + '/forgot', body: param));
    loading(false);

    if (response.success) {
      return response;
    } else {
      final message = response.message;
      throw Exception(message);
    }
  }

  Future<String> postToken() async {
    // parameters
    final param = {
      'email': emailForgotC.text,
      'token': tokenC.text,
    };

    loading(true);
    // response
    final response = BaseResponse.from(
        await post(Constant.BASE_API_FULL + '/forgot/verify', body: param));
    loading(false);

    final message = response.message;
    if (response.success) {
      return message;
    } else {
      throw Exception(message);
    }
  }

  Future<String> postPassword() async {
    // parameters
    final param = {
      'email': emailForgotC.text,
      'token': tokenC.text,
      'password': passForgotC.text,
      'c_password': confirmPassForgotC.text
    };

    loading(true);
    // response
    final response = BaseResponse.from(await post(
        Constant.BASE_API_FULL + '/forgot/change-password',
        body: param));

    loading(false);

    final message = response.message;
    if (response.success) {
      usernameC.clear();
      emailForgotC.clear();
      passC.clear();
      passForgotC.clear();
      confirmPassForgotC.clear();
      return message;
    } else {
      throw Exception(message);
    }
  }

  setDate(DateTime? date) {
    tanggal = date;
    notifyListeners();
  }
}
