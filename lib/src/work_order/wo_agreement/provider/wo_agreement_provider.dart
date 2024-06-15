import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mata/common/base/base_controller.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/work_order/wo_agreement/model/wo_agreement_approve_model.dart';
import 'package:mata/src/work_order/wo_agreement/model/wo_agreement_log_model.dart';
import 'package:mata/src/work_order/wo_agreement/model/wo_agreement_model.dart';
import 'package:mata/src/work_order/wo_agreement/model/wo_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../../common/base/base_response.dart';
import '../../../../common/component/custom_button.dart';
import '../../../../common/component/custom_container.dart';
import '../../../../common/component/custom_dialog.dart';
import '../../../../common/component/custom_navigator.dart';
import '../../../../common/helper/encrypt.dart';
import '../../../../common/helper/multipart.dart';
import '../../../../utils/utils.dart';
import '../model/wo_param.dart';
import '../model/wo_search.dart';

class WOAgreementProvider extends BaseController with ChangeNotifier {
  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
  }

  bool _isEdit = false;
  bool get isEdit => this._isEdit;

  set isEdit(bool value) {
    this._isEdit = value;
    notifyListeners();
  }

  bool _isCreate = false;
  bool get isCreate => this._isCreate;

  set isCreate(bool value) {
    this._isCreate = value;
    notifyListeners();
  }

  GlobalKey<FormState> createWoAgreementtKey = GlobalKey<FormState>();
  PagingController<int, WOAgreementModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOAgreementModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, WOAgreementModelData> value) {
    this._pagingController = value;
  }

  bool _isFetching = false;
  bool get isFetching => this._isFetching;

  set isFetching(bool value) {
    this._isFetching = value;
  }

  int pageSize = 0;

  get getPageSize => this.pageSize;

  set setPageSize(pageSize) {
    this.pageSize = pageSize;
    notifyListeners();
  }

  TextEditingController woAgreementSearchC = TextEditingController();

