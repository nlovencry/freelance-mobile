// import 'dart:convert';
// import 'dart:io';

// import 'package:chatour/common/base/base_controller.dart';
// import 'package:chatour/common/base/base_response.dart';
// import 'package:chatour/common/helper/constant.dart';
// import 'package:chatour/src/profil/model/bank_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'package:http/http.dart' as http;
// import '../../../common/helper/multipart.dart';

// class SignUpProvider extends BaseController with ChangeNotifier {
//   BankModel _bankModel = BankModel();

//   BankModel get bankModel => this._bankModel;

//   set bankModel(BankModel value) => this._bankModel = value;

//   TextEditingController NIKC = TextEditingController();
//   TextEditingController namaLengkapC = TextEditingController();
//   TextEditingController namaIbuKandungC = TextEditingController();
//   TextEditingController emailC = TextEditingController();
//   TextEditingController noTelpC = TextEditingController();
//   TextEditingController tempatLahirC = TextEditingController();
//   TextEditingController tanggalLahirC = TextEditingController();
//   TextEditingController alamatC = TextEditingController();
//   TextEditingController noRekC = TextEditingController();
//   TextEditingController atasNamaRekC = TextEditingController();

//   TextEditingController _provinsiC = TextEditingController();
//   TextEditingController _kotaC = TextEditingController();
//   TextEditingController _kecamatanNameVC = TextEditingController();
//   TextEditingController _desaC = TextEditingController();

//   TextEditingController get provinsiC => this._provinsiC;

//   set provinsiC(TextEditingController value) => this._provinsiC = value;

//   TextEditingController get kotaC => this._kotaC;

//   set kotaC(value) => this._kotaC = value;

//   TextEditingController get kecamatanNameVC => this._kecamatanNameVC;

//   set kecamatanNameVC(value) => this._kecamatanNameVC = value;

//   TextEditingController get desaC => this._desaC;

//   set desaC(value) => this._desaC = value;

//   String? _provinsiNameV;
//   String? _kotaNameV;
//   String? _kecamatanNameV;
//   String? _desaNameV;
//   String? _bankRekV;

//   String? get provinsiNameV => this._provinsiNameV;

//   set provinsiNameV(String? value) {
//     this._provinsiNameV = value;
//     notifyListeners();
//   }

//   get kotaNameV => this._kotaNameV;

//   set kotaNameV(value) {
//     this._kotaNameV = value;
//     notifyListeners();
//   }

//   get kecamatanNameV => this._kecamatanNameV;

//   set kecamatanNameV(value) {
//     this._kecamatanNameV = value;
//     notifyListeners();
//   }

//   get desaNameV => this._desaNameV;

//   set desaNameV(value) {
//     this._desaNameV = value;
//     notifyListeners();
//   }

//   get bankRekV => this._bankRekV;

//   set bankRekV(value) {
//     this._bankRekV = value;
//     notifyListeners();
//   }

//   String? _provinsiIdV;
//   String? _kotaIdV;
//   String? _kecamatanIdV;
//   String? _desaIdV;
//   String? get provinsiIdV => this._provinsiIdV;

//   set provinsiIdV(String? value) {
//     this._provinsiIdV = value;
//     notifyListeners();
//   }

//   get kotaIdV => this._kotaIdV;

//   set kotaIdV(value) {
//     this._kotaIdV = value;
//     notifyListeners();
//   }

//   get kecamatanIdV => this._kecamatanIdV;

//   set kecamatanIdV(value) {
//     this._kecamatanIdV = value;
//     notifyListeners();
//   }

//   get desaIdV => this._desaIdV;

//   set desaIdV(value) {
//     this._desaIdV = value;
//     notifyListeners();
//   }

//   bool _gender = true;

//   get gender => _gender;

//   set gender(value) {
//     this._gender = value;
//     notifyListeners();
//   }

//   bool _setuju = false;
//   bool get setuju => this._setuju;

//   set setuju(bool value) {
//     this._setuju = value;
//     notifyListeners();
//   }

//   GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

//   DateTime? _tanggalLahir;

//   get tanggalLahir => _tanggalLahir;

//   setTanggalLahir(DateTime? date) {
//     _tanggalLahir = date;
//     tanggalLahirC.text =
//         DateFormat("dd MMMM yyyy").format(date ?? DateTime.now()).toString();

//     notifyListeners();
//   }

//   bool isAgent = true;
//   bool get getIsAgent => this.isAgent;

//   set setIsAgent(bool isAgent) => this.isAgent = isAgent;

//   File? _pasPhotoPic;
//   File? get pasPhotoPic => _pasPhotoPic;

//   set pasPhotoPic(File? pasPhotoPic) {
//     _pasPhotoPic = pasPhotoPic;
//     notifyListeners();
//   }

//   File? _ktpPic;
//   File? get ktpPic => _ktpPic;

//   set ktpPic(File? ktpPic) {
//     _ktpPic = ktpPic;
//     notifyListeners();
//   }

//   File? _paymentPic;
//   File? get paymentPic => _paymentPic;

