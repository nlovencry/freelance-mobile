import 'package:flutter/material.dart';
import 'package:mata/src/tower/model/tower_model.dart';
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
          onChanged: (val) {
            String? selected = (towerList ?? [])
                .firstWhere((element) => element?.Id == val)
                ?.Name;
            if (selected != null) {
              selectedTower = selected;
              pltaC.text = selected;
              noUnitC.text = val ?? '';
            }
          }),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
          enabled: false,
          readOnly: true,
          controller: noUnitC,
          labelText: "No Unit"),
      Constant.xSizedBox16,
    ];
  }

  List<Widget> shaftForm() {
    return [
      Text("Shaft", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data shaft sesuai kolom", style: Constant.grayMedium),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
          controller: genBearingKoplingC, labelText: "Gen. Bearing-Kopling"),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
          controller: koplingTurbinC, labelText: "Kopling - Turbin"),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(controller: totalC, labelText: "Total"),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(controller: rasioC, labelText: "Rasio"),
      Constant.xSizedBox16,
    ];
  }

  List<Widget> upperForm() {
    return [
      Text("Upper", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 8,
              child: Text("Masukan data upper pada tabel",
                  style: Constant.grayMedium)),
          Expanded(
            flex: 6,
            child: CustomDropdown.normalDropdown(
                iconPadding: const EdgeInsets.fromLTRB(0, 0, 4, 64),
                padding: EdgeInsets.only(left: 16),
                contentPadding: EdgeInsets.all(2),
                borderColor: Constant.primaryColor,
                selectedItem: selectedDropdown,
                hintText: "Pilih Item",
                list: dropdownList
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (val) {
                  selectedDropdown = val;
                }),
          ),
        ],
      ),
      Constant.xSizedBox16,
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: Constant.borderSearchColor),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            labelNo(),
            valueTable(),
            valueTable(),
            valueTable(),
          ],
        ),
      ),
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
