import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hy_tutorial/common/base/base_controller.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../../../../common/base/base_response.dart';
import '../../../../common/helper/encrypt.dart';
import '../model/asset_downtime_category_model.dart';
import '../model/asset_downtime_model.dart';
import '../model/asset_downtime_view_model.dart';

class AssetDowntimeProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> createAssetKey = GlobalKey<FormState>();

  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
  }

  PagingController<int, AssetDowntimeModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, AssetDowntimeModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, AssetDowntimeModelData> value) {
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

  TextEditingController assetC = TextEditingController();
  TextEditingController documentDateC = TextEditingController();
  TextEditingController upDateC = TextEditingController();
  TextEditingController categoryC = TextEditingController();
  TextEditingController downtime1C = TextEditingController();
  TextEditingController downtime2C = TextEditingController();
  TextEditingController descC = TextEditingController();

  FocusNode descNode = FocusNode();

  DateTime? _documentDate;

  get date => _documentDate;

  setDocumentDate(DateTime? date) {
    _documentDate = date;
    documentDateC.text = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  DateTime? _upDate;

  get upDate => _upDate;

  setUpDate(DateTime? date) {
    _upDate = date;
    upDateC.text = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(date ?? DateTime.now())
        .toString();
    notifyListeners();
  }

  String isSubAgent = "agen";
  String get getIsSubAgent => this.isSubAgent;
  AssetDowntimeModel assetDowntimeModel = AssetDowntimeModel();

  AssetDowntimeModel get getAssetDowntimeModel => this.assetDowntimeModel;

  set setAssetDowntimeModel(AssetDowntimeModel assetDowntimeModel) =>
      this.assetDowntimeModel = assetDowntimeModel;

  AssetDowntimeCategoryModelData? _categoryV;

  AssetDowntimeCategoryModelData? get categoryV => this._categoryV;

  set categoryV(AssetDowntimeCategoryModelData? value) {
    this._categoryV = value;
    notifyListeners();
  }

  set setIsSubAgent(String isSubAgent) => this.isSubAgent = isSubAgent;

  Future<void> fetchAssetDowntime({
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
        final model = AssetDowntimeModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          pagingController
              .appendLastPage(newItems as List<AssetDowntimeModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController.appendPage(
              newItems as List<AssetDowntimeModelData>, nextPageKey);
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

  // ASSET METER VIEW

  PagingController<int, AssetDowntimeViewModelData> _pagingControllerView =
      PagingController(firstPageKey: 1);

  PagingController<int, AssetDowntimeViewModelData> get pagingControllerView =>
      this._pagingControllerView;

  set pagingControllerView(
      PagingController<int, AssetDowntimeViewModelData> value) {
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

  AssetDowntimeViewModel assetDowntimeViewModel = AssetDowntimeViewModel();

  get getAssetDowntimeViewModel => this.assetDowntimeViewModel;

  set setAssetDowntimeViewModel(assetDowntimeViewModel) =>
      this.assetDowntimeViewModel = assetDowntimeViewModel;

  Future<void> fetchAssetDowntimeView({
    bool withLoading = false,
    required int page,
    required String assetCode,
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);

      // String encodedId = Encrypt().encode64(assetId);
      Map<String, String> param = {
        'page': '$page',
        'asset_code': assetCode,
        // 'id': encodedId,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/transaction/asset-downtime/view',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            AssetDowntimeViewModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeAssetView = 10;
        final isLastPage = newItems.length < pageSizeAssetView;

        if (isLastPage) {
          pagingControllerView
              .appendLastPage(newItems as List<AssetDowntimeViewModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingControllerView.appendPage(
              newItems as List<AssetDowntimeViewModelData>, nextPageKey);
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

  // ASSET METER CATEGORY
  PagingController<int, AssetDowntimeCategoryModelData>
      _pagingControllerCategory = PagingController(firstPageKey: 1);

  PagingController<int, AssetDowntimeCategoryModelData>
      get pagingControllerCategory => this._pagingControllerCategory;

  set pagingControllerCategory(
      PagingController<int, AssetDowntimeCategoryModelData> value) {
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

  AssetDowntimeCategoryModel assetDowntimeCategoryModel =
      AssetDowntimeCategoryModel();

  get getAssetDowntimeCategoryModel => this.assetDowntimeCategoryModel;

  set setAssetDowntimeCategoryModel(assetDowntimeCategoryModel) =>
      this.assetDowntimeCategoryModel = assetDowntimeCategoryModel;

  Future<void> fetchAssetCategory(
      {bool withLoading = false, required int page}) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {'page': '$page'};

      final response = await post(
          Constant.BASE_API_FULL + '/asset/asset-meter/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model =
            AssetDowntimeCategoryModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSizeAssetCategory = 10;
        final isLastPage = newItems.length < pageSizeAssetCategory;

        if (isLastPage) {
          pagingControllerCategory
              .appendLastPage(newItems as List<AssetDowntimeCategoryModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingControllerCategory.appendPage(
              newItems as List<AssetDowntimeCategoryModelData>, nextPageKey);
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

  Future<void> addAssetDowntime(
      {required String assetId,
      required String assetCode,
      bool isEdit = false}) async {
    loading(true);
    if (createAssetKey.currentState!.validate()) {
      String encodedId = Encrypt().encode64(assetId);
      // if (categoryV == null) {
      //   throw 'Category Harus Dipilih';
      // }
      String dateSelected =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(date ?? DateTime.now());
      String dateUpSelected =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(upDate ?? DateTime.now());
      Map<String, String> param = {
        'id': encodedId,
        'asset_code': assetCode,
        'date_doc': dateSelected,
        'date_up': dateUpSelected,
        'description': descC.text,
      };
      // List<http.MultipartFile> files = [];
      // if (pasPhotoPic != null) {
      //   files.add(await getMultipart('pas_photo', File(pasPhotoPic!.path)));
      // } else {
      //   throw 'Harap Isi Pas Foto';
      // }
      final response = BaseResponse.from(await post(
        Constant.BASE_API_FULL +
            '/transaction/asset-downtime/${isEdit ? "edit" : "down"}',
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

  Future<void> clearAssetDowntimeForm() async {
    assetC.clear();
    documentDateC.clear();
    upDateC.clear();
    downtime1C.clear();
    downtime2C.clear();
    categoryC.clear();
    categoryV = null;
    descC.clear();
  }
}
