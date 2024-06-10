import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:mata/common/base/base_controller.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../../../../common/base/base_response.dart';
import '../../../../common/helper/encrypt.dart';
import '../model/operation_hours_category_model.dart';
import '../model/operation_hours_model.dart';
import '../model/operation_hours_view_model.dart';

class OperationHoursProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> createOperationHoursKey = GlobalKey<FormState>();

  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
  }

  PagingController<int, OperationHoursModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, OperationHoursModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, OperationHoursModelData> value) {
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
    this.pageSize;
  }

  TextEditingController assetSearchC = TextEditingController();
  TextEditingController assetSearchCategoryC = TextEditingController();

  TextEditingController assetC = TextEditingController();
  TextEditingController dateC = TextEditingController();
  TextEditingController categoryC = TextEditingController();
  TextEditingController meter1C = TextEditingController();
  TextEditingController meter2C = TextEditingController();
  TextEditingController descC = TextEditingController();

  FocusNode descNode = FocusNode();

  DateTime? _date;

  get date => _date;

  setDate(DateTime? date) {
    _date = date;
    dateC.text = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  OperationHoursCategoryModelData? _categoryV;

  OperationHoursCategoryModelData? get categoryV => this._categoryV;

  set categoryV(OperationHoursCategoryModelData? value) {
    this._categoryV = value;
    notifyListeners();
  }

  String isSubAgent = "agen";
  String get getIsSubAgent => this.isSubAgent;
  OperationHoursModel operationHoursModel = OperationHoursModel();

  OperationHoursModel get getOperationHoursModel => this.operationHoursModel;

  set setOperationHoursModel(OperationHoursModel operationHoursModel) =>
      this.operationHoursModel = operationHoursModel;
  set setIsSubAgent(String isSubAgent) => this.isSubAgent = isSubAgent;

  Future<void> fetchOperationHours({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': assetSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/asset/base-asset/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = OperationHoursModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          pagingController
              .appendLastPage(newItems as List<OperationHoursModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController.appendPage(
              newItems as List<OperationHoursModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["message"];
        loading(false);
        isFetching = false;
        throw Exception(message);
      }
    }
  }

  // ASSET METER VIEW

  PagingController<int, OperationHoursViewModelData> _pagingControllerView =
      PagingController(firstPageKey: 1);

  PagingController<int, OperationHoursViewModelData> get pagingControllerView =>
      this._pagingControllerView;

  set pagingControllerView(
      PagingController<int, OperationHoursViewModelData> value) {
    this._pagingControllerView = value;
  }

  bool _isFetchingAssetView = false;
  bool get isFetchingAssetView => this._isFetchingAssetView;

  set isFetchingAssetView(bool value) {
    this._isFetchingAssetView = value;
  }

  int pageSizeAssetView = 0;

  get getPageSizeAssetView => this.pageSizeAssetView;

  set setPageSizeAssetView(pageSize) {
    this.pageSizeAssetView;
  }

  OperationHoursViewModel operationHoursViewModel = OperationHoursViewModel();

  get getOperationHoursViewModel => this.operationHoursViewModel;

  set setOperationHoursViewModel(operationHoursViewModel) =>
      this.operationHoursViewModel = operationHoursViewModel;

  Future<void> fetchOperationHoursView({
    bool withLoading = false,
    required int page,
    required String operationHoursCode,
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': assetSearchC.text,
        'asset_code': operationHoursCode,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/asset/base-asset/view',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            OperationHoursViewModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeAssetView = 10;
        final isLastPage = newItems.length < pageSizeAssetView;

        if (isLastPage) {
          pagingControllerView
              .appendLastPage(newItems as List<OperationHoursViewModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingControllerView.appendPage(
              newItems as List<OperationHoursViewModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["message"];
        loading(false);
        isFetching = false;
        throw Exception(message);
      }
    }
  }

  // ASSET METER CATEGORY
  PagingController<int, OperationHoursCategoryModelData>
      _pagingControllerCategory = PagingController(firstPageKey: 1);

  PagingController<int, OperationHoursCategoryModelData>
      get pagingControllerCategory => this._pagingControllerCategory;

  set pagingControllerCategory(
      PagingController<int, OperationHoursCategoryModelData> value) {
    this._pagingControllerCategory = value;
  }

  bool _isFetchingAssetCategory = false;
  bool get isFetchingAssetCategory => this._isFetchingAssetCategory;

  set isFetchingAssetCategory(bool value) {
    this._isFetchingAssetCategory = value;
  }

  int pageSizeAssetCategory = 0;

  get getPageSizeAssetCategory => this.pageSizeAssetCategory;

  set setPageSizeAssetCategory(pageSize) {
    this.pageSizeAssetCategory;
  }

  OperationHoursCategoryModel operationHoursCategoryModel =
      OperationHoursCategoryModel();

  OperationHoursCategoryModel get getOperationHoursCategoryModel =>
      this.operationHoursCategoryModel;

  set setOperationHoursCategoryModel(
      OperationHoursCategoryModel operationHoursCategoryModel) {
    this.operationHoursCategoryModel = operationHoursCategoryModel;
    notifyListeners();
  }

  Future<void> fetchAssetCategory(
      {bool withLoading = false, required int page}) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': assetSearchCategoryC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/asset/asset-meter/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            OperationHoursCategoryModel.fromJson(jsonDecode(response.body));
        setOperationHoursCategoryModel = model;
        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeAssetCategory = 10;
        final isLastPage = newItems.length < pageSizeAssetCategory;

        if (isLastPage) {
          pagingControllerCategory.appendLastPage(
              newItems as List<OperationHoursCategoryModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingControllerCategory.appendPage(
              newItems as List<OperationHoursCategoryModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching = false;
      } else {
        final message = jsonDecode(response.body)["message"];
        loading(false);
        isFetching = false;
        throw Exception(message);
      }
    }
  }

  Future<void> addOperationHours(
      {required String assetId, required String assetCode}) async {
    loading(true);
    if (createOperationHoursKey.currentState!.validate()) {
      String encodedId = Encrypt().encode64(assetId);
      if (categoryV == null) {
        throw 'Category Harus Dipilih';
      }
      String dateSelected =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(date ?? DateTime.now());
      Map<String, String> param = {
        'id': encodedId,
        'asset_meter_code': assetCode,
        'date': dateSelected,
        // 'category': categoryV?.name ?? "",
        'meter_reading': meter2C.text,
        'description': descC.text,
      };
      // List<http.MultipartFile> files = [];
      // if (pasPhotoPic != null) {
      //   files.add(await getMultipart('pas_photo', File(pasPhotoPic!.path)));
      // } else {
      //   throw 'Harap Isi Pas Foto';
      // }
      final response = BaseResponse.from(await post(
        Constant.BASE_API_FULL + '/transaction/jam-operasi/add',
        body: param,
        // files: files.isEmpty ? null : files,
      ));

      if (response.success) {
        loading(false);
      } else {
        loading(false);
        throw Exception(response.message);
      }
    } else {
      loading(false);
      throw 'Harap Lengkapi Form';
    }
  }

  Future<void> clearOperationHoursForm() async {
    assetC.clear();
    dateC.clear();
    categoryC.clear();
    categoryV = null;
    meter1C.clear();
    meter2C.clear();
    descC.clear();
  }
}
