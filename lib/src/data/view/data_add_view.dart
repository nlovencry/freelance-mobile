import 'package:mata/common/component/custom_dropdown.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/data/provider/data_add_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mata/src/shaft/view/shaft_view.dart';
import 'package:provider/provider.dart';
import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_button.dart';
import 'package:mata/common/component/custom_navigator.dart';
import 'package:mata/common/component/custom_textfield.dart';

class DataAddView extends StatefulWidget {
  const DataAddView({super.key});

  @override
  State<DataAddView> createState() => _DataAddViewState();
}

class _DataAddViewState extends State<DataAddView> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<DataAddProvider>();
    List<Widget> shaftForm = [
      Text("Shaft", style: Constant.blackBold20),
      Constant.xSizedBox8,
      Text("Masukan data shaft sesuai kolom", style: Constant.grayMedium),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
          controller: p.genBearingKoplingC, labelText: "Gen. Bearing-Kopling"),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(
          controller: p.koplingTurbinC, labelText: "Kopling - Turbin"),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(controller: p.totalC, labelText: "Total"),
      Constant.xSizedBox16,
      CustomTextField.borderTextField(controller: p.rasioC, labelText: "Rasio"),
      Constant.xSizedBox16,
    ];

    Widget labelNo = Row(
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

    ;
    List<Widget> upperForm = [
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
                selectedItem: p.selectedDropdown,
                hintText: "Pilih Item",
                list: p.dropdownList
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (val) {
                  p.selectedDropdown = val;
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
            labelNo,
            valueTable(),
            valueTable(),
            valueTable(),
          ],
        ),
      ),
      Constant.xSizedBox16,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Tambah Data"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...shaftForm,
                  ...upperForm,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: CustomButton.mainButton('Simpan', () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => ShaftView()));
              }),
            )
          ],
        ),
      ),
    );
  }
}
