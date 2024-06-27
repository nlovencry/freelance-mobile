import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import '../../../common/base/base_controller.dart';
import '../../../common/helper/constant.dart';
import '../model/turbine_create_model.dart';
import '../model/turbine_detail_model.dart';
import '../model/turbine_model.dart';

class TurbineProvider extends BaseController with ChangeNotifier {
  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
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

  String? _filterDateStartString;
  String? get filterDateStartString => this._filterDateStartString;
  set filterDateStartString(String? value) =>
      this._filterDateStartString = value;

  DateTime? _filterDateStart;

  get filterDateStart => _filterDateStart;

  setFilterDateStart(DateTime? date) {
    _filterDateStart = date;
    filterDateStartString =
        DateFormat("dd MMMM yyyy").format(date ?? DateTime.now());
    notifyListeners();
  }

  String? _filterDateEndString;
  String? get filterDateEndString => this._filterDateEndString;
  set filterDateEndString(String? value) => this._filterDateEndString = value;

  DateTime? _filterDateEnd;

  get filterDateEnd => _filterDateEnd;

  setFilterDateEnd(DateTime? date) {
    _filterDateEnd = date;
    filterDateEndString =
        DateFormat("dd MMMM yyyy").format(date ?? DateTime.now());
    notifyListeners();
  }

  bool _isEdit = false;
  bool get isEdit => this._isEdit;

  set isEdit(bool value) {
    this._isEdit = value;
    notifyListeners();
  }

  TextEditingController turbineSearchC = TextEditingController();
  TextEditingController filterC = TextEditingController();
  TextEditingController startDateC = TextEditingController();
  TextEditingController endDateC = TextEditingController();


  String? _filterV;

  String? get filterV => this._filterV;

  set filterV(String? value) {
    this._filterV = value;
    notifyListeners();
  }

  DateTime? _startDate;

  get startDate => _startDate;

  setStartDate(DateTime? date) {
    _startDate = date;
    startDateC.text = DateFormat("yyyy-MM-dd")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }
  DateTime? _endDate;

  get endDate => _endDate;

  setEndDate(DateTime? date) {
    _endDate = date;
    endDateC.text = DateFormat("yyyy-MM-dd")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  PagingController<int, TurbineModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, TurbineModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, TurbineModelData> value) {
    this._pagingController = value;
  }

  String? next;

  TurbineModel _turbineModel = TurbineModel();
  TurbineModel get turbineModel => this._turbineModel;
  set turbineModel(TurbineModel value) => this._turbineModel = value;

  Future<void> fetchTurbine({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      String startDateSelected =
      DateFormat("yyyy-MM-dd").format(startDate ?? DateTime.now());
      String endDateSelected =
      DateFormat("yyyy-MM-dd").format(endDate ?? DateTime.now());

      Map<String, String> param = {
        'Page': '$page',
        'Search': turbineSearchC.text,
        'PerPage': "10",
        'StartDate' : startDateSelected,
        'EndDate' : endDateSelected,
      };
      if (next != null) param.addAll({'Next': next ?? ''});
      log("PANGGIL");
      final response = await get(
        Constant.BASE_API_FULL + '/turbines',
        body: param,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        turbineModel = TurbineModel();
        final model = TurbineModel.fromJson(jsonDecode(response.body));
        final newItems = model.Data ?? [];
        // turbineModel = model;
        // notifyListeners();

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          next = null;
          pagingController.appendLastPage(newItems as List<TurbineModelData>);
        } else {
          final nextPageKey = page += 1;
          if (model.Meta?.Next != null && model.Meta?.Next != '')
            next = model.Meta?.Next ?? '';
          pagingController.appendPage(
              newItems as List<TurbineModelData>, nextPageKey);
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

  clearDate() {
    startDateC.clear();
    endDateC.clear();
  }

  Future<TurbineCreateModel> fetchTurbineDetail(int id) async {
    loading(true);
    final response = await get(Constant.BASE_API_FULL + '/turbines/$id');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TurbineCreateModel.fromJson(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future<TurbineCreateModel> createTurbine() async {
    loading(true);
    final response = await post(Constant.BASE_API_FULL + '/turbines');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TurbineCreateModel.fromJson(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }
}
