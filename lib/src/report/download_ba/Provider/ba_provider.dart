import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mata/common/base/base_controller.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../common/helper/encrypt.dart';
import '../model/ba_model.dart';
import '../model/view_ba_model.dart';

class BAProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> createBAKey = GlobalKey<FormState>();

  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
  }

  PagingController<int, BAModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, BAModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, BAModelData> value) {
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

  TextEditingController _baSearchC = TextEditingController();
  TextEditingController get baSearchC => this._baSearchC;
  set baSearchC(TextEditingController value) => this._baSearchC = value;

  FocusNode descNode = FocusNode();

  String? _workTypeV;

  String? get workTypeV => this._workTypeV;

  set workTypeV(String? value) {
    this._workTypeV = value;
    notifyListeners();
  }

  BAModel baModel = BAModel();

  BAModel get getBAModel => this.baModel;

  set setBAModel(BAModel baModel) => this.baModel = baModel;

  Future<void> fetchBA({
    bool withLoading = false,
    required int page,
    String keyword = "",
  }) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {
        'page': '$page',
        'search': baSearchC.text,
      };

      final response = await post(
          Constant.BASE_API_FULL + '/report/download-ba/list',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = BAModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          pagingController.appendLastPage(newItems as List<BAModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController.appendPage(
              newItems as List<BAModelData>, nextPageKey);
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

  ViewBAModel _viewBAModel = ViewBAModel();

  ViewBAModel get viewBAModel => this._viewBAModel;

  set viewBAModel(ViewBAModel value) {
    this._viewBAModel = value;
    notifyListeners();
  }

  Future<void> fetchViewBA({
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
          Constant.BASE_API_FULL + '/report/download-ba/view',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        viewBAModel = ViewBAModel.fromJson(jsonDecode(response.body));
        remotePDFpath = viewBAModel.data?.pdfPersetujuan ?? "";
        remotePDFpath2 = viewBAModel.data?.pdfRealisasi ?? "";
        notifyListeners();
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

  Completer<PDFViewController> _controller = Completer<PDFViewController>();
  Completer<PDFViewController> get controller => this._controller;

  set controller(Completer<PDFViewController> value) =>
      this._controller = value;
  Completer<PDFViewController> _controller2 = Completer<PDFViewController>();
  Completer<PDFViewController> get controller2 => this._controller2;

  set controller2(Completer<PDFViewController> value) =>
      this._controller2 = value;

  int? _pages = 1;
  int? _pages2 = 1;
  int? _currentPage = 1;
  int? _currentPage2 = 1;
  bool _isReady = false;
  bool _isReady2 = false;
  String _errorMessage = '';
  String _errorMessage2 = '';
  int? get pages => this._pages;

  set pages(int? value) => this._pages = value;
  int? get pages2 => this._pages2;

  set pages2(int? value) => this._pages2 = value;

  int? get currentPage => this._currentPage;

  set currentPage(int? value) => this._currentPage = value;
  int? get currentPage2 => this._currentPage2;

  set currentPage2(int? value) => this._currentPage2 = value;

  bool get isReady => this._isReady;

  set isReady(bool value) => this._isReady = value;
  bool get isReady2 => this._isReady2;

  set isReady2(bool value) => this._isReady2 = value;

  String get errorMessage => this._errorMessage;

  set errorMessage(String value) => this._errorMessage = value;
  String get errorMessage2 => this._errorMessage2;

  set errorMessage2(String value) => this._errorMessage2 = value;

  String _remotePDFpath = "";
  String get remotePDFpath => this._remotePDFpath;

  set remotePDFpath(String value) {
    this._remotePDFpath = value;
    notifyListeners();
  }

  String _remotePDFpath2 = "";
  String get remotePDFpath2 => this._remotePDFpath2;

  set remotePDFpath2(String value) {
    this._remotePDFpath2 = value;
    notifyListeners();
  }

  Future<File> createFileOfPdfUrlPersetujuan() async {
    Completer<File> completer = Completer();
    log("Start download file from internet!");
    // try {
    final String url = viewBAModel.data?.pdfPersetujuan ?? "-";
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
    // } catch (e) {
    //   throw Exception('Error parsing asset file!');
    // }

    return completer.future;
  }

  Future<File> createFileOfPdfUrlRealisasi() async {
    Completer<File> completer = Completer();
    log("Start download file from internet!");
    // try {
    final String url = viewBAModel.data?.pdfRealisasi ?? "-";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    log("Download files");
    log("${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    remotePDFpath2 = file.path;
    completer.complete(file);
    // } catch (e) {
    //   throw Exception('Error parsing asset file!');
    // }

    return completer.future;
  }
}
