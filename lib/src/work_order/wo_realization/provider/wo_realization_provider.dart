import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hy_tutorial/common/base/base_controller.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/model/wo_dropdown.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/model/wo_realization_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import '../model/wo_realization_approve_model.dart';
import '../model/wo_realization_log_model.dart';
import '../model/wo_search.dart';

class WORealizationProvider extends BaseController with ChangeNotifier {
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

  GlobalKey<FormState> createWoRealizationtKey = GlobalKey<FormState>();
  PagingController<int, WORealizationModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, WORealizationModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, WORealizationModelData> value) {
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

  TextEditingController woRealizationSearchC = TextEditingController();
  TextEditingController woRealizationPersonilSearchC = TextEditingController();
  TextEditingController woRealizationToolsSearchC = TextEditingController();
  TextEditingController woRealizationServiceSearchC = TextEditingController();
  TextEditingController woRealizationSparepartSearchC = TextEditingController();
  TextEditingController woRealizationWarehouseSearchC = TextEditingController();
  TextEditingController woRealizationProgressSearchC = TextEditingController();
  TextEditingController woRealizationSystemSearchC = TextEditingController();
  TextEditingController woRealizationSubSystemSearchC = TextEditingController();

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

  WOWorkOrderSearchModelData? _woWorkOrderSearchModelData =
      WOWorkOrderSearchModelData();
  WOWorkOrderSearchModelData? get woWorkOrderSearchModelData =>
      this._woWorkOrderSearchModelData;

  set woWorkOrderSearchModelData(WOWorkOrderSearchModelData? value) {
    this._woWorkOrderSearchModelData = value;
    notifyListeners();
  }

  //step 2
  TextEditingController taskNameC = TextEditingController();
  TextEditingController taskDurationC = TextEditingController();
  TextEditingController desc2C = TextEditingController();

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
  TextEditingController personilC = TextEditingController();

  WOPersonilSearchModelData? _personilSelected;
  WOPersonilSearchModelData? get personilSelected => this._personilSelected;

  set personilSelected(WOPersonilSearchModelData? value) {
    this._personilSelected = value;
    notifyListeners();
  }

  List<WOPersonilSearchModelData> _listPersonil = [];
  List<WOPersonilSearchModelData> get listPersonil => this._listPersonil;

  set listPersonil(List<WOPersonilSearchModelData> value) {
    this._listPersonil = value;
    notifyListeners();
  }

  List<WOPersonilSearchModelData> _listPersonilSelected = [];
  List<WOPersonilSearchModelData> get listPersonilSelected =>
      this._listPersonilSelected;

  set listPersonilSelected(List<WOPersonilSearchModelData> value) {
    this._listPersonilSelected = value;
    notifyListeners();
  }

  List<String> _listPersonilSelectedNip = [];
  List<String> get listPersonilSelectedNip => this._listPersonilSelectedNip;

  set listPersonilSelectedNip(List<String> value) {
    this._listPersonilSelectedNip = value;
    notifyListeners();
  }

  List<bool> _boolListPersonil = [];
  List<bool> get boolListPersonil => this._boolListPersonil;

  set boolListPersonil(List<bool> value) {
    this._boolListPersonil = value;
    notifyListeners();
  }

  bool _allPersonilSelected = false;
  bool get allPersonilSelected => this._allPersonilSelected;

  set allPersonilSelected(bool value) {
    this._allPersonilSelected = value;
    for (int i = 0; i < boolListPersonil.length; i++) {
      boolListPersonil[i] = value;
    }
    notifyListeners();
  }

  clearListPersonil() {
    listPersonilSelected.clear();
    listPersonilSelectedNip.clear();
    boolListPersonil.clear();
  }

  addListPersonil() {
    for (int i = 0; i < boolListPersonil.length; i++) {
      final item = boolListPersonil[i];
      if (item) {
        if (listPersonilSelected.contains(listPersonil[i])) {
          listPersonilSelected[i] = listPersonil[i];
          listPersonilSelectedNip[i] = listPersonil[i].nip ?? "";
        } else {
          listPersonilSelected.add(listPersonil[i]);
          listPersonilSelectedNip.add(listPersonil[i].nip ?? "");
        }
      } else {
        if (listPersonilSelected.contains(listPersonil[i])) {
          listPersonilSelected.remove(listPersonil[i]);
          listPersonilSelectedNip.remove(listPersonil[i].nip ?? "");
        }
      }
    }
    log("LIST PERSONIL SELECTED : $listPersonilSelectedNip");
    notifyListeners();
  }

  removeListPersonil(int index) {
    listPersonilSelected.removeAt(index);
    notifyListeners();
  }

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
  TextEditingController etaC = TextEditingController();
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

  //step 8
  String? fileAttach8Url;
  TextEditingController desc8C = TextEditingController();
  TextEditingController date8C = TextEditingController();
  TextEditingController justifyC = TextEditingController();
  TextEditingController attach8C = TextEditingController();
  WOProgressSearchModelData? _progressSelected;
  WOProgressSearchModelData? get progressSelected => this._progressSelected;

  set progressSelected(WOProgressSearchModelData? value) {
    this._progressSelected = value;
    notifyListeners();
  }

  //step9
  TextEditingController system9C = TextEditingController();
  TextEditingController subsystem9C = TextEditingController();
  TextEditingController desc9C = TextEditingController();

  WOSystemSearchModelData? _systemSelected;
  WOSystemSearchModelData? get systemSelected => this._systemSelected;

  set systemSelected(WOSystemSearchModelData? value) {
    this._systemSelected = value;
    notifyListeners();
  }

  WOSubSystemSearchModelData? _subSystemSelected;
  WOSubSystemSearchModelData? get subSystemSelected => this._subSystemSelected;

  set subSystemSelected(WOSubSystemSearchModelData? value) {
    this._subSystemSelected = value;
    notifyListeners();
  }

  //step10
  TextEditingController attach10C = TextEditingController();
  TextEditingController desc10C = TextEditingController();

  String? fileAttach10Url;

  FocusNode descNode = FocusNode();
  FocusNode desc2Node = FocusNode();
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

  // get reqDate => _reqDate;
  DateTime? get reqDate => _reqDate;

  setReqDate(DateTime? date) {
    _reqDate = date;
    etaC.text = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  DateTime? _date8;

  get date8 => _date8;

  set reqDate8(DateTime? date) {
    _date8 = date;
    date8C.text = DateFormat("yyyy-MM-dd HH:mm:ss")
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
  WORealizationModel woRealizationModel = WORealizationModel();

  WORealizationModel get getWORealization => this.woRealizationModel;

  set setWORealizationModel(WORealizationModel woRealizationModel) =>
      this.woRealizationModel = woRealizationModel;
  WORealizationModelData _woRealizationModelData = WORealizationModelData();
  WORealizationModelData get woRealizationModelData =>
      this._woRealizationModelData;

  set woRealizationModelData(WORealizationModelData value) {
    this._woRealizationModelData = value;
    clearAllParam();
    notifyListeners();
    setDataWo1();
    setDataWoActivities();
    setDataWoTools();
    setDataWoLabours();
    setDataWoService();
    setDataWoSparepart();
    setDataWoAttachment();
    setDataWoProgress();
    setDataWoFailureCode();
    setDataWoAttachment2();
  }

  // setWoReal(WORealizationModelData value) async {
  //   this._woRealizationModelData = value;
  //   notifyListeners();
  //   setDataWoActivities();
  //   setDataWoTools();
  // }

  Future<void> fetchWORealization({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woRealizationSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/transaction/work-order-realization/list',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WORealizationModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          pagingController
              .appendLastPage(newItems as List<WORealizationModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController.appendPage(
              newItems as List<WORealizationModelData>, nextPageKey);
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
  List<WOProgressParam> listWoProgressParam = [];
  List<WOFailureCodeParam> listWoFailureCodeParam = [];
  List<WOAttachmentRealizationParam> listWoAttachmentRealizationParam = [];

  setIndexWOLaboursParam(int index, WOLaboursParam data) {
    listWoLaboursParam[index] = data;
    notifyListeners();
  }

  clearAllParam() {
    listWoActivitiesParam.clear();
    listWoToolsParam.clear();
    listWoLaboursParam.clear();
    listWoServiceParam.clear();
    listWoSparepartParam.clear();
    listWoAttachmentParam.clear();
    listWoProgressParam.clear();
    listWoFailureCodeParam.clear();
    listWoAttachmentRealizationParam.clear();
    notifyListeners();
  }

  WORealizationLogModel _woRealizationLogModel = WORealizationLogModel();

  WORealizationLogModel get woRealizationLogModel =>
      this._woRealizationLogModel;

  set woRealizationLogModel(WORealizationLogModel value) {
    this._woRealizationLogModel = value;
    notifyListeners();
  }

  setDataWo1() {
    final data = woRealizationModelData;
    woNumberC.text = data.docNo ?? "";
    workTypeC.text = data.typeWork?.name ?? "";
    workTypeShortC.text = data.typeWork?.code ?? "";
    workTypeV = data.typeWork?.code;
    // log("WORK TYPE V : $workTypeV");
    assetC.text = data.asset?.name ?? "";
    workOrderC.text = data.workorderId ?? "";
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

  setDataWoActivities() {
    final data = woRealizationModelData.woActivities;
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
    desc2C.clear();
  }

  createWoActivities(
      {required BuildContext context, required Widget logPopUp}) async {
    taskNameC.clear();
    taskDurationC.clear();
    desc2C.clear();
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Activites",
      logPopUp: logPopUp,
    );
    taskNameC.clear();
    taskDurationC.clear();
    desc2C.clear();
    notifyListeners();
  }

  onTapWoActivites(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    taskNameC.text = listWoActivitiesParam[index].taskName;
    taskDurationC.text = listWoActivitiesParam[index].taskDuration;
    desc2C.text = listWoActivitiesParam[index].description;
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Edit Activities",
      logPopUp: logPopUp,
      dismissable: !isEdit,
    );
    taskNameC.clear();
    taskDurationC.clear();
    desc2C.clear();
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

  setDataWoTools() {
    final data = woRealizationModelData.woTools;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoToolsParam.add(
        WOToolsParam(item?.tool?.id ?? "0", item?.companyId ?? "0",
            item?.tool?.name ?? "0", item?.uom ?? "", item?.quantity ?? "0"),
      );
    }
  }

  onEditOrAddButtonWoTools({required BuildContext context, int? index}) {
    if (index != null) {
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
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Tools",
      logPopUp: logPopUp,
      dismissable: !isEdit,
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
        'search': woRealizationToolsSearchC.text,
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
    final data = woRealizationModelData.woLabours;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoLaboursParam.add(
        WOLaboursParam(item?.craft?.id ?? "0", item?.skill?.id ?? "0",
            item?.amount ?? "0", item?.personil ?? []),
      );
    }
  }

  onEditOrAddButtonWoLabours({required BuildContext context, int? index}) {
    var stringg = listPersonilSelectedNip.join(',');
    if (index != null) {
      listWoLaboursParam[index] = WOLaboursParam(
        craftIdV ?? "0",
        skillIdV ?? "0",
        amountC.text,
        stringg.split(','),
      );
    } else {
      log("PERSONIL SELECTED NIP ADD : $listPersonilSelectedNip");
      listWoLaboursParam.add(
        WOLaboursParam(
          craftIdV ?? "0",
          skillIdV ?? "0",
          amountC.text,
          stringg.split(','),
        ),
      );
    }
    notifyListeners();
    clearWoLabours();
    CusNav.nPop(context);
  }

  clearAllListPersonil() {
    listPersonil.clear();
    clearListPersonil();
    allPersonilSelected = false;
    notifyListeners();
  }

  clearWoLabours() {
    craftC.clear();
    craftIdV = null;
    craftV = null;
    skillC.clear();
    skillIdV = null;
    skillV = null;
    amountC.clear();
    personilC.clear();
    clearAllListPersonil();
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
    personilC.text = listWoLaboursParam[index].personilNip.join(',');
    log("PERSONIL : ${personilC.text}");
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Labours",
      logPopUp: logPopUp,
      dismissable: !isEdit,
    );
    clearWoLabours();
  }

  PagingController<int, WOPersonilSearchModelData> _pWoPersonilController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOPersonilSearchModelData> get pWoPersonilController =>
      this._pWoPersonilController;

  set pWoPersonilController(
      PagingController<int, WOPersonilSearchModelData> value) {
    this._pWoPersonilController = value;
  }

  bool _isFetchingWoPersonil = false;
  bool get isFetchingWoPersonil => this._isFetchingWoPersonil;

  set isFetchingWoPersonil(bool value) {
    this._isFetchingWoPersonil = value;
  }

  int _pageSizeWoPersonil = 0;

  int get pageSizeWoPersonil => this._pageSizeWoPersonil;

  set pageSizeWoPersonil(int pageSize) {
    this._pageSizeWoPersonil = pageSize;
    notifyListeners();
  }

  TextEditingController _woPersonilSearchC = TextEditingController();
  get woPersonilSearchC => this._woPersonilSearchC;
  set woPersonilSearchC(value) => this._woPersonilSearchC = value;

  Future<void> fetchWOPersonilSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woRealizationPersonilSearchC.text,
        'asset_code': woRealizationModelData.assetCode ?? "",
      };

      final response = await post(
          Constant.BASE_API_FULL + '/master/personil/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WOPersonilSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoPersonil = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoPersonil;

        if (isLastPage) {
          pWoPersonilController
              .appendLastPage(newItems as List<WOPersonilSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoPersonilController.appendPage(
              newItems as List<WOPersonilSearchModelData>, nextPageKey);
        }
        for (var item in model.data ?? []) {
          boolListPersonil.add(false);
        }
        for (var item in newItems) {
          listPersonil.add(item);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoPersonil = false;
        throw Exception(message);
      }
    }
  }

  setDataWoService() {
    final data = woRealizationModelData.woServices;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoServiceParam.add(
        WOServiceParam(
          item?.serviceId ?? "0",
          item?.service?.name ?? "0",
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
      listWoServiceParam[index] = WOServiceParam(
        serviceSelected?.id ?? "0",
        serviceSelected?.name ?? "0",
        serviceSelected?.uom ?? "0",
        quantity5C.text,
      );
    } else {
      listWoServiceParam.add(
        WOServiceParam(
          serviceSelected?.id ?? "0",
          serviceSelected?.name ?? "0",
          serviceSelected?.uom ?? "0",
          quantity5C.text,
        ),
      );
    }
    serviceC.clear();
    uomC.clear();
    quantity5C.clear();
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

    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Service",
      logPopUp: logPopUp,
      dismissable: !isEdit,
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
        'search': woRealizationServiceSearchC.text,
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

    final response =
        await post(Constant.BASE_API_FULL + '/master/warehouse/get');

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
    final data = woRealizationModelData.woSpareparts;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoSparepartParam.add(
        WOSparepartParam(
          item?.companyId ?? "0",
          item?.code ?? "",
          item?.name ?? "",
          item?.quantity ?? "0",
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
      listWoSparepartParam[index] = WOSparepartParam(
        sparepartSelected?.companyId ?? "0",
        sparepartSelected?.code ?? "",
        sparepartSelected?.name ?? "",
        sparepartSelected?.quantityUpdating ?? "",
        sparepartSelected?.uom ?? "",
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
          sparepartSelected?.quantityUpdating ?? "",
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
    etaC.clear();
    desc6C.clear();
    notifyListeners();
  }

  createWoSparepart(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoSparepart();
    await CustomDialog.woFormDialog(
        context: context, title: "Add Sparepart", logPopUp: logPopUp);
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
    // priceC.text = listWoSparepartParam[index]. ?? "0";
    // priceV = listWoSparepartParam[index].price ?? "0";
    // typeC.text = listWoSparepartParam[index].type ?? "0";
    // typeV = listWoSparepartParam[index].type ?? "0";
    etaC.text = listWoSparepartParam[index].eta;
    desc6C.text = listWoSparepartParam[index].description;
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isEdit ? "Edit" : "View"} Sparepart",
      logPopUp: logPopUp,
      dismissable: !isEdit,
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
        'search': woRealizationSparepartSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/master/services/get',
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
        'search': woRealizationWarehouseSearchC.text,
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

  setDataWoAttachment() {
    final data = woRealizationModelData.woFiles;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoAttachmentParam.add(
        WOAttachmentParam(File(""), item?.file ?? "", item?.fileName ?? "",
            item?.keterangan ?? ""),
      );
    }
  }

  onEditOrAddButtonWoAttachment({required BuildContext context, int? index}) {
    if (index != null) {
      listWoAttachmentParam[index] = WOAttachmentParam(
        imageAttachment1!,
        fileAttach7Url ?? "",
        attachC.text,
        desc7C.text,
      );
    } else {
      listWoAttachmentParam.add(WOAttachmentParam(
        imageAttachment1!,
        fileAttach7Url ?? "",
        attachC.text,
        desc7C.text,
      ));
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
    fileAttach7Url = (listWoAttachmentParam[index].fileURL);
    log("FILE URL : $fileAttach10Url");
    attachC.text = listWoAttachmentParam[index].fileName;
    desc7C.text = listWoAttachmentParam[index].description;
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Preview Attachment",
      logPopUp: logPopUp,
      dismissable: !isEdit,
    );
    clearWoAttachment();
  }

  setDataWoProgress() {
    final data = woRealizationModelData.woProgress;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoProgressParam.add(
        WOProgressParam(
          File(""),
          item?.file ?? "",
          item?.baseProgressId ?? "0",
          item?.date ?? "",
          item?.justification ?? "",
          item?.progress?.description ?? "",
          item?.fileName ?? "",
        ),
      );
    }
  }

  onEditOrAddButtonWoProgress({required BuildContext context, int? index}) {
    if (index != null) {
      listWoProgressParam[index] = WOProgressParam(
        File(""),
        fileAttach8Url ?? "",
        progressSelected?.id ?? "",
        date8.toString(),
        justifyC.text,
        desc8V ?? "",
        attach8C.text,
      );
    } else {
      listWoProgressParam.add(
        WOProgressParam(
          File(""),
          fileAttach8Url ?? "",
          progressSelected?.id ?? "",
          date8.toString(),
          justifyC.text,
          desc8V ?? "",
          attach8C.text,
        ),
      );
    }
    clearWoProgress();
    CusNav.nPop(context);
  }

  clearWoProgress() {
    progressSelected = null;
    desc8V = null;
    "${reqDate ?? DateTime.now()}";
    date8C.clear();
    justifyC.clear();
    desc8C.clear();
    attach8C.clear();
    notifyListeners();
  }

  createWoProgress(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoProgress();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Progress",
      logPopUp: logPopUp,
    );
    clearWoProgress();
  }

  onTapWoProgress(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    fileAttach8Url = listWoProgressParam[index].fileURL;
    desc8C.text = listWoProgressParam[index].description;
    desc8V = listWoProgressParam[index].description;
    date8C.text = listWoProgressParam[index].date;
    justifyC.text = listWoProgressParam[index].justification;
    attach8C.text = listWoProgressParam[index].attachment;
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Edit Progress",
      logPopUp: logPopUp,
      dismissable: !isEdit,
    );
    clearWoProgress();
  }

  PagingController<int, WOProgressSearchModelData> _pWoProgressController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOProgressSearchModelData> get pWoProgressController =>
      this._pWoProgressController;

  set pWoProgressController(
      PagingController<int, WOProgressSearchModelData> value) {
    this._pWoProgressController = value;
  }

  bool _isFetchingWoProgress = false;
  bool get isFetchingWoProgress => this._isFetchingWoProgress;

  set isFetchingWoProgress(bool value) {
    this._isFetchingWoProgress = value;
  }

  int _pageSizeWoProgress = 0;

  get pageSizeWoProgress => this._pageSizeWoProgress;

  set pageSizeWoProgress(pageSize) {
    this._pageSizeWoProgress = pageSize;
    notifyListeners();
  }

  TextEditingController _woProgressSearchC = TextEditingController();
  get woProgressSearchC => this._woProgressSearchC;
  set woProgressSearchC(value) => this._woProgressSearchC = value;

  Future<void> fetchWOProgressSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': woRealizationProgressSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/master/progress/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WOProgressSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoProgress = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoProgress;

        if (isLastPage) {
          pWoProgressController
              .appendLastPage(newItems as List<WOProgressSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoProgressController.appendPage(
              newItems as List<WOProgressSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoProgress = false;
        throw Exception(message);
      }
    }
  }

  setDataWoFailureCode() {
    final data = woRealizationModelData.woFailures;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoFailureCodeParam.add(
        WOFailureCodeParam(
          item?.assetSystemId ?? "0",
          item?.assetSystem?.code ?? "",
          item?.assetSystem?.name ?? "",
          item?.assetSubSystem?.name ?? "",
          item?.assetSubsystemId ?? "0",
          item?.assetSubSystem?.code ?? "",
          item?.description ?? "",
        ),
      );
    }
  }

  onEditOrAddButtonWoFailureCode({required BuildContext context, int? index}) {
    if (index != null) {
      listWoFailureCodeParam[index] = WOFailureCodeParam(
        systemSelected?.id ?? "0",
        systemSelected?.assetCode ?? "",
        systemSelected?.name ?? "",
        subSystemSelected?.name ?? "",
        subSystemSelected?.id ?? "0",
        subSystemSelected?.code ?? "",
        desc9C.text,
      );
    } else {
      listWoFailureCodeParam.add(
        WOFailureCodeParam(
          systemSelected?.id ?? "0",
          systemSelected?.assetCode ?? "",
          systemSelected?.name ?? "",
          subSystemSelected?.name ?? "",
          subSystemSelected?.id ?? "0",
          subSystemSelected?.code ?? "",
          desc9C.text,
        ),
      );
    }
    clearWoFailureCode();
    CusNav.nPop(context);
  }

  clearWoFailureCode() {
    systemSelected = null;
    system9C.clear();
    subSystemSelected = null;
    subsystem9C.clear();
    desc9C.clear();
    notifyListeners();
  }

  createWoFailureCode(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoFailureCode();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Failure Code",
      logPopUp: logPopUp,
    );
    clearWoFailureCode();
  }

  onTapWoFailureCode(
      {required BuildContext context,
      required int index,
      required Widget logPopUp}) async {
    system9C.text = listWoFailureCodeParam[index].assetSystemName;
    subsystem9C.text = listWoFailureCodeParam[index].assetSubSystemName;
    desc9C.text = listWoFailureCodeParam[index].description;

    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Edit FailureCode",
      logPopUp: logPopUp,
      dismissable: !isEdit,
    );
    clearWoFailureCode();
  }

  PagingController<int, WOSystemSearchModelData> _pWoSystemController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOSystemSearchModelData> get pWoSystemController =>
      this._pWoSystemController;

  set pWoSystemController(
      PagingController<int, WOSystemSearchModelData> value) {
    this._pWoSystemController = value;
  }

  bool _isFetchingWoSystem = false;
  bool get isFetchingWoSystem => this._isFetchingWoSystem;

  set isFetchingWoSystem(bool value) {
    this._isFetchingWoSystem = value;
  }

  int _pageSizeWoSystem = 0;

  get pageSizeWoSystem => this._pageSizeWoSystem;

  set pageSizeWoSystem(pageSize) {
    this._pageSizeWoSystem = pageSize;
    notifyListeners();
  }

  TextEditingController _woSystemSearchC = TextEditingController();
  get woSystemSearchC => this._woSystemSearchC;
  set woSystemSearchC(value) => this._woSystemSearchC = value;

  Future<void> fetchWOSystemSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'asset_code': woRealizationModelData.asset?.code ?? "",
        'search': woRealizationSystemSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/master/system/get-system',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WOSystemSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoSystem = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoSystem;

        if (isLastPage) {
          pWoSystemController
              .appendLastPage(newItems as List<WOSystemSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoSystemController.appendPage(
              newItems as List<WOSystemSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoSystem = false;
        throw Exception(message);
      }
    }
  }

  PagingController<int, WOSubSystemSearchModelData> _pWoSubSystemController =
      PagingController(firstPageKey: 1);

  PagingController<int, WOSubSystemSearchModelData>
      get pWoSubSystemController => this._pWoSubSystemController;

  set pWoSubSystemController(
      PagingController<int, WOSubSystemSearchModelData> value) {
    this._pWoSubSystemController = value;
  }

  bool _isFetchingWoSubSystem = false;
  bool get isFetchingWoSubSystem => this._isFetchingWoSubSystem;

  set isFetchingWoSubSystem(bool value) {
    this._isFetchingWoSubSystem = value;
  }

  int _pageSizeWoSubSystem = 0;

  get pageSizeWoSubSystem => this._pageSizeWoSubSystem;

  set pageSizeWoSubSystem(pageSize) {
    this._pageSizeWoSubSystem = pageSize;
    notifyListeners();
  }

  TextEditingController _woSubSystemSearchC = TextEditingController();
  get woSubSystemSearchC => this._woSubSystemSearchC;
  set woSubSystemSearchC(value) => this._woSubSystemSearchC = value;

  Future<void> fetchWOSubSystemSearch({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'asset_code': woRealizationModelData.asset?.code ?? "",
        'system_code': systemSelected?.code ?? "",
        'search': woRealizationSubSystemSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/master/system/get-subsystem',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            WOSubSystemSearchModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeWoSubSystem = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSizeWoSubSystem;

        if (isLastPage) {
          pWoSubSystemController
              .appendLastPage(newItems as List<WOSubSystemSearchModelData>);
        } else {
          final nextPageKey = page += 1;
          pWoSubSystemController.appendPage(
              newItems as List<WOSubSystemSearchModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["Message"];
        loading(false);
        isFetchingWoSubSystem = false;
        throw Exception(message);
      }
    }
  }

  setDataWoAttachment2() {
    final data = woRealizationModelData.woFiles;
    for (int i = 0; i < (data ?? []).length; i++) {
      final item = data?[i];
      listWoAttachmentRealizationParam.add(
        WOAttachmentRealizationParam(
          item?.keterangan ?? "",
          File(""),
          item?.file ?? "",
          item?.fileName ?? "",
        ),
      );
    }
  }

  onEditOrAddButtonWoAttachment2({required BuildContext context, int? index}) {
    log("IMAGE ATTACHMENT PATH : ${imageAttachment2?.path}");
    if (index != null) {
      listWoAttachmentRealizationParam[index] = WOAttachmentRealizationParam(
        desc10C.text,
        imageAttachment2!,
        fileAttach10Url ?? "",
        attach10C.text,
      );
    } else {
      listWoAttachmentRealizationParam.add(WOAttachmentRealizationParam(
        desc10C.text,
        imageAttachment2!,
        fileAttach10Url ?? "",
        attach10C.text,
      ));
    }
    clearWoAttachment2();
    CusNav.nPop(context);
    CusNav.nPop(context);
  }

  clearWoAttachment2() {
    fileAttach10Url = null;
    attach10C.clear();
    desc10C.clear();
    notifyListeners();
  }

  createWoAttachment2(
      {required BuildContext context, required Widget logPopUp}) async {
    clearWoAttachment2();
    await CustomDialog.woFormDialog(
      context: context,
      title: "Add Attachment",
      logPopUp: logPopUp,
    );
    clearWoAttachment2();
  }

  onTapWoAttachment2(
      {required BuildContext context,
      required int index,
      required bool isPreview,
      required Widget logPopUp}) async {
    fileAttach10Url = (listWoAttachmentRealizationParam[index].fileURL);
    log("FILE URL : $fileAttach10Url");
    attach10C.text = listWoAttachmentRealizationParam[index].fileName;
    desc10C.text = listWoAttachmentRealizationParam[index].description;
    notifyListeners();
    await CustomDialog.woFormDialog(
      context: context,
      title: "${isPreview ? "Preview" : "Edit"} Attachment",
      logPopUp: logPopUp,
      dismissable: !isEdit,
    );
    clearWoAttachment2();
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

  Future<void> fetchWORealizationLog(String id,
      {bool withLoading = false}) async {
    if (withLoading) loading(true);
    Map<String, String> param = {'id': '$id'};
    final response = await post(
        Constant.BASE_API_FULL + '/transaction/work-order-realization/listLog',
        body: param);

    if (response.statusCode == 200) {
      final model = WORealizationLogModel.fromJson(jsonDecode(response.body));
      woRealizationLogModel = model;
      notifyListeners();

      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  WORealizationApproveModel _woRealizationApproveModel =
      WORealizationApproveModel();

  WORealizationApproveModel get woRealizationApproveModel =>
      this._woRealizationApproveModel;

  set woRealizationApproveModel(WORealizationApproveModel value) {
    this._woRealizationApproveModel = value;
    notifyListeners();
  }

  Future<void> fetchWORealizationApprove(String id,
      {bool withLoading = false}) async {
    if (withLoading) loading(true);
    Map<String, String> param = {'id': '$id'};
    final response = await post(
        Constant.BASE_API_FULL +
            '/transaction/work-order-realization/listApprove',
        body: param);

    if (response.statusCode == 200) {
      final model =
          WORealizationApproveModel.fromJson(jsonDecode(response.body));
      woRealizationApproveModel = model;
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

  Future<void> sendWORealization() async {
    loading(true);
    // if (createWoRealizationtKey.currentState!.validate()) {
    String encodedId =
        Encrypt().encode64(woRealizationModelData.asset?.id ?? "0");
    // if (categoryV == null) {
    //   throw 'Category Harus Dipilih';
    // }
    String dateSelected =
        DateFormat("yyyy-MM-dd", "id_ID").format(date ?? DateTime.now());
    List<http.MultipartFile> files = [];
    Map<String, String> param = {
      'id': encodedId,
      // Step 1 Work Order
      'doc_no': woRealizationModelData.asset?.code ?? "",
      'type_work': workTypeShortC.text,
      'date_doc': dateSelected,
      // missing asset & workOrder
      'date_start': estimatedStartC.text,
      'date_end': estimatedCompleteC.text,
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
      if (listPersonilSelectedNip.isNotEmpty) {
        for (int j = 0; j < listPersonilSelectedNip.length; i++) {
          final item = listPersonilSelectedNip[j];
          param.addAll({'WorkorderLabours[$i][personil][$j]': item ?? ""});
        }
      }
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
        'WorkorderSparepart[$i][wh_name]': item.whName,
        'WorkorderSparepart[$i][wh_code]': item.whCode,
        'WorkorderSparepart[$i][unit_code]': item.unitCode,
        'WorkorderSparepart[$i][unit_name]': item.unitName,
      });
    }
    // if there is step 7/10 attachment
    // for (int i = 0; i < listWoAttachmentParam.length; i++) {
    //   final item = listWoAttachmentParam[i];
    //   if (imageAttachment1 != null) {
    //     files.add(await getMultipart(
    //         'WorkorderAttachment[$i][image]', File(item.file.path)));
    //   } else {
    //     // throw 'Harap Isi Pas Foto';
    //   }
    //   param.addAll({
    //     // 'WorkorderSparepart[$i][image]': "1", multipart
    //     'WorkorderAttachment[$i][description]': item.description,
    //   });
    // }
    for (int i = 0; i < listWoAttachmentRealizationParam.length; i++) {
      final item = listWoAttachmentRealizationParam[i];
      // if (item.file != null) {
      files.add(await getMultipart(
          'WorkorderAttachment[$i][image]', File(imageAttachment1!.path)));
      // } else {
      // throw 'Harap Isi Pas Foto';
      // }
      param.addAll({
        // 'WorkorderSparepart[$i][image]': "1", multipart
        'WorkorderAttachment[$i][description]': item.description,
      });
    }
    // if there is step 8 Progrress
    for (int i = 0; i < listWoProgressParam.length; i++) {
      final item = listWoProgressParam[i];
      // if (imageAttachment2 != null) {
      files.add(await getMultipart(
          'WorkorderProgress[$i][image]', File(item.file.path)));
      // } else {
      // throw 'Harap Isi Pas Foto';
      // }
      param.addAll({
        // 'WorkorderProgress[$i][image]': "1", multipart
        'WorkorderProgress[$i][base_progress_id]': item.baseProgressId,
        'WorkorderProgress[$i][date]': item.date,
        'WorkorderProgress[$i][justification]': item.justification,
      });
    }
    // if there is step 9 FailureCode
    for (int i = 0; i < listWoFailureCodeParam.length; i++) {
      final item = listWoFailureCodeParam[i];
      param.addAll({
        'WorkorderFailureCode[$i][asset_system_id]': item.assetSystemId,
        'WorkorderFailureCode[$i][asset_system_code]': item.assetSystemCode,
        'WorkorderFailureCode[$i][asset_system_name]': item.assetSystemName,
        'WorkorderFailureCode[$i][asset_subsystem_id]': item.assetSubSystemId,
        'WorkorderFailureCode[$i][asset_subsystem_code]':
            item.assetSubSystemCode,
        'WorkorderFailureCode[$i][asset_subsystem_name]':
            item.assetSubSystemName,
        'WorkorderFailureCode[$i][description]': item.description,
      });
    }

    // if there is step 10 attachment
    // for (int i = 0; i < 1; i++) {
    //   param.addAll({
    //     // 'WorkorderSparepart[$i][image]': "1", multipart
    //     'WorkorderAttachmentRealization[$i][description]':
    //         "DEscription tes gambar",
    //   });
    // }

    final response = BaseResponse.from(await post(
      Constant.BASE_API_FULL + '/transaction/work-order-realization/edit',
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
    // throw 'Harap Lengkapi Form';
    // }
  }

  Future<void> action({required String type, String note = ""}) async {
    loading(true);
    String encodedId =
        Encrypt().encode64(woRealizationModelData.asset?.id ?? "0");
    Map<String, String> param = {'id': encodedId};
    if (type == "approve" || type == "void" || type == "reject") {
      // if (note == "") throw 'Harap Lengkapi Keterangan';
      param.addAll({'note': note});
    }
    String typeAction = type;
    if (type == "BA Persetujuan") {
      typeAction = "ba-persetujuan";
    }
    if (type == "BA Realisasi") {
      typeAction = "ba-realisasi";
    }
    final response = BaseResponse.from(await post(
        Constant.BASE_API_FULL +
            '/transaction/work-order-realization/$typeAction',
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
                    await sendWORealization().then((value) async {
                      await Utils.showSuccess(
                          msg: "Edit WO Realization Success");
                      Future.delayed(
                          Duration(seconds: 2), () => CusNav.nPop(context));
                    }).onError((error, stackTrace) {
                      Utils.showFailed(
                          msg:
                              error.toString().toLowerCase().contains("doctype")
                                  ? "Maaf, Terjadi Galat!"
                                  : "$error");
                    });
                  },
                  noCallback: () => CusNav.nPop(context));
            }),
          )
        ],
      ),
    );
  }
}
