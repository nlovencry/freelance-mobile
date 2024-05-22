import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bimops/common/base/base_controller.dart';
import 'package:bimops/common/base/base_response.dart';
import 'package:bimops/common/helper/constant.dart';
import 'package:bimops/src/notifikasi/model/notifikasi_model.dart';
import 'package:bimops/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/helper/encrypt.dart';
import '../model/notif_count_model.dart';
import '../model/notifikasi_view_model.dart';

class NotifikasiProvider extends BaseController with ChangeNotifier {
  NotifikasiModel _notifikasiModel = NotifikasiModel();

  bool _isNeed = false;
  bool get isNeed => this._isNeed;

  set isNeed(bool value) {
    this._isNeed = value;
    notifyListeners();
  }

  NotifikasiModel get notifikasiModel => this._notifikasiModel;

  set notifikasiModel(NotifikasiModel value) => this._notifikasiModel = value;
  NotifikasiModel _notifikasiModel2 = NotifikasiModel();

  NotifikasiModel get notifikasiModel2 => this._notifikasiModel2;

  set notifikasiModel2(NotifikasiModel value) => this._notifikasiModel2 = value;

  PagingController<int, NotifikasiModelData> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, NotifikasiModelData> get pagingController =>
      this._pagingController;

  set pagingController(PagingController<int, NotifikasiModelData> value) {
    this._pagingController = value;
  }

  PagingController<int, NotifikasiModelData> _pagingController2 =
      PagingController(firstPageKey: 1);

  PagingController<int, NotifikasiModelData> get pagingController2 =>
      this._pagingController2;

  set pagingController2(PagingController<int, NotifikasiModelData> value) {
    this._pagingController2 = value;
  }

  bool _isFetching = false;
  bool get isFetching => this._isFetching;

  set isFetching(bool value) {
    this._isFetching = value;
  }

  bool _isFetching2 = false;
  bool get isFetching2 => this._isFetching2;

  set isFetching2(bool value) {
    this._isFetching2 = value;
  }

  int pageSize = 0;

  get getPageSize => this.pageSize;

  set setPageSize(pageSize) {
    this.pageSize;
  }

  int pageSize2 = 0;

  get getPageSize2 => this.pageSize2;

  set setPageSize2(pageSize) {
    this.pageSize2;
  }

  Future<void> fetchNotif({bool withLoading = false, required int page}) async {
    if (!isFetching) {
      isFetching = true;
      if (withLoading) loading(true);
      Map<String, String> param = {'page': '$page', 'tab': 'NeedAction'};

      final response = await post(
          Constant.BASE_API_FULL + '/notification/notif/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = NotifikasiModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          pagingController
              .appendLastPage(newItems as List<NotifikasiModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController.appendPage(
              newItems as List<NotifikasiModelData>, nextPageKey);
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

  Future<void> fetchNotif2(
      {bool withLoading = false, required int page}) async {
    if (!isFetching2) {
      isFetching2 = true;
      if (withLoading) loading(true);
      Map<String, String> param = {'page': '$page', 'tab': 'ActionComplate'};

      final response = await post(
          Constant.BASE_API_FULL + '/notification/notif/get',
          body: param);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = NotifikasiModel.fromJson(jsonDecode(response.body));

        final newItems = model.data ?? [];

        final previouslyFetchedWordCount =
            _pagingController.itemList?.length ?? 0;
        pageSize2 = 10;
        log("ITEMS LENGTH : ${newItems.length}");
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          pagingController2
              .appendLastPage(newItems as List<NotifikasiModelData>);
        } else {
          final nextPageKey = page += 1;
          pagingController2.appendPage(
              newItems as List<NotifikasiModelData>, nextPageKey);
        }

        // notifyListeners();
        if (withLoading) loading(false);
        isFetching2 = false;
      } else {
        final message = jsonDecode(response.body)["message"];
        loading(false);
        isFetching2 = false;
        throw Exception(message);
      }
    }
  }

  NotifikasiViewModel notifikasiViewModel = NotifikasiViewModel();

  get getNotifikasiViewModel => this.notifikasiViewModel;

  set setNotifikasiViewModel(notifikasiViewModel) {
    this.notifikasiViewModel = notifikasiViewModel;
    notifyListeners();
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

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    log("Start download file from internet!");
    try {
      final String url = notifikasiViewModel.data?.pdfFile ?? "-";
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
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<void> fetchViewNotif({
    bool withLoading = false,
    required String id,
    required String type,
  }) async {
    if (withLoading) loading(true);
    controller = Completer<PDFViewController>();
    pages = 1;
    currentPage = 1;
    isReady = false;
    errorMessage = '';
    remotePDFpath = '';
    notifikasiViewModel = NotifikasiViewModel();
    String encodedId = Encrypt().encode64(id);
    Map<String, String> param = {'id': encodedId, 'type': type};

    final response = await post(
        Constant.BASE_API_FULL + '/notification/notif/view',
        body: param);

    if (response.statusCode == 201 || response.statusCode == 200) {
      notifikasiViewModel =
          NotifikasiViewModel.fromJson(jsonDecode(response.body));
      remotePDFpath = notifikasiViewModel.data?.pdfFile ?? "";
      notifyListeners();
      isFetching = false;
    } else {
      final message = jsonDecode(response.body)["message"];
      loading(false);
      throw Exception(message);
    }
  }

  TextEditingController noteC = TextEditingController();
  FocusNode noteN = FocusNode();

  Future<void> approveRejectWO(
      {required String type, required String id}) async {
    loading(true);
    FocusManager.instance.primaryFocus?.unfocus();
    String encodedId = Encrypt().encode64(id);
    Map<String, String> param = {'id': encodedId, 'note': noteC.text};
    final response = BaseResponse.from(await post(
        Constant.BASE_API_FULL +
            '/utilities/approval/${type == "approve" ? "approve" : "reject"}WO',
        body: param));

    if (response.success) {
      loading(false);
    } else {
      loading(false);
      throw Exception(response.message);
    }
  }

  NotifCountModel _notifCountModel = NotifCountModel();
  NotifCountModel get notifCountModel => this._notifCountModel;

  set notifCountModel(NotifCountModel value) {
    this._notifCountModel = value;
    notifyListeners();
  }

  Future<void> fetchNotifCount({bool withLoading = false}) async {
    if (withLoading) loading(true);

    final response =
        await post(Constant.BASE_API_FULL + '/notification/notif/count');

    if (response.statusCode == 201 || response.statusCode == 200) {
      notifCountModel = NotifCountModel.fromJson(jsonDecode(response.body));
      notifyListeners();

      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["message"];
      loading(false);
      throw Exception(message);
    }
  }
}
