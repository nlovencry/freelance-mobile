import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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

  bool _isEdit = false;
  bool get isEdit => this._isEdit;

  set isEdit(bool value) {
    this._isEdit = value;
    notifyListeners();
  }

  TextEditingController turbineSearchC = TextEditingController();

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
      Map<String, String> param = {
        'Page': '$page',
        'Search': turbineSearchC.text,
        'PerPage': "10",
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
