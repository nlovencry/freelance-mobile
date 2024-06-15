import 'dart:convert';
import 'dart:developer';

import 'package:mata/common/base/base_controller.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends BaseController with ChangeNotifier {
  String isSubAgent = "agen";
  String get getIsSubAgent => this.isSubAgent;
  HomeModel homeModel = HomeModel();

  HomeModel get getHomeModel => this.homeModel;

  set setHomeModel(HomeModel homeModel) => this.homeModel = homeModel;
  set setIsSubAgent(String isSubAgent) => this.isSubAgent = isSubAgent;

  Future<void> fetchHome({bool withLoading = false}) async {
    if (withLoading) loading(true);

    final response =
        await post(Constant.BASE_API_FULL + '/dashboard/dashboard/get');

    if (response.statusCode == 201 || response.statusCode == 200) {
      setHomeModel = HomeModel.fromJson(jsonDecode(response.body));
      notifyListeners();

      if (withLoading) loading(false);
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }
}
