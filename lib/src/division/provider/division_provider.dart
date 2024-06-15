import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../common/base/base_controller.dart';
import '../model/divison_model.dart';
import '../../../common/helper/constant.dart';

class DivisionProvider extends BaseController with ChangeNotifier {
  DivisionModel _divisionModel = DivisionModel();
  DivisionModel get divisionModel => this._divisionModel;
  set divisionModel(DivisionModel value) => this._divisionModel = value;

  Future<DivisionModel> fetchDivision() async {
    loading(true);
    final response = await get(Constant.BASE_API_FULL + '/divisions/master');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = DivisionModel.fromJson(jsonDecode(response.body));
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }
}