//step 1
  TextEditingController woNumberC = TextEditingController();
  TextEditingController workTypeC = TextEditingController();
  TextEditingController workTypeShortC = TextEditingController();
  TextEditingController assetC = TextEditingController();
  TextEditingController workOrderC = TextEditingController();
  TextEditingController dateDocC = TextEditingController();
  TextEditingController estimatedStartC = TextEditingController();
  TextEditingController estimatedCompleteC = TextEditingController();
  TextEditingController descC = TextEditingController();
  bool _isDowntime = false;
  bool get isDowntime => this._isDowntime;

  set isDowntime(bool value) {
    this._isDowntime = value;
    notifyListeners();
  }

  WOWorkOrderSearchModelData _woWorkOrderSearchModelData =
      WOWorkOrderSearchModelData();
  WOWorkOrderSearchModelData get woWorkOrderSearchModelData =>
      this._woWorkOrderSearchModelData;

  set woWorkOrderSearchModelData(WOWorkOrderSearchModelData value) {
    this._woWorkOrderSearchModelData = value;
    notifyListeners();
  }

  WOAssetSearchModelData _woAssetSearchModelData = WOAssetSearchModelData();

  WOAssetSearchModelData get woAssetSearchModelData =>
      this._woAssetSearchModelData;

  set woAssetSearchModelData(WOAssetSearchModelData value) {
    this._woAssetSearchModelData = value;
    notifyListeners();
  }

  //step 2
  TextEditingController taskNameC = TextEditingController();
  TextEditingController taskDurationC = TextEditingController();

  //step3
  TextEditingController toolsC = TextEditingController();
  WOToolsSearchModelData? _toolsSelected;
  WOToolsSearchModelData? get toolsSelected => this._toolsSelected;

  set toolsSelected(WOToolsSearchModelData? value) {
    this._toolsSelected = value;
    notifyListeners();
  }

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
  WOServiceSearchModelData? _serviceSelected;
  WOServiceSearchModelData? get serviceSelected => this._serviceSelected;

  set serviceSelected(WOServiceSearchModelData? value) {
    this._serviceSelected = value;
    notifyListeners();
  }

  //step6
  TextEditingController codeC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController uom6C = TextEditingController();
  TextEditingController warehouseC = TextEditingController();
  TextEditingController quantity6C = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController typeC = TextEditingController();
  TextEditingController reqdate6C = TextEditingController();
  TextEditingController desc6C = TextEditingController();
  WOSparepartSearchModelData? _sparepartSelected;
  WOSparepartSearchModelData? get sparepartSelected => this._sparepartSelected;

  set sparepartSelected(WOSparepartSearchModelData? value) {
    this._sparepartSelected = value;
    notifyListeners();
  }

  WOWarehouseSearchModelData? _warehouseSelected;
  WOWarehouseSearchModelData? get warehouseSelected => this._warehouseSelected;

  set warehouseSelected(WOWarehouseSearchModelData? value) {
    this._warehouseSelected = value;
    notifyListeners();
  }

  //step7
  TextEditingController attachC = TextEditingController();
  String? fileAttach7Url;
  TextEditingController desc7C = TextEditingController();

  // //step 8
  // TextEditingController desc8C = TextEditingController();
  // TextEditingController date8C = TextEditingController();
  // TextEditingController justifyC = TextEditingController();
  // TextEditingController attach8C = TextEditingController();
  // WOProgressSearchModelData? _progressSelected;
  // WOProgressSearchModelData? get progressSelected => this._progressSelected;
  //
  // set progressSelected(WOProgressSearchModelData? value) {
  //   this._progressSelected = value;
  //   notifyListeners();
  // }

  // //step9
  // TextEditingController system9C = TextEditingController();
  // TextEditingController subsystem9C = TextEditingController();
  // TextEditingController desc9C = TextEditingController();
  //
  // WOSystemSearchModelData? _systemSelected;
  // WOSystemSearchModelData? get systemSelected => this._systemSelected;
  //
  // set systemSelected(WOSystemSearchModelData? value) {
  //   this._systemSelected = value;
  //   notifyListeners();
  // }
  //
  // WOSubSystemSearchModelData? _subSystemSelected;
  // WOSubSystemSearchModelData? get subSystemSelected => this._subSystemSelected;
  //
  // set subSystemSelected(WOSubSystemSearchModelData? value) {
  //   this._subSystemSelected = value;
  //   notifyListeners();
  // }
  //
  // //step10
  // TextEditingController attach10C = TextEditingController();
  // TextEditingController desc10C = TextEditingController();
  //
  // String? fileAttach10Url;

  FocusNode descNode = FocusNode();
  FocusNode desc6Node = FocusNode();
  FocusNode desc7Node = FocusNode();
  FocusNode desc9Node = FocusNode();
  FocusNode desc10Node = FocusNode();

  DateTime? _dateDoc;

  get date => _dateDoc;

  setDate(DateTime? date) {
    _dateDoc = date;
    dateDocC.text = DateFormat("yyyy-MM-dd", "id_ID")
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

  DateTime? get reqDate => _reqDate;

  setReqDate(DateTime? date) {
    _reqDate = date;
    reqdate6C.text = DateFormat("yyyy-MM-dd HH:mm:ss")
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

  String? _desc8V;

  String? get desc8V => this._desc8V;

  set desc8V(String? value) {
    this._desc8V = value;
    notifyListeners();
  }

  String? _desc8IdV;

  String? get desc8IdV => this._desc8IdV;

  set desc8IdV(String? value) {
    this._desc8IdV = value;
    notifyListeners();
  }

  String isSubAgent = "agen";
  String get getIsSubAgent => this.isSubAgent;
  WOAgreementModel woAgreementModel = WOAgreementModel();

  WOAgreementModel get getWOAgreement => this.woAgreementModel;

  set setWOAgreementModel(WOAgreementModel woAgreementModel) =>
      this.woAgreementModel = woAgreementModel;
  WOAgreementModelData _woAgreementModelData = WOAgreementModelData();
  WOAgreementModelData get woAgreementModelData => this._woAgreementModelData;

  set woAgreementModelData(WOAgreementModelData value) {
    this._woAgreementModelData = value;
    clearAllParam();
    notifyListeners();
    setDataWo1();
    setDataWoActivities();
    setDataWoTools();
    setDataWoLabours();
    setDataWoService();
    setDataWoSparepart();
    setDataWoAttachment();
  }

  // setWoReal(WOAgreementModelData value) async {
  //   this._woAgreementModelData = value;
  //   notifyListeners();
  //   setDataWoActivities();
  //   setDataWoTools();
  // }

  Future<void> fetchWOAgreement({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woAgreementSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/transaction/work-order-agreement/list',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WOAgreementModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          pagingController
              .appendLastPage(newItems as List<WOAgreementModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController.appendPage(
              newItems as List<WOAgreementModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetching = false;
        throw Exception(message);
      }
    }
  }

  List<WOActivitiesParam> listWoActivitiesParam = [];
  List<WOToolsParam> listWoToolsParam = [];
  List<WOLaboursParam> listWoLaboursParam = [];
  List<WOServiceParam> listWoServiceParam = [];
  List<WOSparepartParam> listWoSparepartParam = [];
  List<WOAttachmentParam> listWoAttachmentParam = [];

  clearAllParam() {
    listWoActivitiesParam.clear();
    listWoToolsParam.clear();
    listWoLaboursParam.clear();
    listWoServiceParam.clear();
    listWoSparepartParam.clear();
    listWoAttachmentParam.clear();
    notifyListeners();
  }

  clearWo1() {
    woNumberC.clear();
    workTypeC.clear();
    workTypeShortC.clear();
    workTypeV = null;
    workTypeIdV = null;
    assetC.clear();
    woWorkOrderSearchModelData = WOWorkOrderSearchModelData();
    isDowntime = false;
    workOrderC.clear();
    setDate(null);
    setEstimatedStart(null);
    setEstimatedComplete(null);
    dateDocC.clear();
    estimatedStartC.clear();
    estimatedCompleteC.clear();
    descC.clear();
  }

  clearAllCreateWO() {
    clearAllParam();
    clearWo1();
    clearWoActivities();
    clearWoTools();
    clearWoLabours();
    clearWoService();
    clearWoSparepart();
    clearWoAttachment();
  }

  WOAgreementLogModel _woAgreementLogModel = WOAgreementLogModel();

  WOAgreementLogModel get woAgreementLogModel => this._woAgreementLogModel;

  set woAgreementLogModel(WOAgreementLogModel value) {
    this._woAgreementLogModel = value;
    notifyListeners();
  }

  setDataWo1() {
    final data = woAgreementModelData;
    woNumberC.text = data.docNo ?? "";
    workTypeC.text = data.typeWork?.name ?? "";
    workTypeShortC.text = data.typeWork?.code ?? "";
    workTypeV = data.typeWork?.code;
    // log("WORK TYPE V : $workTypeV");
    assetC.text = data.asset?.name ?? "";
    workOrderC.text = data.workorderName ?? "";
    dateDocC.text = data.dateDoc ?? "";
    isDowntime = data.isDowntime == "1";
    estimatedStartC.text = data.dateStart ?? "";
    estimatedCompleteC.text = data.dateEnd ?? "";
    descC.text = data.description ?? "";
    // listWoActivitiesParam = list;
    notifyListeners();
  }

  WOCompleteModel _woCompleteModel = WOCompleteModel();
  WOCompleteModel get woCompleteModel => this._woCompleteModel;

  set woCompleteModel(WOCompleteModel value) {
    this._woCompleteModel = value;
    notifyListeners();
  }

  Future<void> fetchWOComplete({bool withLoading = false}) async {
    if (withLoading) loading(true);

    final response = await post(Constant.BASE_API_FULL + '/master/craft/get');

    if (response.statusCode == 201 || response.statusCode == 200) {
      woCompleteModel = WOCompleteModel.fromJson(jsonDecode(response.body));
      // notifyListeners();
      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  // setDataWo() {
  //   final data = woAgreementModelData;
  //   woNumberC.text = data.docNo ?? "";
  //   workTypeC.text = data.typeWork?.name ?? "";
  //   assetC.text = data.asset?.name ?? "";
  //   workOrderC.text = data.asset?.name ?? "";
  //   notifyListeners();
  // }

  setDataWoActivities() {
    final data = woAgreementModelData.woActivities;
    List<WOActivitiesParam> list = [];
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      // log("ITEM TASKNAME : ${item?.taskName}");
      list.add(
        WOActivitiesParam(item?.taskName ?? "", item?.taskDuration ?? "",
            item?.description ?? ""),
      );
    }
    listWoActivitiesParam = list;
    notifyListeners();
  }

  setDataWoActivitiesAutoFill() {
    final data = woWorkOrderSearchModelData.woActivities;
    List<WOActivitiesParam> list = [];
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      // log("ITEM TASKNAME : ${item?.taskName}");
      list.add(
        WOActivitiesParam(item?.taskName ?? "", item?.taskDuration ?? "",
            item?.description ?? ""),
      );
    }
    listWoActivitiesParam = list;
    notifyListeners();
  }

  onEditOrAddButtonWoActivities({required BuildContext context, int? index}) {
    if (index != null) {
      // listWoActivitiesParam[index] = WOActivitiesParam(
      //   woAgreementModelData.woActivities?.last?.taskName ?? "0",
      //   woAgreementModelData.woActivities?.last?.taskDuration ?? "0",
      //   woAgreementModelData.woActivities?.last?.description ?? "0",
      // );

      listWoActivitiesParam[index] = WOActivitiesParam(
        taskNameC.text,
        taskDurationC.text,
        descC.text,
      );
    } else {
      listWoActivitiesParam.add(WOActivitiesParam(
        taskNameC.text,
        taskDurationC.text,
        descC.text,
      ));
    }
    clearWoActivities();
    notifyListeners();
    CusNav.nPop(context);
  }

  clearWoActivities() {
    taskNameC.clear();
    taskDurationC.clear();
    notifyListeners();
  }

  createWoActivities(
      {required BuildContext context, required Widget logPopUp}) async {
    taskNameC.clear();
    taskDurationC.clear();
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Activites",
      logPopUp: logPopUp,
    );
    taskNameC.clear();
    taskDurationC.clear();
    notifyListeners();
  }

  onTapWoActivites(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    taskNameC.text = listWoActivitiesParam[index].taskName;
    taskDurationC.text = listWoActivitiesParam[index].taskDuration;

    // taskNameC.text = woAgreementModelData.woActivities?[index]?.taskName ?? "";
    // taskDurationC.text =
    //     woAgreementModelData.woActivities?[index]?.taskDuration ?? "";
    // descC.text = woAgreementModelData.woActivities?[index]?.description ?? "";
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Activities",
      logPopUp: logPopUp,
      dismissable: !isEdit && !isCreate,
    );
    taskNameC.clear();
    taskDurationC.clear();
  }

  setDataWoTools() {
    final data = woAgreementModelData.woTools;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoToolsParam.add(
        WOToolsParam(item?.id ?? "0", item?.companyId ?? "0",
            item?.tool?.name ?? "0", item?.uom ?? "", item?.quantity ?? "0"),
      );
    }
  }

  setDataWoToolsAutoFill() {
    final data = woWorkOrderSearchModelData.woTools;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoToolsParam.add(
        WOToolsParam(item?.id ?? "0", item?.companyId ?? "0",
            item?.tool?.name ?? "0", item?.uom ?? "", item?.quantity ?? "0"),
      );
    }
  }

  onEditOrAddButtonWoTools({required BuildContext context, int? index}) {
    if (index != null) {
      // listWoToolsParam[index] = WOToolsParam(
      //   woAgreementModelData.woTools?[index]?.id ?? "0",
      //   woAgreementModelData.woTools?[index]?.companyId ?? "0",
      //   woAgreementModelData.woTools?[index]?.tool?.name ?? "0",
      //   woAgreementModelData.woTools?[index]?.uom ?? "0",
      //   woAgreementModelData.woTools?[index]?.quantity ?? "0",
      // );
      listWoToolsParam[index] = WOToolsParam(
        toolsSelected?.id ?? "0",
        toolsSelected?.companyId ?? "0",
        toolsC.text,
        uomC.text,
        quantityC.text,
      );
    } else {
      listWoToolsParam.add(
        WOToolsParam(
          toolsSelected?.id ?? "0",
          toolsSelected?.companyId ?? "0",
          toolsC.text,
          uomC.text,
          quantityC.text,
        ),
      );
    }
    clearWoTools();
    CusNav.nPop(context);
    notifyListeners();
  }

  clearWoTools() {
    toolsC.clear();
    uomC.clear();
    quantityC.clear();
    notifyListeners();
  }

  createWoTools(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoTools();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Tools",
      logPopUp: logPopUp,
    );
    clearWoTools();
  }

  onTapWoTools(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    toolsC.text = listWoToolsParam[index].toolsName;
    uomC.text = listWoToolsParam[index].uom;
    quantityC.text = listWoToolsParam[index].qty;
    // toolsC.text = woAgreementModelData.woTools?[index]?.tool?.name ?? "";
    // uomC.text = woAgreementModelData.woTools?[index]?.uom ?? "";
    // quantityC.text = woAgreementModelData.woTools?[index]?.quantity ?? "";
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Tools",
      logPopUp: logPopUp,
      dismissable: !isEdit && !isCreate,
    );
    clearWoTools();
  }

  PagingController<int, WOToolsSearchModelData> _pWoToolsController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOToolsSearchModelData> get pWoToolsController =>
      this._pWoToolsController;

  set pWoToolsController(PagingController<int, WOToolsSearchModelData> value) {
    this._pWoToolsController = value;
  }

  bool _isFetchingWoTools = false;
  bool get isFetchingWoTools => this._isFetchingWoTools;

  set isFetchingWoTools(bool value) {
    this._isFetchingWoTools = value;
  }

  int _pageSizeWoTools = 0;

  get pageSizeWoTools => this._pageSizeWoTools;

  set pageSizeWoTools(pageSize) {
    this._pageSizeWoTools = pageSize;
    notifyListeners();
  }

  TextEditingController _woToolsSearchC = TextEditingController();
  get woToolsSearchC => this._woToolsSearchC;
  set woToolsSearchC(value) => this._woToolsSearchC = value;

  Future<void> fetchWOToolsSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woToolsSearchC.text,
      };

      final response =
          await post(Constant.BASE_API_FULL + '/master/tools/get', body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WOToolsSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoTools = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoTools;

        if (isLastPage) {
          pWoToolsController
              .appendLastPage(newItems as List<WOToolsSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoToolsController.appendPage(
              newItems as List<WOToolsSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoTools = false;
        throw Exception(message);
      }
    }
  }

  WOLaboursCraftModel _woLaboursCraftModel = WOLaboursCraftModel();
  WOLaboursCraftModel get woLaboursCraftModel => this._woLaboursCraftModel;

  set woLaboursCraftModel(WOLaboursCraftModel value) {
    this._woLaboursCraftModel = value;
    notifyListeners();
  }

  Future<void> fetchWOLaboursCraft({bool withLoading = false}) async {
    if (withLoading) loading(true);

    final response = await post(Constant.BASE_API_FULL + '/master/craft/get');

    if (response.statusCode == 201 || response.statusCode == 200) {
      woLaboursCraftModel =
          WOLaboursCraftModel.fromJson(jsonDecode(response.body));
      // notifyListeners();
      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  WOLaboursSkillModel _woLaboursSkillModel = WOLaboursSkillModel();
  WOLaboursSkillModel get woLaboursSkillModel => this._woLaboursSkillModel;

  set woLaboursSkillModel(WOLaboursSkillModel value) {
    this._woLaboursSkillModel = value;
    notifyListeners();
  }

  Future<void> fetchWOLaboursSkill({bool withLoading = false}) async {
    if (withLoading) loading(true);

    final response = await post(Constant.BASE_API_FULL + '/master/skill/get');

    if (response.statusCode == 201 || response.statusCode == 200) {
      woLaboursSkillModel =
          WOLaboursSkillModel.fromJson(jsonDecode(response.body));
      // notifyListeners();
      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  setDataWoLabours() {
    final data = woAgreementModelData.woLabours;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoLaboursParam.add(
        WOLaboursParam(item?.craft?.id ?? "0", item?.skill?.id ?? "0",
            item?.amount ?? "0"),
      );
    }
  }

  setDataWoLaboursAutoFill() {
    final data = woWorkOrderSearchModelData.woLabours;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoLaboursParam.add(
        WOLaboursParam(item?.craft?.id ?? "0", item?.skill?.id ?? "0",
            item?.amount ?? "0"),
      );
    }
  }

  onEditOrAddButtonWoLabours({required BuildContext context, int? index}) {
    if (index != null) {
      // listWoLaboursParam[index] = WOLaboursParam(
      //   woAgreementModelData.woLabours?[index]?.craft?.id ?? "",
      //   woAgreementModelData.woLabours?[index]?.skill?.id ?? "",
      //   woAgreementModelData.woLabours?[index]?.amount ?? "",
      // );

      listWoLaboursParam[index] = WOLaboursParam(
        craftIdV ?? "0",
        skillIdV ?? "0",
        amountC.text,
      );
    } else {
      listWoLaboursParam.add(
        WOLaboursParam(
          craftIdV ?? "0",
          skillIdV ?? "0",
          amountC.text,
        ),
      );
    }
    clearWoLabours();
    CusNav.nPop(context);
  }

  clearWoLabours() {
    craftC.clear();
    craftIdV = null;
    craftV = null;
    skillC.clear();
    skillIdV = null;
    skillV = null;
    amountC.clear();
    notifyListeners();
  }

  createWoLabours(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoLabours();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Labours",
      logPopUp: logPopUp,
    );
    clearWoLabours();
  }

  onTapWoLabours(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    final craft = (woLaboursCraftModel.data ?? [])
            .firstWhere((e) => e?.id == listWoLaboursParam[index].craft)
            ?.name ??
        "";
    final skill = (woLaboursSkillModel.data ?? [])
            .firstWhere((e) => e?.id == listWoLaboursParam[index].skill)
            ?.name ??
        "";
    craftC.text = craft;
    craftV = craft;
    craftIdV = listWoLaboursParam[index].craft;
    skillC.text = skill;
    skillV = skill;
    skillIdV = listWoLaboursParam[index].skill;
    amountC.text = listWoLaboursParam[index].amount;
    amountC.text = listWoLaboursParam[index].amount;
    // craftC.text =
    //     woAgreementModelData.woLabours?[index]?.craft?.name ?? "Select";
    // craftV = woAgreementModelData.woLabours?[index]?.craft?.name;
    // craftIdV = woAgreementModelData.woLabours?[index]?.craft?.id;
    // skillC.text =
    //     woAgreementModelData.woLabours?[index]?.skill?.name ?? "Select";
    // skillV = woAgreementModelData.woLabours?[index]?.skill?.name;
    // skillIdV = woAgreementModelData.woLabours?[index]?.skill?.id;
    // amountC.text = woAgreementModelData.woLabours?[index]?.amount ?? "0";
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Labours",
      logPopUp: logPopUp,
      dismissable: !isEdit && !isCreate,
    );
    clearWoLabours();
  }

  setDataWoService() {
    final data = woAgreementModelData.woServices;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoServiceParam.add(
        WOServiceParam(
          item?.serviceId ?? "0",
          item?.service?.name ?? "",
          item?.service?.uom ?? "",
          item?.qty ?? "",
        ),
      );
    }
  }

  setDataWoServiceAutoFill() {
    final data = woWorkOrderSearchModelData.woServices;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoServiceParam.add(
        WOServiceParam(
          item?.serviceId ?? "0",
          item?.service?.name ?? "",
          item?.service?.uom ?? "",
          item?.qty ?? "",
        ),
      );
    }
  }

  onEditOrAddButtonWoService({required BuildContext context, int? index}) {
    // serviceC.clear();
    // uomC.clear();
    // quantity5C.clear();
    if (index != null) {
      // listWoServiceParam[index] = WOServiceParam(
      //   woAgreementModelData.woServices?[index]?.id ?? "",
      //   woAgreementModelData.woServices?[index]?.service?.uom ?? "",
      //   woAgreementModelData.woServices?[index]?.qty ?? "",
      //   woAgreementModelData.woServices?[index]?.service?.name ?? "",
      // );

      listWoServiceParam[index] = WOServiceParam(
        serviceSelected?.id ?? "0",
        serviceSelected?.name ?? "",
        serviceSelected?.uom ?? "",
        quantity5C.text,
      );
    } else {
      listWoServiceParam.add(
        WOServiceParam(
          serviceSelected?.id ?? "0",
          serviceSelected?.name ?? "",
          serviceSelected?.uom ?? "",
          quantity5C.text,
        ),
      );
    }
    clearWoService();
    notifyListeners();
    CusNav.nPop(context);
  }

  clearWoService() {
    serviceSelected = WOServiceSearchModelData();
    serviceC.clear();
    uom5C.clear();
    quantity5C.clear();
    notifyListeners();
  }

  createWoService(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoService();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Service",
      logPopUp: logPopUp,
    );
    clearWoService();
  }

  onTapWoService(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    serviceC.text = listWoServiceParam[index].serviceName;
    uom5C.text = listWoServiceParam[index].uom;
    quantity5C.text = listWoServiceParam[index].qty;
    // serviceC.text = woAgreementModelData.woServices?[index]?.id ?? "";
    // uom5C.text = woAgreementModelData.woServices?[index]?.service?.uom ?? "";
    // quantity5C.text = woAgreementModelData.woServices?[index]?.qty ?? "";
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Service",
      logPopUp: logPopUp,
      dismissable: !isEdit && !isCreate,
    );
    clearWoService();
  }

  PagingController<int, WOServiceSearchModelData> _pWoServiceController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOServiceSearchModelData> get pWoServiceController =>
      this._pWoServiceController;

  set pWoServiceController(
      PagingController<int, WOServiceSearchModelData> value) {
    this._pWoServiceController = value;
  }

  bool _isFetchingWoService = false;
  bool get isFetchingWoService => this._isFetchingWoService;

  set isFetchingWoService(bool value) {
    this._isFetchingWoService = value;
  }

  int _pageSizeWoService = 0;

  get pageSizeWoService => this._pageSizeWoService;

  set pageSizeWoService(pageSize) {
    this._pageSizeWoService = pageSize;
    notifyListeners();
  }

  TextEditingController _woServiceSearchC = TextEditingController();
  get woServiceSearchC => this._woServiceSearchC;
  set woServiceSearchC(value) => this._woServiceSearchC = value;

  Future<void> fetchWOServiceSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woServiceSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/master/services/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WOServiceSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoService = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoService;

        if (isLastPage) {
          pWoServiceController
              .appendLastPage(newItems as List<WOServiceSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoServiceController.appendPage(
              newItems as List<WOServiceSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoService = false;
        throw Exception(message);
      }
    }
  }

  WOWarehouseSearchModel _woWarehouseSearchModel = WOWarehouseSearchModel();
  WOWarehouseSearchModel get woWarehouseSearchModel =>
      this._woWarehouseSearchModel;

  set woWarehouseSearchModel(WOWarehouseSearchModel value) {
    this._woWarehouseSearchModel = value;
    notifyListeners();
  }

  Future<void> fetchWOWarehouse({bool withLoading = false}) async {
    if (withLoading) loading(true);

    final response = await post(Constant.BASE_API_FULL + '/master/craft/get');

    if (response.statusCode == 201 || response.statusCode == 200) {
      woWarehouseSearchModel =
          WOWarehouseSearchModel.fromJson(jsonDecode(response.body));
      // notifyListeners();
      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  setDataWoSparepart() {
    final data = woAgreementModelData.woSpareparts;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoSparepartParam.add(
        WOSparepartParam(
          item?.companyId ?? "0",
          item?.code ?? "",
          item?.name ?? "",
          item?.quantity ?? "0",
          item?.price ?? "0",
          item?.type ?? "0",
          item?.uom ?? "",
          item?.eta ?? "0",
          item?.description ?? "",
          item?.whName ?? "",
          item?.whCode ?? "",
          item?.unitCode ?? "",
          item?.unitName ?? "",
        ),
      );
    }
  }

  setDataWoSparepartAutoFill() {
    final data = woWorkOrderSearchModelData.woSpareparts;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoSparepartParam.add(
        WOSparepartParam(
          item?.companyId ?? "0",
          item?.code ?? "",
          item?.name ?? "",
          item?.quantity ?? "0",
          item?.price ?? "0",
          item?.type ?? "0",
          item?.uom ?? "",
          item?.eta ?? "0",
          item?.description ?? "",
          item?.whName ?? "",
          item?.whCode ?? "",
          item?.unitCode ?? "",
          item?.unitName ?? "",
        ),
      );
    }
  }

  onEditOrAddButtonWoSparepart({required BuildContext context, int? index}) {
    if (index != null) {
      // listWoSparepartParam[index] = WOSparepartParam(
      //   woAgreementModelData.woSpareparts?[index]?.companyId ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.code ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.name ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.quantity ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.price ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.type ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.uom ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.eta ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.description ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.whName ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.whCode ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.unitCode ?? "",
      //   woAgreementModelData.woSpareparts?[index]?.unitName ?? "",
      // );
      listWoSparepartParam[index] = WOSparepartParam(
        sparepartSelected?.companyId ?? "0",
        codeC.text,
        // sparepartSelected?.code ?? "",
        // sparepartSelected?.name ?? "",
        nameC.text,
        quantity6C.text,
        // woCheckOaModel.data?.qty ?? "0",
        woCheckOaModel.data?.salePrice ?? "0",
        woCheckOaModel.data?.type ?? "0",
        uom6C.text,
        // sparepartSelected?.uom ?? "",
        "${reqDate ?? DateTime.now()}",
        desc6C.text,
        warehouseSelected?.name ?? "",
        warehouseSelected?.code ?? "",
        warehouseSelected?.unitCode ?? "",
        warehouseSelected?.unitName ?? "",
      );
    } else {
      listWoSparepartParam.add(
        WOSparepartParam(
          sparepartSelected?.companyId ?? "0",
          sparepartSelected?.code ?? "",
          sparepartSelected?.name ?? "",
          quantity6C.text,
          // woCheckOaModel.data?.qty ?? "0",
          woCheckOaModel.data?.salePrice ?? "0",
          woCheckOaModel.data?.type ?? "0",
          sparepartSelected?.uom ?? "",
          "${reqDate ?? DateTime.now()}",
          desc6C.text,
          warehouseSelected?.name ?? "",
          warehouseSelected?.code ?? "",
          warehouseSelected?.unitCode ?? "",
          warehouseSelected?.unitName ?? "",
        ),
      );
    }
    clearWoSparepart();
    CusNav.nPop(context);
  }

  clearWoSparepart() {
    codeC.clear();
    sparepartSelected = WOSparepartSearchModelData();
    nameC.clear();
    uom6C.clear();
    warehouseC.clear();
    quantity6C.clear();
    priceC.clear();
    priceV = null;
    typeC.clear();
    typeV = null;
    reqdate6C.clear();
    desc6C.clear();
    notifyListeners();
  }

  createWoSparepart(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoSparepart();
    setReqDate(DateTime.now());
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Sparepart",
      logPopUp: logPopUp,
    );
    clearWoSparepart();
  }

  onTapWoSparepart(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    codeC.text = listWoSparepartParam[index].code;
    nameC.text = listWoSparepartParam[index].name;
    uom6C.text = listWoSparepartParam[index].uom;
    warehouseC.text = listWoSparepartParam[index].whName;
    quantity6C.text = listWoSparepartParam[index].qty;
    priceC.text =
        Utils.thousandSeparator(int.parse(listWoSparepartParam[index].price));
    typeC.text = listWoSparepartParam[index].type;
    reqdate6C.text = listWoSparepartParam[index].eta;
    desc6C.text = listWoSparepartParam[index].description;

    // codeC.text = woAgreementModelData.woSpareparts?[index]?.code ?? "";
    // nameC.text = woAgreementModelData.woSpareparts?[index]?.name ?? "";
    // uom6C.text = woAgreementModelData.woSpareparts?[index]?.uom ?? "";
    // warehouseC.text = woAgreementModelData.woSpareparts?[index]?.whName ?? "";
    // quantity6C.text =
    //     woAgreementModelData.woSpareparts?[index]?.quantity ?? "0";
    // priceC.text = woAgreementModelData.woSpareparts?[index]?.price ?? "0";
    // priceV = woAgreementModelData.woSpareparts?[index]?.price ?? "0";
    // typeC.text = woAgreementModelData.woSpareparts?[index]?.type ?? "0";
    // typeV = woAgreementModelData.woSpareparts?[index]?.type ?? "0";
    // // log("PRICE ${priceC.text}");
    // // log("TYPE ${typeC.text}");
    // etaC.text = woAgreementModelData.woSpareparts?[index]?.eta ?? "0";
    // desc6C.text = woAgreementModelData.woSpareparts?[index]?.description ?? "0";
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Sparepart",
      logPopUp: logPopUp,
      dismissable: !isEdit && !isCreate,
    );
    clearWoSparepart();
  }

  PagingController<int, WOSparepartSearchModelData> _pWoSparepartController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOSparepartSearchModelData>
      get pWoSparepartController => this._pWoSparepartController;

  set pWoSparepartController(
      PagingController<int, WOSparepartSearchModelData> value) {
    this._pWoSparepartController = value;
  }

  bool _isFetchingWoSparepart = false;
  bool get isFetchingWoSparepart => this._isFetchingWoSparepart;

  set isFetchingWoSparepart(bool value) {
    this._isFetchingWoSparepart = value;
  }

  int _pageSizeWoSparepart = 0;

  get pageSizeWoSparepart => this._pageSizeWoSparepart;

  set pageSizeWoSparepart(pageSize) {
    this._pageSizeWoSparepart = pageSize;
    notifyListeners();
  }

  TextEditingController _woSparepartSearchC = TextEditingController();
  get woSparepartSearchC => this._woSparepartSearchC;
  set woSparepartSearchC(value) => this._woSparepartSearchC = value;

  Future<void> fetchWOSparepartSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woSparepartSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/master/sparepart/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            WOSparepartSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoSparepart = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoSparepart;

        if (isLastPage) {
          pWoSparepartController
              .appendLastPage(newItems as List<WOSparepartSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoSparepartController.appendPage(
              newItems as List<WOSparepartSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoSparepart = false;
        throw Exception(message);
      }
    }
  }

  PagingController<int, WOWarehouseSearchModelData> _pWoWarehouseController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOWarehouseSearchModelData>
      get pWoWarehouseController => this._pWoWarehouseController;

  set pWoWarehouseController(
      PagingController<int, WOWarehouseSearchModelData> value) {
    this._pWoWarehouseController = value;
  }

  bool _isFetchingWoWarehouse = false;
  bool get isFetchingWoWarehouse => this._isFetchingWoWarehouse;

  set isFetchingWoWarehouse(bool value) {
    this._isFetchingWoWarehouse = value;
  }

  int _pageSizeWoWarehouse = 0;

  get pageSizeWoWarehouse => this._pageSizeWoWarehouse;

  set pageSizeWoWarehouse(pageSize) {
    this._pageSizeWoWarehouse = pageSize;
    notifyListeners();
  }

  TextEditingController _woWarehouseSearchC = TextEditingController();
  get woWarehouseSearchC => this._woWarehouseSearchC;
  set woWarehouseSearchC(value) => this._woWarehouseSearchC = value;

  Future<void> fetchWOWarehouseSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woWarehouseSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/master/warehouse/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            WOWarehouseSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoWarehouse = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoWarehouse;

        if (isLastPage) {
          pWoWarehouseController
              .appendLastPage(newItems as List<WOWarehouseSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoWarehouseController.appendPage(
              newItems as List<WOWarehouseSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoWarehouse = false;
        throw Exception(message);
      }
    }
  }

  setDataAfterWoCompleteSelected() async {
    final data = woWorkOrderSearchModelData;
    final woActivities = data.woActivities;
    final woTools = data.woTools;
    final woLabours = data.woLabours;
    final woServices = data.woServices;
    final woSpareparts = data.woSpareparts;
    workOrderC.text = data.docNo ?? "";
    clearAllParam();
    // Activities
    setDataWoActivitiesAutoFill();
    setDataWoToolsAutoFill();
    setDataWoLaboursAutoFill();
    setDataWoServiceAutoFill();
    setDataWoSparepartAutoFill();
    // taskNameC.text = woActivities.
  }

  PagingController<int, WOWorkOrderSearchModelData> _pWoCompleteController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOWorkOrderSearchModelData> get pWoCompleteController =>
      this._pWoCompleteController;

  set pWoCompleteController(
      PagingController<int, WOWorkOrderSearchModelData> value) {
    this._pWoCompleteController = value;
  }

  bool _isFetchingWoComplete = false;
  bool get isFetchingWoComplete => this._isFetchingWoComplete;

  set isFetchingWoComplete(bool value) {
    this._isFetchingWoComplete = value;
  }

  int _pageSizeWoComplete = 0;

  get pageSizeWoComplete => this._pageSizeWoComplete;

  set pageSizeWoComplete(pageSize) {
    this._pageSizeWoComplete = pageSize;
    notifyListeners();
  }

  TextEditingController _woCompleteSearchC = TextEditingController();
  get woCompleteSearchC => this._woCompleteSearchC;
  set woCompleteSearchC(value) => this._woCompleteSearchC = value;

  Future<void> fetchWOCompleteSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woCompleteSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL +
              '/transaction/work-order-agreement/get-wo-complate',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            WOWorkOrderSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoComplete = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoComplete;

        if (isLastPage) {
          pWoCompleteController
              .appendLastPage(newItems as List<WOWorkOrderSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoCompleteController.appendPage(
              newItems as List<WOWorkOrderSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoComplete = false;
        throw Exception(message);
      }
    }
  }

  PagingController<int, WOAssetSearchModelData> _pWoAssetController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOAssetSearchModelData> get pWoAssetController =>
      this._pWoAssetController;

  set pWoAssetController(PagingController<int, WOAssetSearchModelData> value) {
    this._pWoAssetController = value;
  }

  bool _isFetchingWoAsset = false;
  bool get isFetchingWoAsset => this._isFetchingWoAsset;

  set isFetchingWoAsset(bool value) {
    this._isFetchingWoAsset = value;
  }

  int _pageSizeWoAsset = 0;

  get pageSizeWoAsset => this._pageSizeWoAsset;

  set pageSizeWoAsset(pageSize) {
    this._pageSizeWoAsset = pageSize;
    notifyListeners();
  }

  TextEditingController woAssetSearchC = TextEditingController();

  Future<void> fetchWOAssetSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woAssetSearchC.text,
      };

      final response =
          await post(Constant.BASE_API_FULL + '/master/asset/get', body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WOAssetSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoAsset = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoAsset;

        if (isLastPage) {
          pWoAssetController
              .appendLastPage(newItems as List<WOAssetSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoAssetController.appendPage(
              newItems as List<WOAssetSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoAsset = false;
        throw Exception(message);
      }
    }
  }

  setDataWoAttachment() {
    final data = woAgreementModelData.woFiles;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoAttachmentParam.add(
        WOAttachmentParam(
            "https://" + Constant.DOMAIN + "/" + (item?.file ?? ""),
            item?.fileName ?? "",
            item?.keterangan ?? ""),
      );
    }
  }

  onEditOrAddButtonWoAttachment({required BuildContext context, int? index}) {
    if (index != null) {
      // listWoAttachmentParam[index] = WOAttachmentParam(
      //   "https://" +
      //       Constant.DOMAIN +
      //       "/" +
      //       (woAgreementModelData.woFiles?[index]?.file ?? ""),
      //   woAgreementModelData.woFiles?[index]?.fileName ?? "",
      //   woAgreementModelData.woFiles?[index]?.keterangan ?? "",
      // );
      listWoAttachmentParam[index] = WOAttachmentParam(
          "https://" + Constant.DOMAIN + "/" + (fileAttach7Url ?? ""),
          attachC.text,
          desc7C.text);
    } else {
      listWoAttachmentParam.add(WOAttachmentParam(
          "https://" + Constant.DOMAIN + "/" + (fileAttach7Url ?? ""),
          attachC.text,
          desc7C.text));
    }
    clearWoAttachment();
    CusNav.nPop(context);
  }

  clearWoAttachment() {
    fileAttach7Url = null;
    attachC.clear();
    desc7C.clear();
    notifyListeners();
  }

  createWoAttachment(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoAttachment();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Attachment",
      logPopUp: logPopUp,
    );
    clearWoAttachment();
  }

  onTapWoAttachment(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    fileAttach7Url = listWoAttachmentParam[index].fileURL;
    attachC.text = listWoAttachmentParam[index].fileName;
    desc7C.text = listWoAttachmentParam[index].description;

    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Preview Attachment",
      logPopUp: logPopUp,
      dismissable: !isEdit && !isCreate,
    );
    clearWoAttachment();
  }

  Future<File?> editOrPreview(
      {required BuildContext context,
      required VoidCallback onEdit,
      required VoidCallback onPreview}) async {
    File? f;
    await CustomContainer.showModalBottom(
      initialChildSize: 0.3,
      context: context,
      child: Column(
        children: [
          Text(
            "Pilihan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          CustomButton.mainButton("${isEdit ? "Edit" : "View"}", onEdit),
          SizedBox(height: 8),
          CustomButton.mainButton("Preview", onPreview),
          SizedBox(height: 24),
        ],
      ),
    );
    return f;
  }

  WOCheckOAModel _woCheckOaModel = WOCheckOAModel();
  WOCheckOAModel get woCheckOaModel => this._woCheckOaModel;

  set woCheckOaModel(WOCheckOAModel value) {
    this._woCheckOaModel = value;
    notifyListeners();
  }

  String? priceV;
  String? get getPriceV => this.priceV;

  set setPriceV(String? priceV) {
    this.priceV = priceV;
    notifyListeners();
  }

  String? qtyV;
  String? get getQtyV => this.qtyV;

  set setQtyV(String? qtyV) {
    this.qtyV = qtyV;
    notifyListeners();
  }

  String? typeV;
  String? get getTypeV => this.typeV;

  set setTypeV(String? typeV) {
    this.typeV = typeV;
    notifyListeners();
  }

  WOCheckOAModel _woCheckOASelected = WOCheckOAModel();
  WOCheckOAModel get woCheckOASelected => this._woCheckOASelected;

  set woCheckOASelected(WOCheckOAModel value) {
    this._woCheckOASelected = value;
    notifyListeners();
  }

  Future<void> fetchWOCheckOA({bool withLoading = false}) async {
    if (withLoading) loading(true);

    Map<String, String> param = {
      'sparepart_code': sparepartSelected?.code ?? "",
      'warehouse_code': warehouseSelected?.code ?? "",
    };
    final response = await post(
        Constant.BASE_API_FULL + '/master/warehouse/check-oa',
        body: param);

    if (response.statusCode == 201 || response.statusCode == 200) {
      woCheckOaModel = WOCheckOAModel.fromJson(jsonDecode(response.body));
      // notifyListeners();
      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future<void> fetchWOAgreementLog(String id,
      {bool withLoading = false}) async {
    if (withLoading) loading(true);
    Map<String, String> param = {'id': '$id'};
    final response = await post(
        Constant.BASE_API_FULL + '/transaction/work-order-agreement/listLog',
        body: param);

    if (response.statusCode == 200) {
      final model = WOAgreementLogModel.fromJson(jsonDecode(response.body));
      woAgreementLogModel = model;
      notifyListeners();

      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  WOAgreementApproveModel _woAgreementApproveModel = WOAgreementApproveModel();

  WOAgreementApproveModel get woAgreementApproveModel =>
      this._woAgreementApproveModel;

  set woAgreementApproveModel(WOAgreementApproveModel value) {
    this._woAgreementApproveModel = value;
    notifyListeners();
  }

  Future<void> fetchWOAgreementApprove(String id,
      {bool withLoading = false}) async {
    if (withLoading) loading(true);
    Map<String, String> param = {'id': '$id'};
    final response = await post(
        Constant.BASE_API_FULL +
            '/transaction/work-order-agreement/listApprove',
        body: param);

    if (response.statusCode == 200) {
      final model = WOAgreementApproveModel.fromJson(jsonDecode(response.body));
      woAgreementApproveModel = model;
      notifyListeners();

      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  File? _imageAttachment1;
  File? get imageAttachment1 => _imageAttachment1;

  set imageAttachment1(File? imageAttachment1) {
    _imageAttachment1 = imageAttachment1;
    notifyListeners();
  }

  File? _imageAttachment2;
  File? get imageAttachment2 => _imageAttachment2;

  set imageAttachment2(File? imageAttachment2) {
    _imageAttachment2 = imageAttachment2;
    notifyListeners();
  }

  Future<void> sendWOAgreement({bool isEdit = false}) async {
    loading(true);
    // if (createWoAgreementtKey.currentState!.validate()) {
    String encodedId = Encrypt().encode64(woAgreementModelData.id ?? "0");
    String dateSelected =
        DateFormat("yyyy-MM-dd", "id_ID").format(date ?? DateTime.now());

    List<http.MultipartFile> files = [];
    Map<String, String> param = {
      'id': encodedId,
      // Step 1 Work Order
      'doc_no': "",
      // isCreate ? woNumberC.text : woAgreementModelData.asset?.code ?? "",
      'type_work': workTypeShortC.text,
      'date_doc': dateSelected,
      'workorder_name': workOrderC.text,
      // missing asset & workOrder
      'start_downtime': estimatedStartC.text,
      'up_date': estimatedCompleteC.text,
      'description': descC.text,
      'is_downtime': isDowntime ? "1" : "0",
    };
    // if there is step 2 activites
    for (int i = 0; i < listWoActivitiesParam.length; i++) {
      final item = listWoActivitiesParam[i];
      param.addAll({
        'WorkorderActivities[$i][task_name]': item.taskName,
        'WorkorderActivities[$i][task_duration]': item.taskDuration,
        'WorkorderActivities[$i][description]': item.description,
      });
    }
    // if there is step 3 tools
    for (int i = 0; i < listWoToolsParam.length; i++) {
      final item = listWoToolsParam[i];
      param.addAll({
        'WorkorderTools[$i][tools_id]': item.toolsId,
        'WorkorderTools[$i][company_id]': item.companyId,
        'WorkorderTools[$i][tools_name]': item.toolsName,
        'WorkorderTools[$i][uom]': item.uom,
        'WorkorderTools[$i][qty]': item.qty,
      });
    }
    // if there is step 4 labours
    for (int i = 0; i < listWoLaboursParam.length; i++) {
      final item = listWoLaboursParam[i];
      param.addAll({
        'WorkorderLabours[$i][craft]': item.craft,
        'WorkorderLabours[$i][skill]': item.skill,
        'WorkorderLabours[$i][amount]': item.amount,
      });
    }
    // if there is step 5 service
    for (int i = 0; i < listWoServiceParam.length; i++) {
      final item = listWoServiceParam[i];
      param.addAll({
        'WorkorderService[$i][service_id]': item.serviceId,
        'WorkorderService[$i][uom]': item.uom,
        'WorkorderService[$i][qty]': item.qty,
      });
    }
    // if there is step 6 sparepart
    for (int i = 0; i < listWoSparepartParam.length; i++) {
      final item = listWoSparepartParam[i];
      param.addAll({
        'WorkorderSparepart[$i][company_id]': item.companyId,
        'WorkorderSparepart[$i][code]': item.code,
        'WorkorderSparepart[$i][name]': item.name,
        'WorkorderSparepart[$i][qty]': item.qty,
        'WorkorderSparepart[$i][uom]': item.uom,
        'WorkorderSparepart[$i][eta]': item.eta,
        'WorkorderSparepart[$i][description]': item.description,
        'WorkorderSparepart[$i][price]': item.price
            .trim()
            .replaceAll("Rp", "")
            .replaceAll(".", "")
            .replaceAll(",", ""),
        'WorkorderSparepart[$i][type]': item.type,
        'WorkorderSparepart[$i][wh_name]': item.whName,
        'WorkorderSparepart[$i][wh_code]': item.whCode,
        'WorkorderSparepart[$i][unit_code]': item.unitCode,
        'WorkorderSparepart[$i][unit_name]': item.unitName,
      });
    }
    // if there is step 7/10 attachment
    for (int i = 0; i < listWoAttachmentParam.length; i++) {
      final item = listWoAttachmentParam[i];
      if (imageAttachment1 != null) {
        files.add(await getMultipart(
            'WorkorderAttachment[$i][image]', File(imageAttachment1!.path)));
      } else {
        // throw 'Harap Isi Pas Foto';
      }
      param.addAll({
        // 'WorkorderSparepart[$i][image]': "1", multipart
        'WorkorderAttachment[$i][description]': item.description,
      });
    }

    final response = BaseResponse.from(await post(
      Constant.BASE_API_FULL +
          '/transaction/work-order-agreement/${isEdit ? 'edit' : 'create'}',
      body: param,
      files: files.isEmpty ? null : files,
    ));

    if (response.success) {
      loading(false);
    } else {
      loading(false);
      throw Exception(response.message);
    }
    // } else {
    //   loading(false);
    //   throw 'Harap Lengkapi Form';
    // }
  }

  Future<void> sendWOAgreementCreate({bool isEdit = false}) async {
    loading(true);
    // if (createWoAgreementtKey.currentState!.validate()) {
    String encodedId =
        Encrypt().encode64(woAgreementModelData.asset?.id ?? "0");
    String dateSelected =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(date ?? DateTime.now());

    List<http.MultipartFile> files = [];
    Map<String, String> param = {
      'id': encodedId,
      // Step 1 Work Order
      'doc_no':
          isCreate ? woNumberC.text : woAgreementModelData.asset?.code ?? "",
      'type_work': workTypeShortC.text,
      'date_doc': dateSelected,
      // missing asset & workOrder
      'workorder_name': workOrderC.text,
      'date_start': estimatedStartC.text,
      'date_end': estimatedCompleteC.text,
      'asset_code': assetC.text,
      'asset_category_code': woAssetSearchModelData.jenisAssetCode ?? "",
      'company_id': woAssetSearchModelData.companyId ?? "0",
      'description': descC.text,
      'is_downtime': isDowntime ? "1" : "0",
    };
    // if there is step 2 activites
    for (int i = 0; i < listWoActivitiesParam.length; i++) {
      final item = listWoActivitiesParam[i];
      param.addAll({
        'WorkorderActivities[$i][task_name]': item.taskName,
        'WorkorderActivities[$i][task_duration]': item.taskDuration,
        'WorkorderActivities[$i][description]': item.description,
      });
    }
    // if there is step 3 tools
    for (int i = 0; i < listWoToolsParam.length; i++) {
      final item = listWoToolsParam[i];
      param.addAll({
        'WorkorderTools[$i][tools_id]': item.toolsId,
        'WorkorderTools[$i][company_id]': item.companyId,
        'WorkorderTools[$i][tools_name]': item.toolsName,
        'WorkorderTools[$i][uom]': item.uom,
        'WorkorderTools[$i][qty]': item.qty,
      });
    }
    // if there is step 4 labours
    for (int i = 0; i < listWoLaboursParam.length; i++) {
      final item = listWoLaboursParam[i];
      param.addAll({
        'WorkorderLabours[$i][craft]': item.craft,
        'WorkorderLabours[$i][skill]': item.skill,
        'WorkorderLabours[$i][amount]': item.amount,
      });
    }
    // if there is step 5 service
    for (int i = 0; i < listWoServiceParam.length; i++) {
      final item = listWoServiceParam[i];
      param.addAll({
        'WorkorderService[$i][service_id]': item.serviceId,
        'WorkorderService[$i][uom]': item.uom,
        'WorkorderService[$i][qty]': item.qty,
      });
    }
    // if there is step 6 sparepart
    for (int i = 0; i < listWoSparepartParam.length; i++) {
      final item = listWoSparepartParam[i];
      param.addAll({
        'WorkorderSparepart[$i][company_id]': item.companyId,
        'WorkorderSparepart[$i][code]': item.code,
        'WorkorderSparepart[$i][name]': item.name,
        'WorkorderSparepart[$i][qty]': item.qty,
        'WorkorderSparepart[$i][uom]': item.uom,
        'WorkorderSparepart[$i][eta]': item.eta,
        'WorkorderSparepart[$i][description]': item.description,
        'WorkorderSparepart[$i][price]': item.price,
        'WorkorderSparepart[$i][type]': item.type,
        'WorkorderSparepart[$i][wh_name]': item.whName,
        'WorkorderSparepart[$i][wh_code]': item.whCode,
        'WorkorderSparepart[$i][unit_code]': item.unitCode,
        'WorkorderSparepart[$i][unit_name]': item.unitName,
      });
    }
    // if there is step 7/10 attachment
    for (int i = 0; i < listWoAttachmentParam.length; i++) {
      final item = listWoAttachmentParam[i];
      if (imageAttachment1 != null) {
        files.add(await getMultipart(
            'WorkorderAttachment[$i][image]', File(imageAttachment1!.path)));
      } else {
        // throw 'Harap Isi Pas Foto';
      }
      param.addAll({
        // 'WorkorderSparepart[$i][image]': "1", multipart
        'WorkorderAttachment[$i][description]': item.description,
      });
    }

    final response = BaseResponse.from(await post(
      Constant.BASE_API_FULL +
          '/transaction/work-order-agreement/${isEdit ? 'edit' : 'create'}',
      body: param,
      files: files.isEmpty ? null : files,
    ));

    if (response.success) {
      loading(false);
    } else {
      loading(false);
      throw Exception(response.message);
    }
    // } else {
    //   loading(false);
    //   throw 'Harap Lengkapi Form';
    // }
  }

  Future<void> action({required String type, String note = ""}) async {
    loading(true);
    String encodedId = Encrypt().encode64(woAgreementModelData.id ?? "0");
    Map<String, String> param = {'id': encodedId};
    if (type == "approve" || type == "void" || type == "reject") {
      // if (note == "") throw 'Harap Lengkapi Keterangan';
      param.addAll({'note': note});
    }
    final response = BaseResponse.from(await post(
        Constant.BASE_API_FULL + '/transaction/work-order-agreement/$type',
        body: param));

    if (response.success) {
      loading(false);
    } else {
      loading(false);
      throw Exception(response.message);
    }
  }

  Widget cancelSaveButton(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 90,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 5,
              child: CustomButton.secondaryButton("Cancel", () async {
                await Utils.showYesNoDialog(
                    context: context,
                    title: "Konfirmasi",
                    desc: "Apakah Anda Yakin Ingin Membatalkan?",
                    yesCallback: () async {
                      CusNav.nPop(context);
                      try {
                        isEdit = false;
                        // CusNav.nPop(context);
                      } catch (e) {
                        Utils.showFailed(
                            msg: e.toString().toLowerCase().contains("doctype")
                                ? "Maaf, Terjadi Galat!"
                                : "$e");
                      }
                    },
                    noCallback: () => CusNav.nPop(context));
              })),
          Constant.xSizedBox16,
          Expanded(
            flex: 5,
            child: CustomButton.mainButton("Save", () async {
              await Utils.showYesNoDialog(
                  context: context,
                  title: "Konfirmasi",
                  desc: "Apakah Anda Yakin Ingin Menyimpan?",
                  yesCallback: () async {
                    CusNav.nPop(context);
                    try {
                      if (isCreate) {
                        await sendWOAgreementCreate(isEdit: false)
                            .then((value) async {
                          await Utils.showSuccess(msg: "Save Success");
                          Future.delayed(Duration(seconds: 2),
                              () => Navigator.pop(context, true));
                          isCreate = false;
                          isEdit = false;
                        });
                      } else {
                        await sendWOAgreement(isEdit: true).then((value) async {
                          await Utils.showSuccess(msg: "Save Success");
                          Future.delayed(Duration(seconds: 2),
                              () => Navigator.pop(context, true));
                        });
                      }
                    } catch (e) {
                      Utils.showFailed(
                          msg: e.toString().toLowerCase().contains("doctype")
                              ? "Maaf, Terjadi Galat!"
                              : "$e");
                    }
                  },
                  noCallback: () => CusNav.nPop(context));
            }),
          )
        ],
      ),
    );
  }
}
