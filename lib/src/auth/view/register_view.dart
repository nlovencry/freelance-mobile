// import 'dart:developer';
// import 'dart:io';

// import 'package:chatour/common/component/custom_appbar.dart';
// import 'package:chatour/common/component/custom_button.dart';
// import 'package:chatour/common/helper/constant.dart';
// import 'package:chatour/src/profil/provider/profile_provider.dart';
// import 'package:chatour/src/region/model/region_model.dart';
// import 'package:chatour/src/region/provider/region_provider.dart';
// import 'package:chatour/src/sub_provider/sub_agen_provider.dart';
// import 'package:chatour/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:path/path.dart' as p;

// import '../../../common/base/base_state.dart';
// import '../../../common/component/custom_date_picker.dart';
// import '../../../common/component/custom_dropdown.dart';
// import '../../../common/component/custom_image_picker.dart';
// import '../../../common/component/custom_textfield.dart';
// import '../provider/sign_up_provider.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// class RegisterView extends StatefulWidget {
//   static Widget create() => ChangeNotifierProvider<SignUpProvider>(
//       create: (context) => SignUpProvider(), child: RegisterView());
//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends BaseState<RegisterView> {
//   @override
//   void initState() {
//     getData();

//     super.initState();
//   }

//   getData() async {
//     await Utils.showLoading();
//     await context.read<ProfileProvider>().fetchBank();
//     // setState(() {});
//     await context.read<RegionProvider>().fetchProvince();
//     await Utils.dismissLoading();
//   }

//   String gender = 'Laki-laki';

//   @override
//   Widget build(BuildContext context) {
//     final signUpP = context.watch<SignUpProvider>();
//     final listBank =
//         context.watch<ProfileProvider>().bankModel.data?.banks ?? [];

//     final listProvince = context.watch<RegionProvider>().provinceModel.data;
//     final listCity = context.watch<RegionProvider>().cityModel.data;
//     final listDistrict = context.watch<RegionProvider>().districtModel.data;
//     final listSubDistrict =
//         context.watch<RegionProvider>().subDistrictModel.data;

