// import 'dart:convert';

// import 'package:chatour/common/base/base_controller.dart';
// import 'package:flutter/material.dart';

// import '../../../common/base/base_response.dart';
// import '../../../common/helper/constant.dart';
// import '../model/paket_city_departure_model.dart';
// import '../model/paket_detail_model.dart';
// import '../model/paket_filter_model.dart';
// import '../model/paket_model.dart';
// import '../model/schedule_model.dart';

// class PaketProvider extends BaseController with ChangeNotifier {
//   PaketFilterModel _paketFilterUmrohModel = PaketFilterModel();

//   PaketFilterModel get paketFilterUmrohModel => this._paketFilterUmrohModel;

//   set paketFilterUmrohModel(PaketFilterModel value) {
//     this._paketFilterUmrohModel = value;
//     notifyListeners();
//   }

//   PaketFilterModel _paketFilterHajiModel = PaketFilterModel();

//   PaketFilterModel get paketFilterHajiModel => this._paketFilterHajiModel;

//   set paketFilterHajiModel(PaketFilterModel value) {
//     this._paketFilterHajiModel = value;
//     notifyListeners();
//   }

//   PaketModel _paketUmrohModel = PaketModel();

//   PaketModel get paketUmrohModel => this._paketUmrohModel;

//   set paketUmrohModel(PaketModel value) {
//     this._paketUmrohModel = value;
//     notifyListeners();
//   }

//   PaketModel _paketHajiModel = PaketModel();

//   PaketModel get paketHajiModel => this._paketHajiModel;

//   set paketHajiModel(PaketModel value) {
//     this._paketHajiModel = value;
//     notifyListeners();
//   }

//   PaketDetailModel _paketDetailModel = PaketDetailModel();

//   PaketDetailModel get paketDetailModel => this._paketDetailModel;

//   set paketDetailModel(PaketDetailModel value) {
//     this._paketDetailModel = value;
//     notifyListeners();
//   }

//   PaketCityDepartureModel _paketCityDepartureModel = PaketCityDepartureModel();

//   PaketCityDepartureModel get paketCityDepartureModel =>
//       this._paketCityDepartureModel;

//   set paketCityDepartureModel(PaketCityDepartureModel value) {
//     this._paketCityDepartureModel = value;
//     notifyListeners();
//   }

//   bool _readMore = false;
//   bool get readMore => this._readMore;

//   set readMore(bool value) {
//     this._readMore = value;
//     notifyListeners();
//   }

//   int? _selectedBulan;
//   String? _selectedKota;
//   String? _selectedKotaName;
//   bool _isReguler = false;
//   bool _isPromo = false;
//   int? get selectedBulan => this._selectedBulan;

//   set selectedBulan(int? value) => this._selectedBulan = value;

//   String? get selectedKota => this._selectedKota;

//   set selectedKota(value) => this._selectedKota = value;

//   String? get selectedKotaName => this._selectedKotaName;

//   set selectedKotaName(String? value) => this._selectedKotaName = value;
//   bool get isReguler => this._isReguler;

//   set isReguler(value) => this._isReguler = value;

//   bool get isPromo => this._isPromo;

//   set isPromo(value) => this._isPromo = value;

//   Future<void> fetchPaketUmroh({bool withLoading = false}) async {
//     if (withLoading) loading(true);
//     Map<String, String> param = {
//       'product_id': "1",
//       'is_promo': isPromo == true ? "1" : "0",
//       'is_reguler': isReguler == true ? "1" : "0",
//     };
//     if (selectedKota != null) param.addAll({'city_id': selectedKota ?? ""});
//     if (selectedBulan != null)
//       param.addAll({'month': selectedBulan.toString()});

//     final response =
//         await get(Constant.BASE_API_FULL + '/package-list', query: param);

//     if (response.statusCode == 200) {
//       final model = PaketModel.fromJson(jsonDecode(response.body));
//       paketUmrohModel = model;
//       notifyListeners();
//       if (withLoading) loading(false);
//     } else {
//       final message = jsonDecode(response.body)['Message'];
//       loading(false);
//       throw Exception(message);
//     }
//   }

