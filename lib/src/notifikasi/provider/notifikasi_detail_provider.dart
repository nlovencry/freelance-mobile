// import 'dart:convert';
// import 'dart:developer';

// import 'package:chatour/common/base/base_controller.dart';
// import 'package:chatour/common/helper/constant.dart';
// import 'package:chatour/src/notifikasi/model/notifikasi_detail_model.dart';
// import 'package:flutter/material.dart';

// class NotifikasiDetailProvider extends BaseController with ChangeNotifier {
//   NotifikasiDetailModel _notifikasiDetailModel = NotifikasiDetailModel();

//   NotifikasiDetailModel get notifikasiDetailModel =>
//       this._notifikasiDetailModel;

//   set notifikasiDetailModel(NotifikasiDetailModel value) =>
//       this._notifikasiDetailModel = value;

//   Future<void> fetchDetailNotifikasi(int id) async {
//     loading(true);
//     final response =
//         await get(Constant.BASE_API_FULL + '/notification-detail/${id}');

//     if (response.statusCode == 200) {
//       final model = NotifikasiDetailModel.fromJson(jsonDecode(response.body));
//       notifikasiDetailModel = model;
//       notifyListeners();
//       loading(false);
//     } else {
//       final message = jsonDecode(response.body)["Message"];
//       loading(false);
//       throw Exception(message);
//     }
//   }
// }