//     Widget cek() {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 24,
//               margin: EdgeInsets.only(top: 10),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: Checkbox(
//                       shape: CircleBorder(),
//                       value: signUpP.setuju,
//                       fillColor:
//                           MaterialStateProperty.all(Constant.primaryColor),
//                       onChanged: (check) {
//                         context.read<SignUpProvider>().setuju = !signUpP.setuju;
//                       },
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Flexible(
//                       child: Text(
//                           'Saya setuju, syarat dan ketentuan yang berlaku'))
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget form() {
//       return Form(
//         key: signUpP.signUpKey,
//         child: Container(
//           margin: EdgeInsets.only(top: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomTextField.normalTextField(
//                 controller: signUpP.NIKC,
//                 labelText: "NIK",
//                 hintText: "NIK",
//                 textInputType: TextInputType.number,
//                 maxLength: 16,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
//                   FilteringTextInputFormatter.digitsOnly
//                 ],
//                 validator: (value) {
//                   if (value != null && value.isNotEmpty) {
//                     // if (value == null || value.isEmpty) {
//                     //   return "Maaf, NIK wajib diisi";
//                     // }
//                     if (value.isNotEmpty && value.length < 6) {
//                       return "NIK harus 16 digit";
//                     }
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 10),
//               CustomTextField.normalTextField(
//                 controller: signUpP.namaLengkapC,
//                 labelText: "Nama Lengkap",
//                 hintText: "Nama Lengkap",
//                 textInputType: TextInputType.text,
//                 textCapitalization: TextCapitalization.words,
//               ),
//               SizedBox(height: 10),
//               CustomTextField.normalTextField(
//                 controller: signUpP.namaIbuKandungC,
//                 labelText: "Nama Ibu Kandung",
//                 hintText: "Nama Ibu Kandung",
//                 textInputType: TextInputType.text,
//                 textCapitalization: TextCapitalization.words,
//               ),
//               SizedBox(height: 10),
//               CustomTextField.normalTextField(
//                   controller: signUpP.emailC,
//                   labelText: "Email",
//                   hintText: "Email"),
//               SizedBox(height: 10),
//               CustomTextField.normalTextField(
//                 controller: signUpP.noTelpC,
//                 labelText: "No. Telp",
//                 hintText: "No. Telp",
//                 textInputType: TextInputType.phone,
//                 prefix: Container(
//                     margin: EdgeInsets.fromLTRB(12, 12, 0, 0),
//                     child: Text("62  |")),
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
//                   FilteringTextInputFormatter.digitsOnly,
//                   // FilteringTextInputFormatter.allow(RegExp(r'^(0|[1-9][0-9]*)$')),
//                 ],
//               ),
//               SizedBox(height: 10),
//               CustomTextField.normalTextField(
//                 controller: signUpP.tempatLahirC,
//                 labelText: "Tempat Lahir",
//                 hintText: "Tempat Lahir",
//                 required: false,
//               ),
//               SizedBox(height: 10),
//               CustomTextField.normalTextField(
//                 controller: signUpP.tanggalLahirC,
//                 labelText: "Tanggal Lahir",
//                 hintText: "Tanggal Lahir",
//                 readOnly: true,
//                 onTap: () async {
//                   await signUpP.setTanggalLahir(
//                       await CustomDatePicker.pickDateAndTime(context, DateTime.now()));
//                   FocusManager.instance.primaryFocus?.unfocus();
//                 },
//                 suffixIcon: Icon(Icons.calendar_month),
//                 suffixIconColor: Colors.black,
//                 required: false,
//               ),
//               SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: Text(
//                   "Jenis Kelamin",
//                   style: Constant.primaryTextStyle.copyWith(
//                     fontSize: 14,
//                     fontWeight: Constant.medium,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Row(
//                   children: [
//                     Radio(
//                       value: true,
//                       groupValue: signUpP.gender,
//                       activeColor: Constant.primaryColor,
//                       onChanged: (value) =>
//                           context.read<SignUpProvider>().gender = value,
//                     ),
//                     Text(
//                       'Laki-laki',
//                       style: Constant.primaryTextStyle,
//                     ),
//                     Radio(
//                       value: false,
//                       groupValue: signUpP.gender,
//                       activeColor: Constant.primaryColor,
//                       onChanged: (value) =>
//                           context.read<SignUpProvider>().gender = value,
//                     ),
//                     Text(
//                       'Perempuan',
//                       style: Constant.primaryTextStyle,
//                     ),
//                   ],
//                 ),
//               ),
//               CustomTextField.normalTextField(
//                 controller: signUpP.alamatC,
//                 labelText: "Alamat",
//                 hintText: "Alamat",
//                 required: false,
//               ),
//               SizedBox(height: 10),
//               CustomDropdown.normalDropdown(
//                   labelText: "Provinsi",
//                   hintText: "Pilih Provinsi",
//                   selectedItem: signUpP.provinsiNameV,
//                   list: (listProvince ?? [])
//                       .map((e) => DropdownMenuItem(
//                           value: e?.province, child: Text(e?.province ?? "")))
//                       .toList(),
//                   onChanged: (val) {
//                     signUpP.kotaNameV = null;
//                     signUpP.kotaIdV = null;
//                     signUpP.provinsiNameV = val;
//                     signUpP.kecamatanIdV = null;
//                     signUpP.kecamatanNameV = null;
//                     signUpP.desaIdV = null;
//                     signUpP.desaNameV = null;
//                     signUpP.provinsiIdV = (listProvince ?? [])
//                         .firstWhere((element) => element?.province == val)
//                         ?.provinceId;
//                     setState(() {});
//                     context.read<RegionProvider>().cityModel = CityModel();
//                     context.read<RegionProvider>().fetchCity(
//                         signUpP.provinsiIdV ?? "",
//                         withLoading: true);
//                   }),
//               SizedBox(height: 10),
//               CustomDropdown.normalDropdown(
//                 labelText: "Kabupaten / Kota",
//                 selectedItem: signUpP.kotaNameV,
//                 hintText: "Pilih Kabupaten / Kota",
//                 list: (listCity ?? [])
//                     .map((e) => DropdownMenuItem(
//                         value: e?.cityName, child: Text(e?.cityName ?? "")))
//                     .toList(),
//                 onChanged: (val) {
//                   signUpP.kecamatanIdV = null;
//                   signUpP.kecamatanNameV = null;
//                   signUpP.kotaNameV = val;
//                   signUpP.kotaIdV = (listCity ?? [])
//                       .firstWhere((element) => element?.cityName == val)
//                       ?.cityId;
//                   setState(() {});

//                   context.read<RegionProvider>().districtModel =
//                       DistrictModel();
//                   context
//                       .read<RegionProvider>()
//                       .fetchDistrict(signUpP.kotaIdV ?? "", withLoading: true);
//                 },
//               ),
//               SizedBox(height: 10),
//               CustomDropdown.normalDropdown(
//                 labelText: "Kecamatan",
//                 selectedItem: signUpP.kecamatanNameV,
//                 hintText: "Pilih Kecamatan",
//                 list: (listDistrict ?? [])
//                     .map((e) => DropdownMenuItem(
//                         value: e?.districtName,
//                         child: Text(e?.districtName ?? "")))
//                     .toList(),
//                 onChanged: (val) {
//                   signUpP.desaIdV = null;
//                   signUpP.desaNameV = null;
//                   signUpP.kecamatanNameV = val;
//                   signUpP.kecamatanIdV = (listDistrict ?? [])
//                       .firstWhere((element) => element?.districtName == val)
//                       ?.districtId;
//                   setState(() {});

//                   context.read<RegionProvider>().subDistrictModel =
//                       SubDistrictModel();
//                   // context.read<RegionProvider>().fetchSubDistrict(
//                   //     signUpP.kecamatanIdV ?? "", signUpP.kecamatanIdV ?? "");
//                 },
//               ),
//               // SizedBox(height: 10),
//               // CustomDropdown.normalDropdown(
//               //   labelText: "Kelurahan / Desa",
//               //   selectedItem: signUpP.desaNameV,
//               //   hintText: "Pilih Kelurahan / Desa",
//               //   list: (listSubDistrict ?? [])
//               //       .map((e) => DropdownMenuItem(
//               //           value: e?.subdistrictName,
//               //           child: Text(e?.subdistrictName ?? "")))
//               //       .toList(),
//               //   onChanged: (val) {
//               //     signUpP.desaNameV = val;
//               //     signUpP.desaIdV = (listSubDistrict ?? [])
//               //         .firstWhere((element) => element?.subdistrictName == val)
//               //         ?.subdistrictId;
//               //     setState(() {});
//               //   },
//               // ),
//               SizedBox(height: 10),
//               CustomDropdown.normalDropdown(
//                 labelText: "Bank Rekening",
//                 hintText: "Pilih Bank Rekening",
//                 list: listBank
//                     .map((e) => DropdownMenuItem<String>(
//                           value: e,
//                           child: Text(e ?? ""),
//                         ))
//                     .toList(),
//                 onChanged: (val) => signUpP.bankRekV = val,
//                 required: true,
//               ),
//               SizedBox(height: 10),
//               CustomTextField.normalTextField(
//                 controller: signUpP.noRekC,
//                 labelText: "Nomor Rekening",
//                 hintText: "Nomor Rekening",
//                 textInputType: TextInputType.number,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
//                   FilteringTextInputFormatter.digitsOnly
//                 ],
//                 required: false,
//               ),
//               SizedBox(height: 10),
//               CustomTextField.normalTextField(
//                 controller: signUpP.atasNamaRekC,
//                 labelText: "Atas Nama Rekening",
//                 hintText: "Atas Nama Rekening",
//                 textCapitalization: TextCapitalization.words,
//                 required: false,
//               ),
//               SizedBox(height: 14),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   children: [
//                     Icon(Icons.image, size: 24),
//                     Expanded(
//                         child: CustomButton.secondaryButton(
//                             signUpP.pasPhotoPic != null
//                                 ? p.basename(signUpP.pasPhotoPic!.path)
//                                 : 'Upload Pas Foto', () async {
//                       var file =
//                           await CustomImagePicker.cameraOrGallery(context);
//                       if (file != null) {
//                         signUpP.pasPhotoPic = File(file.path);
//                       }
//                     }, margin: EdgeInsets.only(left: 10)))
//                   ],
//                 ),
//               ),
//               SizedBox(height: 14),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   children: [
//                     Icon(Icons.image, size: 24),
//                     Expanded(
//                         child: CustomButton.secondaryButton(
//                             signUpP.ktpPic != null
//                                 ? p.basename(signUpP.ktpPic!.path)
//                                 : 'Upload Foto KTP', () async {
//                       var file =
//                           await CustomImagePicker.cameraOrGallery(context);
//                       if (file != null) {
//                         signUpP.ktpPic = File(file.path);
//                       }
//                     }, margin: EdgeInsets.only(left: 10)))
//                   ],
//                 ),
//               ),
//               SizedBox(height: 14),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   children: [
//                     Icon(Icons.image, size: 24),
//                     Expanded(
//                         child: CustomButton.secondaryButton(
//                             signUpP.paymentPic != null
//                                 ? p.basename(signUpP.paymentPic!.path)
//                                 : 'Upload Bukti Pembayaran', () async {
//                       var file =
//                           await CustomImagePicker.cameraOrGallery(context);
//                       if (file != null) {
//                         signUpP.paymentPic = File(file.path);
//                       }
//                     }, margin: EdgeInsets.only(left: 10)))
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10),
//               cek(),
//               SizedBox(height: 14),
//               CustomButton.mainButton('Simpan', () {
//                 if (signUpP.setuju) {
//                   handleTap(
//                     () async {
//                       await context
//                           .read<SignUpProvider>()
//                           .addAgen()
//                           .then((value) async {
//                         await Utils.showSuccess(
//                             msg:
//                                 "Sukses Daftar Agen, Silahkan tunggu pemberitahuan lebih lanjut di WhatsApp Anda");
//                         Future.delayed(
//                             Duration(seconds: 4),
//                             () => Navigator.pushReplacementNamed(
//                                 context, '/login'));
//                       }).onError((error, stackTrace) {
//                         FirebaseCrashlytics.instance
//                             .log("Daftar Agen Error : " + error.toString());
//                         Utils.showFailed(
//                             msg: error
//                                     .toString()
//                                     .toLowerCase()
//                                     .contains("doctype")
//                                 ? "Gagal Daftar Agen"
//                                 : "$error");
//                       });
//                     },
//                   );
//                 }
//               },
//                   color: !isBusy() && signUpP.setuju
//                       ? Constant.primaryColor
//                       : Colors.grey,
//                   margin: EdgeInsets.symmetric(horizontal: 20)),
//               SizedBox(height: 24),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: CustomAppBar.appBar('Daftar Agen',
//           isLeading: true, isCenter: true, color: Colors.black),
//       body: WillPopScope(
//           onWillPop: () async {
//             await Utils.showYesNoDialog(
//               context: context,
//               title: "Batalkan Daftar Agen",
//               desc: 'Apakah Anda yakin ingin membatalkan daftar agen?',
//               yesCallback: () async {
//                 await context.read<SignUpProvider>().clearAgen().then((value) {
//                   Navigator.of(context)
//                     ..pop()
//                     ..pop();
//                   return true;
//                 }).onError((error, stackTrace) {
//                   FirebaseCrashlytics.instance
//                       .log("Cancel Daftar Agen Error : " + error.toString());
//                   Utils.showFailed(
//                       msg: error.toString().toLowerCase().contains("doctype")
//                           ? "Gagal Batalkan Daftar Agen!"
//                           : "$error");
//                   return false;
//                 });
//               },
//               noCallback: () {
//                 Navigator.pop(context);
//               },
//             );
//             return false;
//           },
//           child: ListView(children: [form()])),
//     );
//   }
// }
