import 'dart:convert';
import 'dart:developer';

import 'package:bimops/common/base/base_controller.dart';
import 'package:bimops/src/report/model/report_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> createReportKey = GlobalKey<FormState>();

  // PagingController<int, ReportModelData> _pagingController =
  // PagingController(firstPageKey: 1);
  //
  // PagingController<int, ReportModelData> get pagingController =>
  //     this._pagingController;

  // set pagingController(PagingController<int, ReportModelData> value) {
  //   this._pagingController = value;
  // }

  bool _isFetching = false;
  bool get isFetching => this._isFetching;

  set isFetching(bool value) {
    this._isFetching = value;
  }

  int pageSize = 0;

  get getPageSize => this.pageSize;

  set setPageSize(pageSize) {
    this.pageSize;
  }

  TextEditingController _assetPerformanceSearchC = TextEditingController();
  get assetPerformanceSearchC => this._assetPerformanceSearchC;
  set assetPerformanceSearchC(value) => this._assetPerformanceSearchC = value;

  TextEditingController _reportSearchC = TextEditingController();
  get reportSearchC => this._reportSearchC;
  set reportSearchC(value) => this._reportSearchC = value;

//step 1
  TextEditingController woNumberC = TextEditingController();
  TextEditingController workTypeC = TextEditingController();
  TextEditingController assetC = TextEditingController();
  TextEditingController workOrderC = TextEditingController();
  TextEditingController dateDocC = TextEditingController();
  TextEditingController estimatedStartC = TextEditingController();
  TextEditingController estimatedCompleteC = TextEditingController();
  TextEditingController descC = TextEditingController();

  //step 2
  TextEditingController taskNameC = TextEditingController();
  TextEditingController taskDurationC = TextEditingController();

  //step3
  TextEditingController toolsC = TextEditingController();
  TextEditingController uomC = TextEditingController();
  TextEditingController quantityC = TextEditingController();

  //step4
  TextEditingController craftC = TextEditingController();
  TextEditingController skillC = TextEditingController();
  TextEditingController amountC = TextEditingController();

  //step5
  TextEditingController serviceC = TextEditingController();
  TextEditingController uom5C = TextEditingController();
  TextEditingController quantity5C = TextEditingController();

  //step6
  TextEditingController codeC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController uom6C = TextEditingController();
  TextEditingController warehouseC = TextEditingController();
  TextEditingController quantity6C = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController typeC = TextEditingController();
  TextEditingController reqdateC = TextEditingController();
  TextEditingController desc6C = TextEditingController();

  //step7
  TextEditingController attachC = TextEditingController();
  TextEditingController desc7C = TextEditingController();

  FocusNode descNode = FocusNode();
  FocusNode desc6Node = FocusNode();
  FocusNode desc7Node = FocusNode();

  DateTime? _dateDoc;

  get date => _dateDoc;

  setDate(DateTime? date) {
    _dateDoc = date;
    dateDocC.text = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  DateTime? _estimatedStart;

  get estimatedStart => _estimatedStart;

  setEstimatedStart(DateTime? date) {
    _estimatedStart = date;
    estimatedStartC.text = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  DateTime? _estimatedComplete;

  get estimatedComplete => _estimatedComplete;

  setEstimatedComplete(DateTime? date) {
    _estimatedComplete = date;
    estimatedCompleteC.text = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  DateTime? _reqDate;

  get reqDate => _reqDate;

  setReqDate(DateTime? date) {
    _reqDate = date;
    reqdateC.text = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  String? _workTypeV;

  String? get workTypeV => this._workTypeV;

  set workTypeV(String? value) {
    this._workTypeV = value;
    notifyListeners();
  }

  String? _workTypeIdV;

  String? get workTypeIdV => this._workTypeIdV;

  set workTypeIdV(String? value) {
    this._workTypeIdV = value;
    notifyListeners();
  }

  String? _craftV;

  String? get craftV => this._craftV;

  set craftV(String? value) {
    this._craftV = value;
    notifyListeners();
  }

  String? _craftIdV;

  String? get craftIdV => this._craftIdV;

  set craftIdV(String? value) {
    this._craftIdV = value;
    notifyListeners();
  }

  String? _skillV;

  String? get skillV => this._skillV;

  set skillV(String? value) {
    this._skillV = value;
    notifyListeners();
  }

  String? _skillIdV;

  String? get skillIdV => this._skillIdV;

  set skillIdV(String? value) {
    this._skillIdV = value;
    notifyListeners();
  }

  String isSubAgent = "agen";
  String get getIsSubAgent => this.isSubAgent;
  ReportModel assetMeterModel = ReportModel();

  ReportModel get getReportModel => this.assetMeterModel;

  set setReportModel(ReportModel assetMeterModel) =>
      this.assetMeterModel = assetMeterModel;
  set setIsSubAgent(String isSubAgent) => this.isSubAgent = isSubAgent;

// Future<void> fetchReport({
//   bool withLoading = false,
//   required int page,
//   String keyword = "",
// }) async {
//   if (!isFetching) {
//     isFetching = true;
//     if (withLoading) loading(true);
//     Map<String, String> param = {
//       'page': '$page',
//       'search': woAgreementSearchC.text,
//     };
//
//     final response = await post(
//         Constant.BASE_API_FULL + '/transaction/work-order-agreement/list',
//         body: param);
//
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       final model = ReportModel.fromJson(jsonDecode(response.body));
//
//       final newItems = model.data ?? [];
//
//       final previouslyFetchedWordCount =
//           _pagingController.itemList?.length ?? 0;
//       pageSize = 10;
//       log("ITEMS LENGTH : ${newItems.length}");
//       final isLastPage = newItems.length < pageSize;
//
//       if (isLastPage) {
//         pagingController
//             .appendLastPage(newItems as List<ReportModelData>);
//       } else {
//         final nextPageKey = page += 1;
//         pagingController.appendPage(
//             newItems as List<ReportModelData>, nextPageKey);
//       }
//
//       // notifyListeners();
//       if (withLoading) loading(false);
//       isFetching = false;
//     } else {
//       final message = jsonDecode(response.body)["message"];
//       loading(false);
//       isFetching = false;
//       throw Exception(message);
//     }
//   }
// }

// ReportLogModel _woAgreementLogModel = ReportLogModel();
//
// ReportLogModel get woAgreementLogModel => this._woAgreementLogModel;
//
// set woAgreementLogModel(ReportLogModel value) {
//   this._woAgreementLogModel = value;
//   notifyListeners();
// }

// Future<void> fetchReportLog(String id,
//     {bool withLoading = false}) async {
//   if (withLoading) loading(true);
//   Map<String, String> param = {'id': '$id'};
//   final response = await post(
//       Constant.BASE_API_FULL + '/transaction/work-order-agreement/listLog',
//       body: param);
//
//   if (response.statusCode == 200) {
//     final model = ReportLogModel.fromJson(jsonDecode(response.body));
//     woAgreementLogModel = model;
//     notifyListeners();
//
//     if (withLoading) loading(false);
//   } else {
//     final message = jsonDecode(response.body)["message"];
//     loading(false);
//     throw Exception(message);
//   }
// }

// ReportApproveModel _woAgreementApproveModel = ReportApproveModel();
//
// ReportApproveModel get woAgreementApproveModel =>
//     this._woAgreementApproveModel;
//
// set woAgreementApproveModel(ReportApproveModel value) {
//   this._woAgreementApproveModel = value;
//   notifyListeners();
// }

//   Future<void> fetchReportApprove(String id,
//       {bool withLoading = false}) async {
//     if (withLoading) loading(true);
//     Map<String, String> param = {'id': '$id'};
//     final response = await post(
//         Constant.BASE_API_FULL +
//             '/transaction/work-order-agreement/listApprove',
//         body: param);
//
//     if (response.statusCode == 200) {
//       final model = ReportApproveModel.fromJson(jsonDecode(response.body));
//       woAgreementApproveModel = model;
//       notifyListeners();
//
//       if (withLoading) loading(false);
//     } else {
//       final message = jsonDecode(response.body)["message"];
//       loading(false);
//       throw Exception(message);
//     }
//   }
}
