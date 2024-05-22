import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bimops/common/base/base_controller.dart';
import 'package:bimops/common/helper/constant.dart';
import 'package:bimops/common/helper/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../../../../common/base/base_response.dart';
import '../model/asset_meter_category_model.dart';
import '../model/asset_meter_meter_lalu_model.dart';
import '../model/asset_meter_model.dart';
import '../model/asset_meter_view_model.dart';

class AssetMeterProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> createAssetKey = GlobalKey<FormState>();

  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
  }

  PagingController<int, AssetMeterModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, AssetMeterModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, AssetMeterModelData> value) {
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
  TextEditingController assetMeterCategorySearchC = TextEditingController();

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

  AssetMeterCategoryModelData? _categoryV;

  AssetMeterCategoryModelData? get categoryV => this._categoryV;

  set categoryV(AssetMeterCategoryModelData? value) {
    this._categoryV = value;
    notifyListeners();
  }

  String isSubAgent = "agen";
  String get getIsSubAgent => this.isSubAgent;
  AssetMeterModel assetMeterModel = AssetMeterModel();

  AssetMeterModel get getAssetMeterModel => this.assetMeterModel;

  set setAssetMeterModel(AssetMeterModel assetMeterModel) =>
      this.assetMeterModel = assetMeterModel;
  set setIsSubAgent(String isSubAgent) => this.isSubAgent = isSubAgent;

  Future<void> fetchAssetMeter({
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
        final model = AssetMeterModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        log("IS LAST PAGE : $isLastPage");
        if (isLastPage) {
          pagingController
              .appendLastPage(newItems as List<AssetMeterModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController.appendPage(
              newItems as List<AssetMeterModelData>, nextPageKey);
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

  PagingController<int, AssetMeterViewModelData> _pagingControllerView =
      PagingController(firstPageKey: 1);

  PagingController<int, AssetMeterViewModelData> get pagingControllerView =>
      this._pagingControllerView;

  set pagingControllerView(
      PagingController<int, AssetMeterViewModelData> value) {
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

  AssetMeterViewModel assetMeterViewModel = AssetMeterViewModel();

  get getAssetMeterViewModel => this.assetMeterViewModel;

  set setAssetMeterViewModel(assetMeterViewModel) =>
      this.assetMeterViewModel = assetMeterViewModel;

  AssetMeterViewModelData _assetMeterViewModelData = AssetMeterViewModelData();
  AssetMeterViewModelData get assetMeterViewModelData =>
      this._assetMeterViewModelData;

  set assetMeterViewModelData(AssetMeterViewModelData value) =>
      this._assetMeterViewModelData = value;

  Future<void> fetchAssetMeterView({
    bool withLoading = false,
    required int page,
    required String assetCode,
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'asset_code': assetCode,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/asset/base-asset/view',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = AssetMeterViewModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeAssetView = 10;
        final isLastPage = newItems.length < pageSizeAssetView;

        if (isLastPage) {
          pagingControllerView
              .appendLastPage(newItems as List<AssetMeterViewModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingControllerView.appendPage(
              newItems as List<AssetMeterViewModelData>, nextPageKey);
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
  PagingController<int, AssetMeterCategoryModelData> _pagingControllerCategory =
      PagingController(firstPageKey: 1);

  PagingController<int, AssetMeterCategoryModelData>
      get pagingControllerCategory => this._pagingControllerCategory;

  set pagingControllerCategory(
      PagingController<int, AssetMeterCategoryModelData> value) {
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

  AssetMeterCategoryModel assetMeterCategoryModel = AssetMeterCategoryModel();

  get getAssetMeterCategoryModel => this.assetMeterCategoryModel;

  set setAssetMeterCategoryModel(assetMeterCategoryModel) =>
      this.assetMeterCategoryModel = assetMeterCategoryModel;

  Future<void> fetchAssetCategory(
      {bool withLoading = false, required int page}) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': assetMeterCategorySearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/asset/asset-meter/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            AssetMeterCategoryModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeAssetCategory = 10;
        final isLastPage = newItems.length < pageSizeAssetCategory;

        if (isLastPage) {
          pagingControllerCategory
              .appendLastPage(newItems as List<AssetMeterCategoryModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingControllerCategory.appendPage(
              newItems as List<AssetMeterCategoryModelData>, nextPageKey);
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

  Future<void> addAssetMeter(
      {required String assetId, required String assetCode}) async {
    loading(true);
    if (createAssetKey.currentState!.validate()) {
      String encodedId = Encrypt().encode64(assetId);
      if (categoryV == null) {
        throw 'Category Harus Dipilih';
      }
      String dateSelected =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(date ?? DateTime.now());
      Map<String, String> param = {
        'id': encodedId,
        'asset_code': assetCode,
        'date_doc': dateSelected,
        'category': categoryV?.name ?? "",
        'asset_meter_code': categoryV?.code ?? "",
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
        Constant.BASE_API_FULL + '/transaction/asset-meter/add',
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

  AssetMeterMeterLaluModel _assetMeterMeterLaluModel =
      AssetMeterMeterLaluModel();
  AssetMeterMeterLaluModel get assetMeterMeterLaluModel =>
      this._assetMeterMeterLaluModel;

  set assetMeterMeterLaluModel(AssetMeterMeterLaluModel value) {
    this._assetMeterMeterLaluModel = value;
    notifyListeners();
  }

  AssetMeterModelData _assetMeterModelData = AssetMeterModelData();
  AssetMeterModelData get assetMeterModelData => this._assetMeterModelData;

  set assetMeterModelData(AssetMeterModelData value) {
    this._assetMeterModelData = value;
    notifyListeners();
  }

  Future<void> fetchAssetMeterLalu(
      {bool withLoading = false, required String assetMeterCode}) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'asset_code': assetMeterModelData.code ?? "",
        'asset_meter_code': assetMeterCode
      };

      final response = await post(
          Constant.BASE_API_FULL + '/transaction/asset-meter/get-meter-lalu',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        assetMeterMeterLaluModel =
            AssetMeterMeterLaluModel.fromJson(jsonDecode(response.body));

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

  Future<void> clearAssetMeterForm() async {
    assetC.clear();
    dateC.clear();
    categoryC.clear();
    categoryV = null;
    meter1C.clear();
    meter2C.clear();
    descC.clear();
  }
}
