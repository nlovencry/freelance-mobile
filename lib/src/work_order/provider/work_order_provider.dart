import 'dart:convert';
import 'dart:developer';

import 'package:hy_tutorial/common/base/base_controller.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/work_order/model/work_order_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkOrderProvider extends BaseController with ChangeNotifier {
  String isSubAgent = "agen";
  String get getIsSubAgent => this.isSubAgent;
  WorkOrderModel workOrderModel = WorkOrderModel();

  WorkOrderModel get getWorkOrderModel => this.workOrderModel;

  set setWorkOrderModel(WorkOrderModel workOrderModel) =>
      this.workOrderModel = workOrderModel;
  set setIsSubAgent(String isSubAgent) => this.isSubAgent = isSubAgent;

  Future<void> fetchWorkOrder({bool withLoading = false}) async {
    log("IS SUB AGENT : $getIsSubAgent");
    if (withLoading) loading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setIsSubAgent = prefs.getString(Constant.kSetPrefRoles) ?? "agen";

    final response = await get(Constant.BASE_API_FULL + '/workOrder');

    if (response.statusCode == 201 || response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setWorkOrderModel = WorkOrderModel.fromJson(jsonDecode(response.body));
      notifyListeners();

      if (withLoading) loading(false);
      // return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  TextEditingController searchC = TextEditingController();

  // SearchProductModel searchProductModel = SearchProductModel();

  // SearchProductModel get getSearchProductModel => this.searchProductModel;

  // get searchProductModelData => null;

  // set setSearchProductModel(SearchProductModel searchProductModel) =>
  //     this.searchProductModel = searchProductModel;

  Future<void> fetchSearchProduct({bool withLoading = false}) async {
    if (withLoading) loading(true);

    final response = await get(
      'http://dev-api.sibima.id//product-bar-search',
      body: {'search': searchC.text},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // setSearchProductModel = SearchProductModel.fromJson(jsonDecode(response.body));
      notifyListeners();

      if (withLoading) loading(false);
    } else {
      final message = response.data["message"];
      loading(false);
      throw Exception(message);
    }
  }
}
