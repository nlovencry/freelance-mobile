import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mata/common/base/base_response.dart';
import '../../../common/base/base_controller.dart';
import '../../../common/helper/constant.dart';
import '../model/tower_model.dart';
import '../model/tower_create_model.dart';
import '../model/tower_detail_model.dart';

class TowerProvider extends BaseController with ChangeNotifier {
  TowerModel _towerModel = TowerModel();
  TowerModel get towerModel => this._towerModel;
  set towerModel(TowerModel value) => this._towerModel = value;

  Future<TowerModel> fetchTower() async {
    loading(true);
    final response = await get(Constant.BASE_API_FULL + '/towers/master');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TowerModel.fromJson(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future<TowerDetailModel> fetchTowerDetail(int id) async {
    loading(true);
    final response = await put(Constant.BASE_API_FULL + '/towers/$id');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TowerDetailModel.fromJson(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future<TowerCreateModel> createTower() async {
    loading(true);
    final response = await post(Constant.BASE_API_FULL + '/towers');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TowerCreateModel.fromJson(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future<BaseResponse> deleteTower(int id) async {
    loading(true);
    final response = await delete(Constant.BASE_API_FULL + '/towers/$id');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = BaseResponse.from(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }
}
