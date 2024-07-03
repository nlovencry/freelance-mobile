import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hy_tutorial/src/data/provider/data_add_provider.dart';
import 'package:provider/provider.dart';
import '../../../common/base/base_response.dart';
import '../../../common/base/base_controller.dart';
import '../../../common/component/custom_textfield.dart';
import '../../../common/helper/constant.dart';
import '../model/tower_model.dart';
import '../model/tower_create_model.dart';
import '../model/tower_detail_model.dart';

class TowerProvider extends BaseController with ChangeNotifier {
  TowerModel _towerModel = TowerModel();
  TowerModel get towerModel => this._towerModel;
  set towerModel(TowerModel value) => this._towerModel = value;

  TextEditingController searchC = TextEditingController();

  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
  }

  Widget search(BuildContext context) => CustomTextField.borderTextField(
        controller: searchC,
        required: false,
        hintText: "Search",
        hintColor: Constant.textHintColor,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/icons/ic-search.png',
            width: 5,
            height: 5,
          ),
        ),
        onChange: (val) {
          if (searchOnStoppedTyping != null) {
            searchOnStoppedTyping!.cancel();
          }
          searchOnStoppedTyping = Timer(duration, () {
            fetchTower(context);
          });
        },
      );

  Future<TowerModel> fetchTower(BuildContext context) async {
    loading(true);
    towerModel = TowerModel();
    final response = await get(Constant.BASE_API_FULL + '/towers/master');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TowerModel.fromJson(jsonDecode(response.body));
      context.read<DataAddProvider>().towerList = model.Data;
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
