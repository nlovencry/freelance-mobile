import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hy_tutorial/common/base/base_controller.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/report/asset_performance/model/asset_performance_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../common/base/base_response.dart';
import '../../../../common/helper/encrypt.dart';
import '../model/pdf_asset_performance_model.dart';
import '../model/view_asset_performance_model.dart';

class AssetPerformanceProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> createAssetPerformanceKey = GlobalKey<FormState>();

  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
  }

  PagingController<int, AssetPerformanceModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, AssetPerformanceModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, AssetPerformanceModelData> value) {
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

  TextEditingController _assetPerformanceSearchC = TextEditingController();
  TextEditingController get assetPerformanceSearchC =>
      this._assetPerformanceSearchC;
  set assetPerformanceSearchC(TextEditingController value) =>
      this._assetPerformanceSearchC = value;

  FocusNode descNode = FocusNode();

  String? _workTypeV;

  String? get workTypeV => this._workTypeV;

  set workTypeV(String? value) {
    this._workTypeV = value;
    notifyListeners();
  }

  AssetPerformanceModel assetPerformanceModel = AssetPerformanceModel();

  AssetPerformanceModel get getAssetPerformanceModel =>
      this.assetPerformanceModel;

  set setAssetPerformanceModel(AssetPerformanceModel assetPerformanceModel) =>
      this.assetPerformanceModel = assetPerformanceModel;

  Future<void> fetchAssetPerformance({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': assetPerformanceSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/report/asset-performence/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = AssetPerformanceModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          pagingController
              .appendLastPage(newItems as List<AssetPerformanceModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController.appendPage(
              newItems as List<AssetPerformanceModelData>, nextPageKey);
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

  ViewAssetPerformanceModel _viewAssetPerformanceModel =
      ViewAssetPerformanceModel();

  ViewAssetPerformanceModel get viewAssetPerformanceModel =>
      this._viewAssetPerformanceModel;

  set viewAssetPerformanceModel(ViewAssetPerformanceModel value) {
    this._viewAssetPerformanceModel = value;
    notifyListeners();
  }

  Future<void> fetchViewAssetPerformance({
    bool withLoading = false,
    required String id,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);

      String encodedId = Encrypt().encode64(id);
      Map<String, String> param = {'id': encodedId};

      final response = await post(
          Constant.BASE_API_FULL + '/report/asset-performence/view',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        viewAssetPerformanceModel =
            ViewAssetPerformanceModel.fromJson(jsonDecode(response.body));
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

  PDFAssetPerformanceModel _pdfAssetPerformanceModel =
      PDFAssetPerformanceModel();
  PDFAssetPerformanceModel get pdfAssetPerformanceModel =>
      this._pdfAssetPerformanceModel;

  set pdfAssetPerformanceModel(PDFAssetPerformanceModel value) {
    this._pdfAssetPerformanceModel = value;
    notifyListeners();
  }

  Future<void> fetchPDFAssetPerformance({
    bool withLoading = false,
    required String id,
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);

      String encodedId = Encrypt().encode64(id);
      Map<String, String> param = {'id': encodedId};

      final response = await post(
          Constant.BASE_API_FULL + '/report/asset-performence/pdf',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        pdfAssetPerformanceModel =
            PDFAssetPerformanceModel.fromJson(jsonDecode(response.body));
        remotePDFpath = pdfAssetPerformanceModel.data?.pdfFile ?? "";
        notifyListeners();
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

  Future<void> action({required String type, String note = ""}) async {
    loading(true);
    String encodedId =
        Encrypt().encode64(viewAssetPerformanceModel.data?.id ?? "0");
    Map<String, String> param = {'id': encodedId};
    if (type == "approve" || type == "void" || type == "reject") {
      // if (note == "") throw 'Harap Lengkapi Keterangan';
      param.addAll({'note': note});
    }
    final response = BaseResponse.from(await post(
        Constant.BASE_API_FULL + '/report/asset-performence/$type',
        body: param));

    if (response.success) {
      loading(false);
    } else {
      loading(false);
      throw Exception(response.message);
    }
  }

  Completer<PDFViewController> _controller = Completer<PDFViewController>();
  Completer<PDFViewController> get controller => this._controller;

  set controller(Completer<PDFViewController> value) =>
      this._controller = value;

  int? _pages = 1;
  int? _currentPage = 1;
  bool _isReady = false;
  String _errorMessage = '';
  int? get pages => this._pages;

  set pages(int? value) => this._pages = value;

  int? get currentPage => this._currentPage;

  set currentPage(int? value) => this._currentPage = value;

  bool get isReady => this._isReady;

  set isReady(bool value) => this._isReady = value;

  String get errorMessage => this._errorMessage;

  set errorMessage(String value) => this._errorMessage = value;

  String _remotePDFpath = "";
  String get remotePDFpath => this._remotePDFpath;

  set remotePDFpath(String value) {
    this._remotePDFpath = value;
    notifyListeners();
  }

  Future<File> createFileOfPdfUrl(PDFViewController pdfViewController) async {
    Completer<File> completer = Completer();
    log("Start download file from internet!");
    // try {
    final String url =
        "https://cdn.syncfusion.com/content/PDF Viewer/flutter-succinctly.pdf";
    // final String url = pdfAssetPerformanceModel.data?.pdfFile ?? "-";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    log("Download files");
    log("${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    remotePDFpath = file.path;
    completer.complete(file);
    controller.complete(pdfViewController);
    notifyListeners();
    // } catch (e) {
    //   throw Exception('Error parsing asset file!');
    // }

    return completer.future;
  }
}
