import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mata/src/tower/model/tower_model.dart';
import 'package:mata/utils/utils.dart';
import '../../../common/base/base_controller.dart';
import '../../../common/helper/constant.dart';
import '../../../common/component/custom_dropdown.dart';
import '../../../common/component/custom_textfield.dart';

class DataAddProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> dataAddKey = GlobalKey<FormState>();

  TextEditingController pltaC = TextEditingController();
  TextEditingController noUnitC = TextEditingController();
  TextEditingController genBearingKoplingC = TextEditingController();
  TextEditingController koplingTurbinC = TextEditingController();
  TextEditingController totalC = TextEditingController();
  TextEditingController rasioC = TextEditingController();

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
    noUnitC.clear();
    genBearingKoplingC.clear();
    koplingTurbinC.clear();
    totalC.clear();
    rasioC.clear();
    wDataUpperRow.clear();
    dataUpperC.clear();
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

  onChangedPLTA(String? v) {
    String? selected =
        (towerList ?? []).firstWhere((element) => element?.Id == v)?.Name;
    if (selected != null) {
      selectedTower = v;
      pltaC.text = selected;
      noUnitC.text = v ?? '';
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
      CustomTextField.borderTextField(
          enabled: false,
          readOnly: true,
          controller: noUnitC,
          labelText: "No Unit"),
      Constant.xSizedBox16,
    ];
  }

  onChangedShaft(String v) {
    if (v.trim() == '' && koplingTurbinC.text.isEmpty) {
      totalC.text = '0';
      rasioC.text = '0';
    } else {
      if (v.trim() != '') {
        int value = int.parse(v);
        if (koplingTurbinC.text.isEmpty) {
          totalC.text = "$value";
          rasioC.text = '0';
        } else {
          totalC.text = "${value + int.parse(koplingTurbinC.text)}";
          rasioC.text =
              "${(value / int.parse(totalC.text)).toStringAsFixed(2)}";
        }
      } else {
        totalC.text = "${int.parse(koplingTurbinC.text)}";
        rasioC.text = '0';
      }
    }
  }

  onChangedBearingToKopling(String v) {
    if (v.trim() == '' && koplingTurbinC.text.isEmpty) {
      totalC.text = '0';
      rasioC.text = '0';
    } else {
      if (v.trim() != '') {
        int value = int.parse(v);
        if (koplingTurbinC.text.isEmpty) {
          totalC.text = "$value";
          rasioC.text = '0';
        } else {
          totalC.text = "${value + int.parse(koplingTurbinC.text)}";
          rasioC.text =
              "${(value / int.parse(totalC.text)).toStringAsFixed(2)}";
        }
      } else {
        totalC.text = "${int.parse(koplingTurbinC.text)}";
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
        int value = int.parse(v);
        if (genBearingKoplingC.text.isEmpty) {
          totalC.text = "$value";
          rasioC.text = '0';
        } else {
          totalC.text = "${value + int.parse(genBearingKoplingC.text)}";
          rasioC.text =
              "${(int.parse(koplingTurbinC.text) / int.parse(totalC.text)).toStringAsFixed(2)}";
        }
      } else {
        totalC.text = "${int.parse(genBearingKoplingC.text)}";
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
        onChange: onChangedShaft,
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

  // DATA UPPER
  List<List<TextEditingController>> dataUpperC = [];

  List<TableRow> wDataUpperRow = [];

  generateDataUpperRow() {
    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        wDataUpperRow.add(TableRow(children: [
          Text('\n\n', textAlign: TextAlign.center),
          Text('\n1\n', textAlign: TextAlign.center),
          Text('\n2\n', textAlign: TextAlign.center),
          Text('\n3\n', textAlign: TextAlign.center),
          Text('\n4\n', textAlign: TextAlign.center),
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

  Widget tableForm(BuildContext context) {
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
        Constant.xSizedBox12,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            wDataUpperRow.length + 1,
            (index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                child: InkWell(
                  onTap: index == 0 || index ==1 
                      ? null
                      : () async {
                          // jika ADD BARIS
                          if (index == wDataUpperRow.length) {
                            dataUpperC.add([
                              TextEditingController(),
                              TextEditingController(),
                              TextEditingController(),
                              TextEditingController(),
                            ]);
                            wDataUpperRow.add(TableRow(children: [
                              Text('$index', textAlign: TextAlign.center),
                              CustomTextField.tableTextField(
                                  controller: dataUpperC[index - 1][0]),
                              CustomTextField.tableTextField(
                                  controller: dataUpperC[index - 1][1]),
                              CustomTextField.tableTextField(
                                  controller: dataUpperC[index - 1][2]),
                              CustomTextField.tableTextField(
                                  controller: dataUpperC[index - 1][3]),
                            ]));
                          }
                          // JIKA HAPUS BARIS DI INDEKS TERTENTU
                          else {
                            await Utils.showYesNoDialog(
                              context: context,
                              title: "Konfirmasi",
                              desc: "Apakah Anda Yakin Ingin Hapus Data Ini?",
                              yesCallback: () async {
                                Navigator.pop(context);
                                try {
                                  if (wDataUpperRow.length > 2) {
                                    wDataUpperRow.removeAt(index);
                                    dataUpperC.removeAt(index - 1);
                                  }
                                } catch (e) {
                                  Utils.showFailed(msg: "Gagal hapus data");
                                }
                              },
                              noCallback: () => Navigator.pop(context),
                            );
                          }
                          notifyListeners();
                        },
                  child: Icon(
                    index == wDataUpperRow.length
                        ? Icons.add_circle_rounded
                        : Icons.remove_circle_rounded,
                    color: index == 0 || index == 1
                        ? Colors.white
                        : index == wDataUpperRow.length
                            ? Constant.greenColor
                            : Constant.redColor,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  List<Widget> upperForm(BuildContext context) {
    return [
      Text("Upper", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data upper pada tabel", style: Constant.grayMedium),
      Constant.xSizedBox16,
      tableForm(context),
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
