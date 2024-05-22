import 'package:bimops/common/component/custom_appbar.dart';
import 'package:bimops/common/component/custom_button.dart';
import 'package:bimops/common/component/custom_navigator.dart';
import 'package:bimops/common/component/custom_textfield.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/base/base_state.dart';
import '../../../../common/component/custom_date_picker.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../provider/asset_downtime_provider.dart';

class CreateAssetDowntimeView extends StatefulWidget {
  final String assetCode;
  final String assetId;
  final String documentDate;
  final String documentDateTime;
  final String upDate;
  final String upDateTime;
  final String description;
  bool isEdit;
  bool isCreate;

  CreateAssetDowntimeView({
    super.key,
    required this.assetCode,
    required this.assetId,
    required this.documentDate,
    required this.documentDateTime,
    required this.upDate,
    required this.upDateTime,
    required this.description,
    this.isEdit = false,
    this.isCreate = false,
  });

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<CreateAssetDowntimeView> createState() =>
      _CreateAssetDowntimeViewState();
}

class _CreateAssetDowntimeViewState extends BaseState<CreateAssetDowntimeView> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    final p = context.read<AssetDowntimeProvider>();
    final data =
        context.read<AssetDowntimeProvider>().assetDowntimeViewModel.data;
    p.assetC.text = widget.assetCode;
    if (widget.documentDate != "") {
      var dateDoc = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.documentDate + " " + widget.documentDateTime);
      var dateDocF = DateTime(dateDoc.year, dateDoc.month, dateDoc.day,
          dateDoc.hour, dateDoc.minute);
      final dateDoc2 = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateDocF);
      p.documentDateC.text = "$dateDoc2";
      p.setDocumentDate(dateDocF);
    }
    if (widget.upDate != "") {
      var dateDoc22 = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.upDate + " " + widget.upDateTime);
      var dateDoc2F = DateTime(dateDoc22.year, dateDoc22.month, dateDoc22.day,
          dateDoc22.hour, dateDoc22.minute);
      final dateDoc222 = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateDoc2F);
      p.upDateC.text = "$dateDoc222";
      p.setUpDate(dateDoc2F);
    }
    if (widget.description != "") p.descC.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    final assetDowntimeP = context.watch<AssetDowntimeProvider>();

    Widget form() {
      return Form(
        key: assetDowntimeP.createAssetKey,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.borderTextField(
                controller: assetDowntimeP.assetC,
                labelText: "Asset",
                hintText: "Asset",
                required: true,
                enabled: false,
                readOnly: !widget.isEdit && !widget.isCreate,
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              Constant.xSizedBox16,
              CustomTextField.borderTextField(
                controller: assetDowntimeP.documentDateC,
                labelText: "Document Date",
                hintText: "Document Date",
                required: true,
                readOnly: true,
                onTap: !widget.isEdit && !widget.isCreate
                    ? null
                    : () async {
                        await assetDowntimeP.setDocumentDate(
                            await CustomDatePicker.pickDateAndTime(
                                context, DateTime.now()));
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                suffixIcon: Icon(Icons.calendar_month),
                suffixIconColor: Constant.textHintColor,
              ),
              Constant.xSizedBox16,
              CustomTextField.borderTextField(
                controller: assetDowntimeP.upDateC,
                labelText: "Up Date",
                hintText: "Up Date",
                required: true,
                readOnly: true,
                onTap: !widget.isEdit && !widget.isCreate
                    ? null
                    : () async {
                        await assetDowntimeP.setUpDate(
                            await CustomDatePicker.pickDateAndTime(
                                context, DateTime.now()));
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                suffixIcon: Icon(Icons.calendar_month),
                suffixIconColor: Constant.textHintColor,
              ),
              // Constant.xSizedBox16,
              // CustomDropdown.normalDropdown(
              //   labelText: "Category",
              //   hintText: "Select Category",
              //   selectedItem: assetDowntimeP.categoryV,
              //   list: [
              //     DropdownMenuItem(value: "a", child: Text("a")),
              //     DropdownMenuItem(value: "b", child: Text("b"))
              //   ],
              //   // list: (listProvince ?? [])
              //   //     .map((e) => DropdownMenuItem(
              //   //         value: e?.province, child: Text(e?.province ?? "")))
              //   //     .toList(),
              //   onChanged: (val) {
              //     assetDowntimeP.categoryIdV = val;
              //     // subAgenP.kotaNameV = null;
              //     // subAgenP.kotaIdV = null;
              //     // subAgenP.provinsiNameV = val;
              //     // subAgenP.kecamatanIdV = null;
              //     // subAgenP.kecamatanNameV = null;
              //     // subAgenP.desaIdV = null;
              //     // subAgenP.desaNameV = null;
              //     // subAgenP.provinsiIdV = (listProvince ?? [])
              //     //     .firstWhere((element) => element?.province == val)
              //     //     ?.provinceId;
              //     // setState(() {});
              //     // context.read<RegionProvider>().cityModel = CityModel();
              //     // context.read<RegionProvider>().fetchCity(
              //     //     subAgenP.provinsiIdV ?? "",
              //     //     withLoading: true);
              //   },
              // ),
              // Constant.xSizedBox16,
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 5,
              //       child: CustomTextField.borderTextField(
              //         padding: EdgeInsets.only(left: 20),
              //         required: true,
              //         controller: assetDowntimeP.downtime1C,
              //         labelText: "Downtime 1",
              //         hintText: "Downtime 1",
              //         textInputType: TextInputType.number,
              //         inputFormatters: [
              //           FilteringTextInputFormatter.allow(
              //               RegExp(r'^\d+\.?\d?')),
              //           FilteringTextInputFormatter.digitsOnly
              //         ],
              //       ),
              //     ),
              //     Constant.xSizedBox16,
              //     Expanded(
              //       flex: 5,
              //       child: CustomTextField.borderTextField(
              //         padding: EdgeInsets.only(right: 20),
              //         required: true,
              //         controller: assetDowntimeP.downtime2C,
              //         labelText: "Downtime 2",
              //         hintText: "Downtime 2",
              //         textInputType: TextInputType.number,
              //         inputFormatters: [
              //           FilteringTextInputFormatter.allow(
              //               RegExp(r'^\d+\.?\d?')),
              //           FilteringTextInputFormatter.digitsOnly
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              Constant.xSizedBox16,
              CustomTextField.borderTextArea(
                controller: assetDowntimeP.descC,
                labelText: "Description",
                hintText: "Free text",
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                focusNode: assetDowntimeP.descNode,
                required: true,
                readOnly: !widget.isEdit && !widget.isCreate,
              ),
            ],
          ),
        ),
      );
    }

    Widget cancelSaveButton() {
      return Row(
        children: [
          Expanded(
              child: CustomButton.secondaryButton("Cancel", () async {
            FocusManager.instance.primaryFocus?.unfocus();
            CusNav.nPop(context);
          })),
          Constant.xSizedBox16,
          Expanded(
            child: CustomButton.mainButton(
              "Save",
              () => handleTap(() async {
                FocusManager.instance.primaryFocus?.unfocus();
                await assetDowntimeP
                    .addAssetDowntime(
                  assetId: widget.assetId,
                  assetCode: widget.assetCode,
                  isEdit: widget.isEdit && !widget.isCreate,
                )
                    .then((value) async {
                  await Utils.showSuccess(
                      msg:
                          "${!widget.isEdit && !widget.isCreate ? "View" : widget.isEdit ? "Edit" : "Create"} Asset Success");
                  Future.delayed(
                      Duration(seconds: 2), () => Navigator.pop(context, true));
                }).onError((error, stackTrace) {
                  FirebaseCrashlytics.instance.log(
                      "${!widget.isEdit && !widget.isCreate ? "View" : widget.isEdit ? "Edit" : "Create"} Asset Error : ${error}");
                  Utils.showFailed(
                      msg: error.toString().toLowerCase().contains("doctype")
                          ? "${!widget.isEdit && !widget.isCreate ? "View" : widget.isEdit ? "Edit" : "Create"} Asset Failed"
                          : "$error");
                });
              }),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
          context,
          "${!widget.isEdit && !widget.isCreate ? "View" : widget.isEdit ? "Edit" : "Create"} Asset Downtime"),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (!widget.isEdit && !widget.isCreate) {
              return true;
            } else {
              await Utils.showYesNoDialog(
                context: context,
                title:
                    "Batalkan ${!widget.isEdit && !widget.isCreate ? "View" : widget.isEdit ? "Edit" : "Create"} Asset Downtime",
                desc:
                    'Apakah Anda yakin ingin membatalkan ${!widget.isEdit && !widget.isCreate ? "View" : widget.isEdit ? "Edit" : "create"} asset meter?',
                yesCallback: () async {
                  await context
                      .read<AssetDowntimeProvider>()
                      .clearAssetDowntimeForm()
                      .then((value) {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                    return true;
                  }).onError((error, stackTrace) {
                    FirebaseCrashlytics.instance.log(
                        "Cancel ${!widget.isEdit && !widget.isCreate ? "View" : widget.isEdit ? "Edit" : "Create"} Asset Downtime Error : " +
                            error.toString());
                    Utils.showFailed(
                        msg: error.toString().toLowerCase().contains("doctype")
                            ? "Gagal ${!widget.isEdit && !widget.isCreate ? "View" : widget.isEdit ? "Edit" : "Create"} Asset Downtime"
                            : "$error");
                    return false;
                  });
                },
                noCallback: () {
                  Navigator.pop(context);
                },
              );
              return false;
            }
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      form(),
                      Constant.xSizedBox16,
                      SizedBox(height: 48),
                    ],
                  ),
                ),
                if (widget.isEdit || widget.isCreate)
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: cancelSaveButton(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
