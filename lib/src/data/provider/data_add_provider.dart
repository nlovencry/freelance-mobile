import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import '../../../utils/utils.dart';
import '../../shaft/view/shaft_view.dart';
import '../model/create_data_param.dart';
import '../../tower/model/tower_model.dart';
import '../../turbine/model/turbine_create_model.dart';
import '../../../common/base/base_controller.dart';
import '../../../common/helper/constant.dart';
import '../../../common/component/custom_dropdown.dart';
import '../../../common/component/custom_textfield.dart';

class DataAddProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> dataAddKey = GlobalKey<FormState>();

  TextEditingController pltaC = TextEditingController();
  TextEditingController genBearingKoplingC = TextEditingController();
  TextEditingController koplingTurbinC = TextEditingController();
  TextEditingController totalC = TextEditingController();
  TextEditingController rasioC = TextEditingController();

  TextEditingController boltQtyC = TextEditingController();
  TextEditingController currentTorqueC = TextEditingController();
  TextEditingController maxTorqueC = TextEditingController();
  TextEditingController differenceQtyC = TextEditingController();

  String? selectedDropdown;
  String? selectedTower;

  TowerModel _towerModel = TowerModel();
  TowerModel get towerModel => this._towerModel;
  set towerModel(TowerModel value) => this._towerModel = value;

  List<TowerModelData?>? _towerList = [];
  List<TowerModelData?>? get towerList => this._towerList;

  set towerList(List<TowerModelData?>? value) {
    this._towerList = value;
    notifyListeners();
  }

  List<String> dropdownList = [
    "Upper",
    "Clutch",
    "Turbine",
  ];
  List<int> selectedUpper = [];

  resetData() {
    pltaC.clear();
    genBearingKoplingC.clear();
    koplingTurbinC.clear();
    totalC.clear();
    rasioC.clear();
    wDataUpperRow.clear();
    wDataClutchRow.clear();
    wDataTurbineRow.clear();
    dataUpperC.clear();
    dataClutchC.clear();
    dataTurbineC.clear();
    selectedTower = null;
  }

  Future<TowerModel> fetchTower(BuildContext context) async {
    loading(true);
    towerModel = TowerModel();
    final response = await get(Constant.BASE_API_FULL + '/towers/master');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TowerModel.fromJson(jsonDecode(response.body));
      towerList = model.Data;
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  TurbineCreateModel _turbineDetailModel = TurbineCreateModel();
  TurbineCreateModel get turbineDetailModel => this._turbineDetailModel;
  set turbineDetailModel(TurbineCreateModel value) =>
      this._turbineDetailModel = value;

  Future<TurbineCreateModel> fetchTurbineDetail(String id) async {
    loading(true);
    final response = await get(Constant.BASE_API_FULL + '/turbines/$id');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TurbineCreateModel.fromJson(jsonDecode(response.body));
      turbineDetailModel = model;
      notifyListeners();
      setDataChartDetail();
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  TurbineCreateModel _turbineLatestModel = TurbineCreateModel();
  TurbineCreateModel get turbineLatestModel => this._turbineLatestModel;
  set turbineLatestModel(TurbineCreateModel value) =>
      this._turbineLatestModel = value;

  Future<TurbineCreateModel> fetchTurbineLatest() async {
    loading(true);
    final response = await get(Constant.BASE_API_FULL + '/turbines/latest');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final model = TurbineCreateModel.fromJson(jsonDecode(response.body));
      turbineLatestModel = model;
      notifyListeners();
      setDataChartLatest();
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  TurbineCreateModel _turbineCreateModel = TurbineCreateModel();
  TurbineCreateModel get turbineCreateModel => this._turbineCreateModel;
  set turbineCreateModel(TurbineCreateModel value) =>
      this._turbineCreateModel = value;

  CreateDataParam? _createDataParam = CreateDataParam();
  CreateDataParam? get createDataParam => this._createDataParam;
  set createDataParam(CreateDataParam? value) => this._createDataParam = value;

  // AC
  List<double> acClutch = [];
  List<double> acTurbine = [];
  List<double> acUpper = [];
  double acCrockedLine = 0.0;
  // BD
  List<double> bdClutch = [];
  List<double> bdTurbine = [];
  List<double> bdUpper = [];
  double bdCrockedLine = 0.0;
  // UPPER
  List<double> upper = [];
  double upperCrockedLine = 0.0;

  double divideUntilTwoDigits(double val) {
    if (val > 10 && val < 100) return val / 10;
    if (val > 100 && val < 1000) return val / 100;
    if (val > 1000 && val < 10000) return val / 1000;
    if (val > 10000 && val < 100000) return val / 10000;
    if (val > 100000 && val < 1000000) return val / 100000;
    return val;
  }

  setDataChart() {
    // AC
    final acData = turbineCreateModel.Data?.Chart?.AC;
    final acCrockness = turbineCreateModel.Data?.ACCrockedness;
    final bdData = turbineCreateModel.Data?.Chart?.BD;
    final bdCrockness = turbineCreateModel.Data?.BDCrockedness;
    final upperData = turbineCreateModel.Data?.Chart?.Upper;
    final upperCrockness = turbineCreateModel.Data?.TotalCrockedness;
    if (acData != null && acData.Upper != null)
      acUpper = acData.Upper!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (acData != null && acData.Clutch != null)
      acClutch = acData.Clutch!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (acData != null && acData.Turbine != null) {
      acTurbine = acData.Turbine!.split('|').map((e) {
        double num = divideUntilTwoDigits(double.tryParse(e) ?? 0);
        if (num > 0) return num;
        return num;
      }).toList();
      acTurbine[1] = -acTurbine[1];
    }
    // BD
    if (bdData != null && bdData.Upper != null)
      bdUpper = bdData.Upper!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (bdData != null && bdData.Clutch != null)
      bdClutch = bdData.Clutch!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (bdData != null && bdData.Turbine != null) {
      bdTurbine = bdData.Turbine!.split('|').map((e) {
        double num = divideUntilTwoDigits(double.tryParse(e) ?? 0);
        if (num > 0) return num;
        return num;
      }).toList();

      bdTurbine[1] = -bdTurbine[1];
    }
    if (upperData != null)
      upper = upperData
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();

    acCrockedLine = divideUntilTwoDigits(acCrockness ?? 0);
    bdCrockedLine = divideUntilTwoDigits(bdCrockness ?? 0);
    upperCrockedLine = divideUntilTwoDigits(upperCrockness ?? 0);
    log("AC UPPER : $acUpper");
    log("AC CLUTCH : $acClutch");
    log("AC TURBINE : $acTurbine");
    log("AC CROCKED : $acCrockedLine");

    ///
    log("BD UPPER : $bdUpper");
    log("BD CLUTCH : $bdClutch");
    log("BD TURBINE : $bdTurbine");
    log("BD CROCKED : $bdCrockedLine");
    // UPPER
    log("UPPER : $upper");
    log("UPPER CROCKED : $upperCrockedLine");
  }

  setDataChartDetail() {
    // AC
    final acData = turbineDetailModel.Data?.Chart?.AC;
    final acCrockness = turbineDetailModel.Data?.ACCrockedness;
    final bdData = turbineDetailModel.Data?.Chart?.BD;
    final bdCrockness = turbineDetailModel.Data?.BDCrockedness;
    final upperData = turbineDetailModel.Data?.Chart?.Upper;
    final upperCrockness = turbineDetailModel.Data?.TotalCrockedness;
    if (acData != null && acData.Upper != null)
      acUpper = acData.Upper!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (acData != null && acData.Clutch != null)
      acClutch = acData.Clutch!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (acData != null && acData.Turbine != null) {
      acTurbine = acData.Turbine!.split('|').map((e) {
        double num = divideUntilTwoDigits(double.tryParse(e) ?? 0);
        if (num > 0) return num;
        return num;
      }).toList();
      acTurbine[1] = -acTurbine[1];
    }
    // BD
    if (bdData != null && bdData.Upper != null)
      bdUpper = bdData.Upper!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (bdData != null && bdData.Clutch != null)
      bdClutch = bdData.Clutch!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (bdData != null && bdData.Turbine != null) {
      bdTurbine = bdData.Turbine!.split('|').map((e) {
        double num = divideUntilTwoDigits(double.tryParse(e) ?? 0);
        if (num > 0) return num;
        return num;
      }).toList();

      bdTurbine[1] = -bdTurbine[1];
    }
    if (upperData != null)
      upper = upperData
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();

    acCrockedLine = divideUntilTwoDigits(acCrockness ?? 0);
    bdCrockedLine = divideUntilTwoDigits(bdCrockness ?? 0);
    upperCrockedLine = divideUntilTwoDigits(upperCrockness ?? 0);
    log("AC UPPER : $acUpper");
    log("AC CLUTCH : $acClutch");
    log("AC TURBINE : $acTurbine");
    log("AC CROCKED : $acCrockedLine");

    ///
    log("BD UPPER : $bdUpper");
    log("BD CLUTCH : $bdClutch");
    log("BD TURBINE : $bdTurbine");
    log("BD CROCKED : $bdCrockedLine");
    // UPPER
    log("UPPER : $upper");
    log("UPPER CROCKED : $upperCrockedLine");
  }

  setDataChartLatest() {
    // AC
    final acData = turbineLatestModel.Data?.Chart?.AC;
    final acCrockness = turbineLatestModel.Data?.ACCrockedness;
    final bdData = turbineLatestModel.Data?.Chart?.BD;
    final bdCrockness = turbineLatestModel.Data?.BDCrockedness;
    final upperData = turbineLatestModel.Data?.Chart?.Upper;
    final upperCrockness = turbineLatestModel.Data?.TotalCrockedness;
    if (acData != null && acData.Upper != null)
      acUpper = acData.Upper!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (acData != null && acData.Clutch != null)
      acClutch = acData.Clutch!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (acData != null && acData.Turbine != null) {
      acTurbine = acData.Turbine!.split('|').map((e) {
        double num = divideUntilTwoDigits(double.tryParse(e) ?? 0);
        if (num > 0) return num;
        return num;
      }).toList();
      acTurbine[1] = -acTurbine[1];
    }
    // BD
    if (bdData != null && bdData.Upper != null)
      bdUpper = bdData.Upper!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (bdData != null && bdData.Clutch != null)
      bdClutch = bdData.Clutch!
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();
    if (bdData != null && bdData.Turbine != null) {
      bdTurbine = bdData.Turbine!.split('|').map((e) {
        double num = divideUntilTwoDigits(double.tryParse(e) ?? 0);
        if (num > 0) return num;
        return num;
      }).toList();

      bdTurbine[1] = -bdTurbine[1];
    }
    if (upperData != null)
      upper = upperData
          .split('|')
          .map((e) => divideUntilTwoDigits(double.tryParse(e) ?? 0))
          .toList();

    acCrockedLine = divideUntilTwoDigits(acCrockness ?? 0);
    bdCrockedLine = divideUntilTwoDigits(bdCrockness ?? 0);
    upperCrockedLine = divideUntilTwoDigits(upperCrockness ?? 0);
    log("AC UPPER : $acUpper");
    log("AC CLUTCH : $acClutch");
    log("AC TURBINE : $acTurbine");
    log("AC CROCKED : $acCrockedLine");

    ///
    log("BD UPPER : $bdUpper");
    log("BD CLUTCH : $bdClutch");
    log("BD TURBINE : $bdTurbine");
    log("BD CROCKED : $bdCrockedLine");
    // UPPER
    log("UPPER : $upper");
    log("UPPER CROCKED : $upperCrockedLine");
  }

  Future<void> sendCreateTurbines(BuildContext context) async {
    try {
      if (await requestPermission(Permission.location)) {
        if (await Geolocator.isLocationServiceEnabled()) {
          final geo = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high)
              .timeout(
            Duration(seconds: 5),
            onTimeout: () async =>
                Future.value((await Geolocator.getLastKnownPosition())),
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          double? lat = prefs.getDouble(Constant.kSetPrefConfigLat) ?? 0;
          double? lon = prefs.getDouble(Constant.kSetPrefConfigLon) ?? 0;
          double? radius = prefs.getDouble(Constant.kSetPrefConfigRadius) ?? 0;
          bool? configStatus =
              prefs.getBool(Constant.kSetPrefConfigStatus) ?? false;
          double distance =
              Geolocator.distanceBetween(geo.latitude, geo.longitude, lat, lon);

          String? radiusType =
              prefs.getString(Constant.kSetPrefConfigRadiusType) ?? 'kilometer';
          if (radiusType == 'meter') {
            distance = distance;
          } else if (radiusType == 'kilometer') {
            distance = distance / 1000;
          }
          log("DISTANCE : $distance");
          log("LAT : ${geo.latitude}");
          log("LON : ${geo.longitude}");
          log("LAT API : ${lat}");
          log("LON API : ${lon}");
          if (geo.latitude != 0 && lat != 0) {
            if (distance <= radius || !configStatus) {
              final response = await createTurbines();
              if (response.Success == true) {
                Utils.showSuccess(msg: response.Message ?? "Sukses");
                await Future.delayed(Duration(seconds: 2));
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => ShaftView()));
              } else {
                Utils.showFailed(msg: response.Message ?? '');
                throw response.Message ?? '';
              }
            } else {
              Utils.showFailed(
                  msg:
                      'Anda berada di luar batas jangkauan ($radius $radiusType)');
              throw 'Anda berada di luar batas jangkauan ($radius $radiusType)';
            }
          } else {
            Utils.showFailed(msg: 'Gagal mendapatkan lokasi');
            throw 'Gagal mendapatkan lokasi';
          }
        } else {
          Utils.showFailed(msg: 'Harap Nyalakan GPS');
          throw 'Izinkan Nyalakan GPS';
        }
      } else {
        Utils.showFailed(msg: 'Harap Izinkan Akses Lokasi GPS');
        throw 'Izinkan Akses Lokasi GPS';
      }
    } catch (e) {
      Utils.showFailed(
          msg: e.toString().toLowerCase().contains("doctype")
              ? "Maaf, Terjadi Galat!"
              : "$e");
      throw e.toString().toLowerCase().contains("doctype")
          ? "Maaf, Terjadi Galat!"
          : "$e";
    }
  }

  Future<TurbineCreateModel> createTurbines() async {
    loading(true);
    createDataParam = CreateDataParam(
        TowerId: selectedTower,
        GenBearingToCoupling: genBearingKoplingC.text,
        CouplingToTurbine: koplingTurbinC.text,
        Data: CreateDataParamData(
            Upper: CreateDataParamDataUpper(A: [], B: [], C: [], D: []),
            Clutch: CreateDataParamDataClutch(A: [], B: [], C: [], D: []),
            Turbine: CreateDataParamDataTurbine(A: [], B: [], C: [], D: [])));
    notifyListeners();
    for (int i = 0; i < dataUpperC.length; i++) {
      final itemA = dataUpperC[i][0];
      final itemB = dataUpperC[i][1];
      final itemC = dataUpperC[i][2];
      final itemD = dataUpperC[i][3];
      createDataParam?.Data?.Upper?.A?.add(double.parse(itemA.text));
      createDataParam?.Data?.Upper?.B?.add(double.parse(itemB.text));
      createDataParam?.Data?.Upper?.C?.add(double.parse(itemC.text));
      createDataParam?.Data?.Upper?.D?.add(double.parse(itemD.text));
    }
    for (int i = 0; i < dataClutchC.length; i++) {
      final itemA = dataClutchC[i][0];
      final itemB = dataClutchC[i][1];
      final itemC = dataClutchC[i][2];
      final itemD = dataClutchC[i][3];
      createDataParam?.Data?.Clutch?.A?.add(double.parse(itemA.text));
      createDataParam?.Data?.Clutch?.B?.add(double.parse(itemB.text));
      createDataParam?.Data?.Clutch?.C?.add(double.parse(itemC.text));
      createDataParam?.Data?.Clutch?.D?.add(double.parse(itemD.text));
    }
    for (int i = 0; i < dataTurbineC.length; i++) {
      final itemA = dataTurbineC[i][0];
      final itemB = dataTurbineC[i][1];
      final itemC = dataTurbineC[i][2];
      final itemD = dataTurbineC[i][3];
      createDataParam?.Data?.Turbine?.A?.add(double.parse(itemA.text));
      createDataParam?.Data?.Turbine?.B?.add(double.parse(itemB.text));
      createDataParam?.Data?.Turbine?.C?.add(double.parse(itemC.text));
      createDataParam?.Data?.Turbine?.D?.add(double.parse(itemD.text));
    }
    log('CREATE DATA PARAM : ${createDataParam?.toJson()}');
    log('CREATE DATA PARAM : ${jsonEncode(createDataParam?.toJson())}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String param = jsonEncode(createDataParam?.toJson());
    prefs.setString(Constant.kSetPrefParamCreateTurbine, param);
    createDataParam = CreateDataParam.fromJson(jsonDecode(param));
    final response = await post(Constant.BASE_API_FULL + '/turbines',
        body: jsonDecode(param));

    if (response.statusCode == 201 || response.statusCode == 200) {
      prefs.remove(Constant.kSetPrefParamCreateTurbine);
      createDataParam = CreateDataParam();
      final model = TurbineCreateModel.fromJson(jsonDecode(response.body));
      turbineCreateModel = model;
      // notifyListeners();
      setDataChart();
      loading(false);
      return model;
    } else {
      final message = jsonDecode(response.body)["Message"];
      loading(false);
      throw Exception(message);
    }
  }

  onChangedPLTA(String? v) {
    String? selected =
        (towerList ?? []).firstWhere((element) => element?.Id == v)?.Name;
    if (selected != null) {
      selectedTower = v;
      pltaC.text = selected;
    }
  }

  List<Widget> detailUnit() {
    return [
      Text("Detail Unit", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data unit", style: Constant.grayMedium),
      Constant.xSizedBox16,
      CustomDropdown.normalDropdown(
        controller: pltaC,
        iconPadding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        contentPadding: EdgeInsets.all(2),
        borderColor: Constant.primaryColor,
        labelText: 'Nama PLTA',
        selectedItem: selectedTower,
        hintText: "Pilih PLTA",
        list: (towerList ?? [])
            .map((e) => DropdownMenuItem(
                child: Text(e?.Name ?? ''), value: e?.Id ?? ''))
            .toList(),
        onChanged: onChangedPLTA,
      ),
      Constant.xSizedBox16,
    ];
  }

  // onChangedShaft(String v) {
  //   if (v.trim() == '' && koplingTurbinC.text.isEmpty) {
  //     totalC.text = '0';
  //     rasioC.text = '0';
  //   } else {
  //     if (v.trim() != '') {
  //       double value = double.tryParse(v) ?? 0;
  //       if (koplingTurbinC.text.isEmpty) {
  //         totalC.text = "$value";
  //         rasioC.text = '0';
  //       } else {
  //         totalC.text =
  //             "${value + (double.tryParse(koplingTurbinC.text) ?? 0)}";
  //         rasioC.text =
  //             "${(value / (double.tryParse(totalC.text) ?? 0)).toStringAsFixed(2)}";
  //       }
  //     } else {
  //       totalC.text = "${double.tryParse(koplingTurbinC.text)}";
  //       rasioC.text = '0';
  //     }
  //   }
  // }

  onChangedBearingToCoupling(String v) {
    if (v.trim() == '' && koplingTurbinC.text.isEmpty) {
      totalC.text = '0';
      rasioC.text = '0';
    } else {
      if (v.trim() != '') {
        double value = double.tryParse(v) ?? 0;
        if (koplingTurbinC.text.isEmpty) {
          totalC.text = "$value";
          rasioC.text = '0';
        } else {
          double total = value + (double.tryParse(koplingTurbinC.text) ?? 0);
          double bearingToCoupling = value;
          double rasio = (bearingToCoupling / total);
          log("GEN BEARING KOPLING : $value");
          log("TOTAL : ${total}");
          log("RASIO : ${rasio}");
          totalC.text = "$total";
          rasioC.text = "${rasio.toStringAsFixed(2)}";
        }
      } else {
        totalC.text = "${double.tryParse(koplingTurbinC.text)}";
        rasioC.text = '0';
      }
    }
  }

  onChangedKoplingToTurbine(String v) {
    if (v.trim() == '' && genBearingKoplingC.text.isEmpty) {
      totalC.text = '0';
      rasioC.text = '0';
    } else {
      if (v.trim() != '') {
        double value = double.tryParse(v) ?? 0;
        if (genBearingKoplingC.text.isEmpty) {
          totalC.text = "$value";
          rasioC.text = '0';
        } else {
          double total =
              value + (double.tryParse(genBearingKoplingC.text) ?? 0);
          double bearingToCoupling =
              double.tryParse(genBearingKoplingC.text) ?? 0;
          double rasio = (bearingToCoupling / total);
          log("GEN BEARING KOPLING : ${genBearingKoplingC.text}");
          log("TOTAL : ${total}");
          log("RASIO : ${rasio}");
          notifyListeners();
          totalC.text = "$total";
          rasioC.text = "${rasio.toStringAsFixed(2)}";
        }
      } else {
        totalC.text = "${double.tryParse(genBearingKoplingC.text)}";
        rasioC.text = '0';
      }
    }
  }

  List<Widget> shaftForm() {
    return [
      Text("Shaft", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data shaft sesuai kolom", style: Constant.grayMedium),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: genBearingKoplingC,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
          FilteringTextInputFormatter.digitsOnly
        ],
        labelText: "Gen. Bearing-Kopling",
        onChange: onChangedBearingToCoupling,
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        controller: koplingTurbinC,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
          FilteringTextInputFormatter.digitsOnly
        ],
        labelText: "Kopling - Turbin",
        onChange: onChangedKoplingToTurbine,
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        enabled: false,
        readOnly: true,
        controller: totalC,
        labelText: "Total",
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        enabled: false,
        readOnly: true,
        controller: rasioC,
        labelText: "Rasio",
      ),
      Constant.xSizedBox16,
    ];
  }

  List<Widget> boltDetailForm() {
    return [
      Text("Detail Baut", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan detail baut", style: Constant.grayMedium),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        required: false,
        controller: boltQtyC,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
          FilteringTextInputFormatter.digitsOnly
        ],
        labelText: "Jumlah Baut",
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        required: false,
        controller: currentTorqueC,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
          FilteringTextInputFormatter.digitsOnly
        ],
        labelText: "Torsi Terkini",
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        required: false,
        controller: maxTorqueC,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
          FilteringTextInputFormatter.digitsOnly
        ],
        labelText: "Max Torsi",
      ),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
        required: false,
        controller: differenceQtyC,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
          FilteringTextInputFormatter.digitsOnly
        ],
        labelText: "Jumlah Selisih",
      ),
      Constant.xSizedBox16,
    ];
  }

  generateAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(Constant.kSetPrefParamCreateTurbine);
    log('CREATE DATA PARAM : $data');
    if (data != null) {
      createDataParam = CreateDataParam.fromJson(jsonDecode(data));
      generateShaftLocalData(createDataParam);
      generateDataUpperRowLocal();
      generateDataClutchRowLocal();
      generateDataTurbineRowLocal();
      notifyListeners();
    } else {
      generateDataUpperRow();
      generateDataClutchRow();
      generateDataTurbineRow();
    }
  }

  generateShaftLocalData(CreateDataParam? data) {
    if (data != null) {
      selectedTower = data.TowerId;
      String? towerName = (towerList ?? [])
          .firstWhere((element) => element?.Id == data.TowerId)
          ?.Name;
      if (towerName != null && towerName != '') pltaC.text = towerName;
      if (data.GenBearingToCoupling != null)
        genBearingKoplingC.text = data.GenBearingToCoupling ?? '';
      if (data.CouplingToTurbine != null)
        koplingTurbinC.text = data.CouplingToTurbine ?? '';
      if ((data.CouplingToTurbine == null || data.CouplingToTurbine == '') &&
          (data.GenBearingToCoupling == '' ||
              data.GenBearingToCoupling == '')) {
        totalC.text = '0';
        rasioC.text = '0';
      } else {
        if (data.CouplingToTurbine?.trim() != '') {
          double value = double.tryParse(data.CouplingToTurbine ?? '0') ?? 0;
          if (genBearingKoplingC.text.isEmpty) {
            totalC.text = "$value";
            rasioC.text = '0';
          } else {
            totalC.text =
                "${value + (double.tryParse(genBearingKoplingC.text) ?? 0)}";
            rasioC.text =
                "${(double.tryParse(koplingTurbinC.text) ?? 0 / (double.tryParse(totalC.text) ?? 0)).toStringAsFixed(2)}";
          }
        } else {
          totalC.text = "${double.tryParse(genBearingKoplingC.text)}";
          rasioC.text = '0';
        }
      }
    }
  }

  // DATA UPPER
  List<List<TextEditingController>> dataUpperC = [];
  List<TableRow> wDataUpperRow = [];

  generateDataUpperRow() {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        wDataUpperRow.add(TableRow(children: [
          Text('\n\n', textAlign: TextAlign.center),
          Text('\nA\n', textAlign: TextAlign.center),
          Text('\nB\n', textAlign: TextAlign.center),
          Text('\nC\n', textAlign: TextAlign.center),
          Text('\nD\n', textAlign: TextAlign.center),
        ]));
      } else {
        dataUpperC.add([
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController()
        ]);
        wDataUpperRow.add(TableRow(children: [
          Text('$i', textAlign: TextAlign.center),
          CustomTextField.tableTextField(controller: dataUpperC[i - 1][0]),
          CustomTextField.tableTextField(controller: dataUpperC[i - 1][1]),
          CustomTextField.tableTextField(controller: dataUpperC[i - 1][2]),
          CustomTextField.tableTextField(controller: dataUpperC[i - 1][3]),
        ]));
      }
    }
  }

  generateDataUpperRowLocal() {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        wDataUpperRow.add(TableRow(children: [
          Text('\n\n', textAlign: TextAlign.center),
          Text('\nA\n', textAlign: TextAlign.center),
          Text('\nB\n', textAlign: TextAlign.center),
          Text('\nC\n', textAlign: TextAlign.center),
          Text('\nD\n', textAlign: TextAlign.center),
        ]));
      } else {
        if (i == 1) {
          dataUpperC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.A?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.A?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.A?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.A?[3]).toString(),
          ]);
        }
        if (i == 2) {
          dataUpperC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.B?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.B?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.B?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.B?[3]).toString(),
          ]);
        }
        if (i == 3) {
          dataUpperC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.C?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.C?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.C?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.C?[3]).toString(),
          ]);
        }
        if (i == 4) {
          dataUpperC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.D?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.D?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.D?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Upper?.D?[3]).toString(),
          ]);
        }
        wDataUpperRow.add(TableRow(children: [
          Text('$i', textAlign: TextAlign.center),
          CustomTextField.tableTextField(controller: dataUpperC[i - 1][0]),
          CustomTextField.tableTextField(controller: dataUpperC[i - 1][1]),
          CustomTextField.tableTextField(controller: dataUpperC[i - 1][2]),
          CustomTextField.tableTextField(controller: dataUpperC[i - 1][3]),
        ]));
      }
    }
  }

  Widget tableFormUpper(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Table(
            border: TableBorder.all(
                color: Constant.borderSearchColor,
                borderRadius: BorderRadius.circular(5)),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: wDataUpperRow,
          ),
        ),
        // Constant.xSizedBox12,
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: List.generate(
        //     wDataUpperRow.length + 1,
        //     (index) {
        //       return Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        //         child: InkWell(
        //           onTap: index == 0 || index == 1
        //               ? null
        //               : () async {
        //                   // jika ADD BARIS
        //                   if (index == wDataUpperRow.length) {
        //                     dataUpperC.add([
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                     ]);
        //                     wDataUpperRow.add(TableRow(children: [
        //                       Text('$index', textAlign: TextAlign.center),
        //                       CustomTextField.tableTextField(
        //                           controller: dataUpperC[index - 1][0]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataUpperC[index - 1][1]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataUpperC[index - 1][2]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataUpperC[index - 1][3]),
        //                     ]));
        //                   }
        //                   // JIKA HAPUS BARIS DI INDEKS TERTENTU
        //                   else {
        //                     await Utils.showYesNoDialog(
        //                       context: context,
        //                       title: "Konfirmasi",
        //                       desc: "Apakah Anda Yakin Ingin Hapus Data Ini?",
        //                       yesCallback: () async {
        //                         Navigator.pop(context);
        //                         try {
        //                           if (wDataUpperRow.length > 2) {
        //                             wDataUpperRow.removeAt(index);
        //                             dataUpperC.removeAt(index - 1);
        //                           }
        //                         } catch (e) {
        //                           Utils.showFailed(msg: "Gagal hapus data");
        //                         }
        //                       },
        //                       noCallback: () => Navigator.pop(context),
        //                     );
        //                   }
        //                   notifyListeners();
        //                 },
        //           child: Icon(
        //             index == wDataUpperRow.length
        //                 ? Icons.add_circle_rounded
        //                 : Icons.remove_circle_rounded,
        //             color: index == 0 || index == 1
        //                 ? Colors.white
        //                 : index == wDataUpperRow.length
        //                     ? Constant.greenColor
        //                     : Constant.redColor,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }

  List<Widget> upperForm(BuildContext context) {
    return [
      Text("Upper", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data upper pada tabel", style: Constant.grayMedium),
      Constant.xSizedBox16,
      tableFormUpper(context),
      // Container(
      //   decoration: BoxDecoration(
      //       border: Border.all(color: Constant.borderSearchColor),
      //       borderRadius: BorderRadius.circular(5)),
      //   child: Column(
      //     children: [
      //       labelNo(),
      //       valueTable(),
      //       valueTable(),
      //       valueTable(),
      //     ],
      //   ),
      // ),
      Constant.xSizedBox16,
    ];
  }

  // DATA CLUTCH /KOPLING
  List<List<TextEditingController>> dataClutchC = [];
  List<TableRow> wDataClutchRow = [];

  generateDataClutchRow() {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        wDataClutchRow.add(TableRow(children: [
          Text('\n\n', textAlign: TextAlign.center),
          Text('\nA\n', textAlign: TextAlign.center),
          Text('\nB\n', textAlign: TextAlign.center),
          Text('\nC\n', textAlign: TextAlign.center),
          Text('\nD\n', textAlign: TextAlign.center),
        ]));
      } else {
        dataClutchC.add([
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController()
        ]);
        wDataClutchRow.add(TableRow(children: [
          Text('$i', textAlign: TextAlign.center),
          CustomTextField.tableTextField(controller: dataClutchC[i - 1][0]),
          CustomTextField.tableTextField(controller: dataClutchC[i - 1][1]),
          CustomTextField.tableTextField(controller: dataClutchC[i - 1][2]),
          CustomTextField.tableTextField(controller: dataClutchC[i - 1][3]),
        ]));
      }
    }
  }

  generateDataClutchRowLocal() {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        wDataClutchRow.add(TableRow(children: [
          Text('\n\n', textAlign: TextAlign.center),
          Text('\nA\n', textAlign: TextAlign.center),
          Text('\nB\n', textAlign: TextAlign.center),
          Text('\nC\n', textAlign: TextAlign.center),
          Text('\nD\n', textAlign: TextAlign.center),
        ]));
      } else {
        if (i == 1) {
          dataClutchC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.A?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.A?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.A?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.A?[3]).toString(),
          ]);
        }
        if (i == 2) {
          dataClutchC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.B?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.B?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.B?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.B?[3]).toString(),
          ]);
        }
        if (i == 3) {
          dataClutchC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.C?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.C?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.C?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.C?[3]).toString(),
          ]);
        }
        if (i == 4) {
          dataClutchC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.D?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.D?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.D?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Clutch?.D?[3]).toString(),
          ]);
        }
        wDataClutchRow.add(TableRow(children: [
          Text('$i', textAlign: TextAlign.center),
          CustomTextField.tableTextField(controller: dataClutchC[i - 1][0]),
          CustomTextField.tableTextField(controller: dataClutchC[i - 1][1]),
          CustomTextField.tableTextField(controller: dataClutchC[i - 1][2]),
          CustomTextField.tableTextField(controller: dataClutchC[i - 1][3]),
        ]));
      }
    }
  }

  Widget tableFormClutch(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Table(
            border: TableBorder.all(
                color: Constant.borderSearchColor,
                borderRadius: BorderRadius.circular(5)),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: wDataClutchRow,
          ),
        ),
        // Constant.xSizedBox12,
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: List.generate(
        //     wDataClutchRow.length + 1,
        //     (index) {
        //       return Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        //         child: InkWell(
        //           onTap: index == 0 || index == 1
        //               ? null
        //               : () async {
        //                   // jika ADD BARIS
        //                   if (index == wDataClutchRow.length) {
        //                     dataClutchC.add([
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                     ]);
        //                     wDataClutchRow.add(TableRow(children: [
        //                       Text('$index', textAlign: TextAlign.center),
        //                       CustomTextField.tableTextField(
        //                           controller: dataClutchC[index - 1][0]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataClutchC[index - 1][1]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataClutchC[index - 1][2]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataClutchC[index - 1][3]),
        //                     ]));
        //                   }
        //                   // JIKA HAPUS BARIS DI INDEKS TERTENTU
        //                   else {
        //                     await Utils.showYesNoDialog(
        //                       context: context,
        //                       title: "Konfirmasi",
        //                       desc: "Apakah Anda Yakin Ingin Hapus Data Ini?",
        //                       yesCallback: () async {
        //                         Navigator.pop(context);
        //                         try {
        //                           if (wDataClutchRow.length > 2) {
        //                             wDataClutchRow.removeAt(index);
        //                             dataClutchC.removeAt(index - 1);
        //                           }
        //                         } catch (e) {
        //                           Utils.showFailed(msg: "Gagal hapus data");
        //                         }
        //                       },
        //                       noCallback: () => Navigator.pop(context),
        //                     );
        //                   }
        //                   notifyListeners();
        //                 },
        //           child: Icon(
        //             index == wDataClutchRow.length
        //                 ? Icons.add_circle_rounded
        //                 : Icons.remove_circle_rounded,
        //             color: index == 0 || index == 1
        //                 ? Colors.white
        //                 : index == wDataClutchRow.length
        //                     ? Constant.greenColor
        //                     : Constant.redColor,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }

  List<Widget> clutchForm(BuildContext context) {
    return [
      Text("Clutch", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data upper pada tabel", style: Constant.grayMedium),
      Constant.xSizedBox16,
      tableFormClutch(context),
      // Container(
      //   decoration: BoxDecoration(
      //       border: Border.all(color: Constant.borderSearchColor),
      //       borderRadius: BorderRadius.circular(5)),
      //   child: Column(
      //     children: [
      //       labelNo(),
      //       valueTable(),
      //       valueTable(),
      //       valueTable(),
      //     ],
      //   ),
      // ),
      Constant.xSizedBox16,
    ];
  }

  // DATA TURBINE
  List<List<TextEditingController>> dataTurbineC = [];
  List<TableRow> wDataTurbineRow = [];

  generateDataTurbineRow() {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        wDataTurbineRow.add(TableRow(children: [
          Text('\n\n', textAlign: TextAlign.center),
          Text('\nA\n', textAlign: TextAlign.center),
          Text('\nB\n', textAlign: TextAlign.center),
          Text('\nC\n', textAlign: TextAlign.center),
          Text('\nD\n', textAlign: TextAlign.center),
        ]));
      } else {
        dataTurbineC.add([
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController()
        ]);
        wDataTurbineRow.add(TableRow(children: [
          Text('$i', textAlign: TextAlign.center),
          CustomTextField.tableTextField(controller: dataTurbineC[i - 1][0]),
          CustomTextField.tableTextField(controller: dataTurbineC[i - 1][1]),
          CustomTextField.tableTextField(controller: dataTurbineC[i - 1][2]),
          CustomTextField.tableTextField(controller: dataTurbineC[i - 1][3]),
        ]));
      }
    }
  }

  generateDataTurbineRowLocal() {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        wDataTurbineRow.add(TableRow(children: [
          Text('\n\n', textAlign: TextAlign.center),
          Text('\nA\n', textAlign: TextAlign.center),
          Text('\nB\n', textAlign: TextAlign.center),
          Text('\nC\n', textAlign: TextAlign.center),
          Text('\nD\n', textAlign: TextAlign.center),
        ]));
      } else {
        if (i == 1) {
          dataTurbineC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.A?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.A?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.A?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.A?[3]).toString(),
          ]);
        }
        if (i == 2) {
          dataTurbineC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.B?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.B?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.B?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.B?[3]).toString(),
          ]);
        }
        if (i == 3) {
          dataTurbineC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.C?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.C?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.C?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.C?[3]).toString(),
          ]);
        }
        if (i == 4) {
          dataTurbineC.add([
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.D?[0]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.D?[1]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.D?[2]).toString(),
            TextEditingController()
              ..text = (createDataParam?.Data?.Turbine?.D?[3]).toString(),
          ]);
        }
        wDataTurbineRow.add(TableRow(children: [
          Text('$i', textAlign: TextAlign.center),
          CustomTextField.tableTextField(controller: dataTurbineC[i - 1][0]),
          CustomTextField.tableTextField(controller: dataTurbineC[i - 1][1]),
          CustomTextField.tableTextField(controller: dataTurbineC[i - 1][2]),
          CustomTextField.tableTextField(controller: dataTurbineC[i - 1][3]),
        ]));
      }
    }
  }

  Widget tableFormTurbine(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Table(
            border: TableBorder.all(
                color: Constant.borderSearchColor,
                borderRadius: BorderRadius.circular(5)),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: wDataTurbineRow,
          ),
        ),
        // Constant.xSizedBox12,
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: List.generate(
        //     wDataTurbineRow.length + 1,
        //     (index) {
        //       return Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        //         child: InkWell(
        //           onTap: index == 0 || index == 1
        //               ? null
        //               : () async {
        //                   // jika ADD BARIS
        //                   if (index == wDataTurbineRow.length) {
        //                     dataTurbineC.add([
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                       TextEditingController(),
        //                     ]);
        //                     wDataTurbineRow.add(TableRow(children: [
        //                       Text('$index', textAlign: TextAlign.center),
        //                       CustomTextField.tableTextField(
        //                           controller: dataTurbineC[index - 1][0]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataTurbineC[index - 1][1]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataTurbineC[index - 1][2]),
        //                       CustomTextField.tableTextField(
        //                           controller: dataTurbineC[index - 1][3]),
        //                     ]));
        //                   }
        //                   // JIKA HAPUS BARIS DI INDEKS TERTENTU
        //                   else {
        //                     await Utils.showYesNoDialog(
        //                       context: context,
        //                       title: "Konfirmasi",
        //                       desc: "Apakah Anda Yakin Ingin Hapus Data Ini?",
        //                       yesCallback: () async {
        //                         Navigator.pop(context);
        //                         try {
        //                           if (wDataTurbineRow.length > 2) {
        //                             wDataTurbineRow.removeAt(index);
        //                             dataTurbineC.removeAt(index - 1);
        //                           }
        //                         } catch (e) {
        //                           Utils.showFailed(msg: "Gagal hapus data");
        //                         }
        //                       },
        //                       noCallback: () => Navigator.pop(context),
        //                     );
        //                   }
        //                   notifyListeners();
        //                 },
        //           child: Icon(
        //             index == wDataTurbineRow.length
        //                 ? Icons.add_circle_rounded
        //                 : Icons.remove_circle_rounded,
        //             color: index == 0 || index == 1
        //                 ? Colors.white
        //                 : index == wDataTurbineRow.length
        //                     ? Constant.greenColor
        //                     : Constant.redColor,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }

  List<Widget> turbineForm(BuildContext context) {
    return [
      Text("Turbine", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data upper pada tabel", style: Constant.grayMedium),
      Constant.xSizedBox16,
      tableFormTurbine(context),
      // Container(
      //   decoration: BoxDecoration(
      //       border: Border.all(color: Constant.borderSearchColor),
      //       borderRadius: BorderRadius.circular(5)),
      //   child: Column(
      //     children: [
      //       labelNo(),
      //       valueTable(),
      //       valueTable(),
      //       valueTable(),
      //     ],
      //   ),
      // ),
      Constant.xSizedBox16,
    ];
  }

  Widget labelNo() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "1",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "2",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "3",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "4",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget valueTable() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "1",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "50",
              textAlign: TextAlign.center,
              style: TextStyle(color: Constant.borderRegularColor),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "48",
              textAlign: TextAlign.center,
              style: TextStyle(color: Constant.borderRegularColor),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "46",
              textAlign: TextAlign.center,
              style: TextStyle(color: Constant.borderRegularColor),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.borderLightColor),
            ),
            child: Text(
              "55",
              textAlign: TextAlign.center,
              style: TextStyle(color: Constant.borderRegularColor),
            ),
          ),
        ),
      ],
    );
  }
}
