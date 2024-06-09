import 'dart:convert';
import 'dart:developer';
import 'package:mata/src/auth/model/firebase_token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/base/base_controller.dart';
import '../../../common/base/base_response.dart';
import '../../../common/helper/constant.dart';
import '../model/login_model.dart';
import 'package:flutter/material.dart';

class AuthProvider extends BaseController with ChangeNotifier {
  TextEditingController usernameC = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController NIKC = TextEditingController();
  TextEditingController namaLengkap = TextEditingController();
  TextEditingController namaIbuKAndung = TextEditingController();
  TextEditingController noTelp = TextEditingController();
  TextEditingController tempatLahir = TextEditingController();
  TextEditingController tanggalLahir = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController provinsi = TextEditingController();
  TextEditingController kabupaten = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kelurahan = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController nomorRekening = TextEditingController();
  TextEditingController atasNamaRekening = TextEditingController();
  TextEditingController tanggalUmroh = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
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
    log("EMAIL : ${usernameC.text}");
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
      'username': usernameC.text,
      'password': passC.text,
      // 'device_id': fcmId ?? '-1',
    };
    final response = await post(Constant.BASE_API_FULL + '/login', body: param);

    if (response.statusCode == 201 || response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final model = LoginModel.fromJson(jsonDecode(response.body));

      // set to shared preferences
      await prefs.setString(Constant.kSetPrefId, "${model.data?.id ?? 0}");
      await prefs.setString(Constant.kSetPrefToken, model.data!.token!);
      await prefs.setString(Constant.kSetPrefName, model.data!.name!);
      await prefs.setString(Constant.kSetPrefRoles, model.data!.jabatan!);
      await prefs.setString(Constant.kSetPrefCompany, model.data!.companyName!);
      usernameC.clear();
      passC.clear();

      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["message"];
      loading(false);
      throw Exception(message);
    }
    // } else {
    //   loading(false);
    //   throw 'Harap Lengkapi Form';
    // }
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
      final message = jsonDecode(response.body)["message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future< /*BaseResponse*/ void> logout() async {
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
    //   return response;
    // } else {
    // final message = response.message;
    loading(false);
    // throw Exception(message);
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