//   Future<void> fetchPaketHaji({bool withLoading = false}) async {
//     if (withLoading) loading(true);
//     Map<String, String> param = {
//       'product_id': "2",
//       'is_promo': isPromo == true ? "1" : "0",
//       'is_reguler': isReguler == true ? "1" : "0",
//     };
//     if (selectedKota != null) param.addAll({'city_id': selectedKota ?? ""});
//     if (selectedBulan != null)
//       param.addAll({'month': selectedBulan.toString()});

//     final response =
//         await get(Constant.BASE_API_FULL + '/package-list', query: param);

//     if (response.statusCode == 200) {
//       final subagen = PaketModel.fromJson(jsonDecode(response.body));
//       paketHajiModel = subagen;
//       notifyListeners();
//       if (withLoading) loading(false);
//     } else {
//       final message = jsonDecode(response.body)['Message'];
//       loading(false);
//       throw Exception(message);
//     }
//   }

//   clearFilter() {
//     isReguler = false;
//     isPromo = false;
//     selectedKota = null;
//     selectedKotaName = null;
//     paketFilterUmrohModel = PaketFilterModel();
//     paketFilterHajiModel = PaketFilterModel();
//     selectedBulan = null;
//   }

//   Future<void> fetchDetailPaket(
//       {bool withLoading = false, required String paketId}) async {
//     if (withLoading) loading(true);

//     final response =
//         await get(Constant.BASE_API_FULL + '/package-detail/$paketId');

//     if (response.statusCode == 200) {
//       final model = PaketDetailModel.fromJson(jsonDecode(response.body));
//       paketDetailModel = model;
//       notifyListeners();
//       if (withLoading) loading(false);
//     } else {
//       final message = jsonDecode(response.body)['Message'];
//       loading(false);
//       throw Exception(message);
//     }
//   }

//   Future<void> fetchCityDeparture({bool withLoading = false}) async {
//     if (withLoading) loading(true);
//     final response = await get(Constant.BASE_API_FULL + '/city');

//     if (response.statusCode == 200) {
//       final cityDeparture =
//           PaketCityDepartureModel.fromJson(jsonDecode(response.body));
//       paketCityDepartureModel = cityDeparture;
//       notifyListeners();
//       if (withLoading) loading(false);
//     } else {
//       final message = jsonDecode(response.body)['Message'];
//       loading(false);
//       throw Exception(message);
//     }
//   }

//   Future<BaseResponse> pilihPaket(
//       {required String paketId,
//       required String bookingMemberId,
//       required String packageScheduleid}) async {
//     loading(true);
//     Map<String, String> param = {
//       "package_id": paketId,
//       "booking_member_id": bookingMemberId,
//       "package_schedule_id": packageScheduleid
//     };

//     final response = BaseResponse.from(await post(
//         Constant.BASE_API_FULL + '/booking-package',
//         body: param));

//     if (response.success) {
//       loading(false);
//       return response;
//     } else {
//       final message = response.message;
//       loading(false);
//       throw Exception(message);
//     }
//   }

//   ScheduleModel _scheduleModel = ScheduleModel();

//   ScheduleModel get scheduleModel => this._scheduleModel;

//   set scheduleModel(ScheduleModel value) => this._scheduleModel = value;

//   Future<void> fetchSchedule(
//       {required String packageId, bool withLoading = false}) async {
//     if (withLoading) loading(true);
//     final response =
//         await get(Constant.BASE_API_FULL + '/schedule-list/$packageId');

//     if (response.statusCode == 200) {
//       final schedule = ScheduleModel.fromJson(jsonDecode(response.body));
//       scheduleModel = schedule;
//       notifyListeners();
//       if (withLoading) loading(false);
//     } else {
//       final message = jsonDecode(response.body)['Message'];
//       loading(false);
//       throw Exception(message);
//     }
//   }
// }
