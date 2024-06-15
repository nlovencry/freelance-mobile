import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../common/base/base_controller.dart';
import '../../../common/helper/constant.dart';
import '../model/turbine_create_model.dart';
import '../model/turbine_detail_model.dart';
import '../model/turbine_model.dart';

class TurbineProvider extends BaseController with ChangeNotifier {
  TurbineModel _turbineModel = TurbineModel();
  TurbineModel get turbineModel => this._turbineModel;
  set turbineModel(TurbineModel value) => this._turbineModel = value;

  Future<TurbineModel> fetchTurbine() async {
    loading(true);
    final response = await get(Constant.BASE_API_FULL + '/turbines');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TurbineModel.fromJson(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  Future<TurbineDetailModel> fetchTurbineDetail(int id) async {
    loading(true);
    final response = await get(Constant.BASE_API_FULL + '/turbines/$id');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TurbineDetailModel.fromJson(jsonDecode(response.body));
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
