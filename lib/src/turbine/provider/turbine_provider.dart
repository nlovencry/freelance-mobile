import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:hy_tutorial/utils/utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import '../../../common/base/base_controller.dart';
import '../../../common/component/custom_alert.dart';
import '../../../common/helper/constant.dart';
import '../../../main.dart';
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

  bool _ascending = false;
  bool get ascending => this._ascending;
  set ascending(bool value) => this._ascending = value;
  bool _descending = false;
  bool get descending => this._descending;
  set descending(bool value) => this._descending = value;

  bool _towerName = false;
  bool get towerName => this._towerName;

  set towerName(bool value) => this._towerName = value;

  bool _createdAt = false;
  bool get createdAt => this._createdAt;

  set createdAt(bool value) => this._createdAt = value;

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

  DateTime? get startDate => _startDate;

  setStartDate(DateTime? date) {
    _startDate = date;
    if (date != null)
      startDateC.text =
          DateFormat("yyyy-MM-dd").format(date ?? DateTime.now()).toString();
    notifyListeners();
  }

  DateTime? _endDate;

  DateTime? get endDate => _endDate;

  setEndDate(DateTime? date) {
    _endDate = date;
    if (date != null)
      endDateC.text =
          DateFormat("yyyy-MM-dd").format(date ?? DateTime.now()).toString();
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

  Future<void> getTurbine() async {
    pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener((pageKey) async {
        log("GET TURBINE");
        await fetchTurbine(page: pageKey).onError((error, stackTrace) {
          if (error.toString().contains('expired token')) {
            log("ERROR EXPIRED TOKEN");
            next = null;
            pagingController.refresh();
          } else {
            BuildContext? context =
                NavigationService.navigatorKey.currentContext;
            if (context != null)
              CustomAlert.showSnackBar(
                  context, 'Gagal Mendapatkan Data Turbine', true);
          }
        });
      });
  }

  Future<void> fetchTurbine({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    try {
      if (!isFetching) {
        isFetching = true;
        if (withLoading) loading(true);
        String startDateSelected =
            DateFormat("yyyy-MM-dd").format(startDate ?? DateTime.now());
        String endDateSelected =
            DateFormat("yyyy-MM-dd").format(endDate ?? DateTime.now());

        String url = Constant.BASE_API_FULL + '/turbines';
        Map<String, String> param = {};
        if (turbineSearchC.text.isNotEmpty)
          param.addAll({'Search': turbineSearchC.text});
        if (startDate != null) param.addAll({'StartDate': startDateSelected});
        if (endDate != null) param.addAll({'EndDate': endDateSelected});
        if (ascending) {
          param.remove('SortOrder');
          param.addAll({'SortOrder': 'ASC'});
        }
        if (descending) {
          param.remove('SortOrder');
          param.addAll({'SortOrder': 'DESC'});
        }
        if (towerName) {
          param.remove('SortBy');
          param.addAll({'SortBy': 'TowerName'});
        }
        if (createdAt) {
          param.remove('SortBy');
          param.addAll({'SortBy': 'CreatedAt'});
        }
        if (next != null) param.addAll({'Next': next ?? ''});
        log("PANGGIL");
        if (_pagingController.itemList?.length != 0) {
          await Future.delayed(Duration(seconds: 1));
        }
        final response = await get(
          url,
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
          log("MASUK ELSE");
          loading(false);
          isFetching = false;
          final message = jsonDecode(response.body)["Message"];
          throw Exception(message);
        }
      }
    } catch (e) {
      log("MASUK ELSE CATCH $e");
      loading(false);
      isFetching = false;
      throw Exception(e.toString());
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
      return TurbineCreateModel();
      // throw Exception(message);
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
      return TurbineCreateModel();
      // throw Exception(message);
    }
  }
}