//   set paymentPic(File? paymentPic) {
//     _paymentPic = paymentPic;
//     notifyListeners();
//   }

//   Future<void> addAgen() async {
//     loading(true);
//     if (signUpKey.currentState!.validate()) {
//       Map<String, String> param = {
//         'nik': NIKC.text,
//         'name': namaLengkapC.text,
//         "mother_name": namaIbuKandungC.text,
//         'email': emailC.text,
//         'phone': "62" + noTelpC.text,
//         'birth_place': tempatLahirC.text,
//         'birth_date': tanggalLahir.toString(),
//         'gender': "${gender ? 1 : 0}",
//         'address': alamatC.text,
//         'province': provinsiNameV.toString(),
//         'city': kotaNameV.toString(),
//         'sub_district': kecamatanNameV.toString(),
//         'district': desaNameV.toString(),
//         'bank_name': bankRekV.toString(),
//         'bank_account': noRekC.text,
//         "account_name": atasNamaRekC.text,
//       };
//       // if (NIKC.text != "") {
//       //   param.addAll({'nik': NIKC.text});
//       // }
//       // if (tempatLahirC.text != "") {
//       //   param.addAll({'birth_place': tempatLahirC.text});
//       // }
//       // if (tanggalLahir != null) {
//       //   param.addAll({'birth_date': tanggalLahir.toString()});
//       // }
//       // if (alamatC.text != "") {
//       //   param.addAll({'address': alamatC.text});
//       // }
//       // if (provinsiNameV != null) {
//       //   param.addAll({'province': provinsiNameV.toString()});
//       // }
//       // if (kotaNameV != null) {
//       //   param.addAll({'city': kotaNameV.toString()});
//       // }
//       // if (kecamatanNameV != null) {
//       //   param.addAll({'sub_district': kecamatanNameV.toString()});
//       // }
//       // if (bankRekV != null) {
//       //   param.addAll({'bank_name': bankRekV.toString()});
//       // }
//       // if (noRekC.text != "") {
//       //   param.addAll({'bank_account': noRekC.text});
//       // }

//       List<http.MultipartFile> files = [];
//       if (pasPhotoPic != null) {
//         files.add(await getMultipart('photo', File(pasPhotoPic!.path)));
//       } else {
//         // throw 'Harap Isi Pas Foto';
//       }
//       if (ktpPic != null) {
//         files.add(await getMultipart('ktp', File(ktpPic!.path)));
//       } else {
//         // throw 'Harap Isi Foto KTP';
//       }
//       if (paymentPic != null) {
//         files.add(await getMultipart('payment_proof', File(paymentPic!.path)));
//       } else {
//         // throw 'Harap Isi Foto Bukti Pembayaran';
//       }
//       final response = BaseResponse.from(await post(
//         Constant.BASE_API_FULL + '/register-agen',
//         body: param,
//         files: files.isEmpty ? null : files,
//       ));

//       if (response.success) {
//         NIKC.clear();
//         namaLengkapC.clear();
//         namaIbuKandungC.clear();
//         emailC.clear();
//         noTelpC.clear();
//         tempatLahirC.clear();
//         _tanggalLahir = null;
//         tanggalLahirC.clear();
//         gender = true;
//         alamatC.clear();
//         provinsiIdV = null;
//         provinsiNameV = null;
//         kotaIdV = null;
//         kotaNameV = null;
//         kecamatanIdV = null;
//         kecamatanNameV = null;
//         desaIdV = null;
//         desaNameV = null;
//         noRekC.clear();
//         atasNamaRekC.clear();
//         bankRekV = null;
//         pasPhotoPic = null;
//         ktpPic = null;
//         paymentPic = null;
//         setuju = false;
//         loading(false);
//       } else {
//         loading(false);
//         throw Exception(response.message);
//       }
//     } else {
//       loading(false);
//       throw 'Harap Lengkapi Form';
//     }
//   }

//   Future<void> clearAgen() async {
//     NIKC.clear();
//     namaLengkapC.clear();
//     namaIbuKandungC.clear();
//     emailC.clear();
//     noTelpC.clear();
//     tempatLahirC.clear();
//     _tanggalLahir = null;
//     tanggalLahirC.clear();
//     gender = true;
//     alamatC.clear();
//     provinsiIdV = null;
//     provinsiNameV = null;
//     kotaIdV = null;
//     kotaNameV = null;
//     kecamatanIdV = null;
//     kecamatanNameV = null;
//     desaIdV = null;
//     desaNameV = null;
//     noRekC.clear();
//     atasNamaRekC.clear();
//     bankRekV = null;
//     pasPhotoPic = null;
//     ktpPic = null;
//     paymentPic = null;
//   }

//   Future<void> fetchBank() async {
//     loading(true);
//     final response = await get(Constant.BASE_API_FULL + '/list-bank');

//     if (response.statusCode == 200) {
//       final model = BankModel.fromJson(jsonDecode(response.body));
//       bankModel = model;
//       notifyListeners();
//       loading(false);
//     } else {
//       final message = jsonDecode(response.body)["Message"];
//       loading(false);
//       throw Exception(message);
//     }
//   }
// }
