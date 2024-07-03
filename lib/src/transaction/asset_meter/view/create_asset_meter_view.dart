import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/common/component/custom_textfield.dart';
import 'package:hy_tutorial/common/helper/safe_network_image.dart';
import 'package:hy_tutorial/src/transaction/asset_meter/model/asset_meter_category_model.dart';
import 'package:hy_tutorial/src/transaction/asset_meter/view/search_asset_meter_view.dart';
import 'package:hy_tutorial/utils/utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/component/custom_date_picker.dart';
import '../../../../common/component/custom_dropdown.dart';
import '../../../../common/component/custom_navigator.dart';
import '../../../../common/helper/constant.dart';
import '../provider/asset_meter_provider.dart';

class CreateAssetMeterView extends StatefulWidget {
  final String assetCode;
  final String assetId;
  final String documentDate;
  final String documentDateTime;
  final String category;
  final String meterLalu;
  final String meter;
  final String desc;
  bool isEdit;

  CreateAssetMeterView(
      {super.key,
      required this.assetCode,
      required this.assetId,
      required this.documentDate,
      required this.documentDateTime,
      required this.category,
      required this.meterLalu,
      required this.meter,
      required this.desc,
      this.isEdit = false});

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<CreateAssetMeterView> createState() => _CreateAssetMeterViewState();
}

class _CreateAssetMeterViewState extends BaseState<CreateAssetMeterView> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    final p = context.read<AssetMeterProvider>();
    final data = context.read<AssetMeterProvider>().assetMeterViewModel.data;
    p.assetC.text = widget.assetCode;
    if (widget.documentDate != "") {
      var dateDoc = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.documentDate + " " + widget.documentDateTime);
      var dateDocF = DateTime(dateDoc.year, dateDoc.month, dateDoc.day,
          dateDoc.hour, dateDoc.minute);
      final dateDoc2 = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateDocF);
      p.dateC.text = "$dateDoc2";
      p.setDate(dateDocF);
    }
    if (widget.category != "") {
      p.categoryC.text = widget.category;
    }
    if (widget.meterLalu != "") {
      p.meter1C.text = widget.meterLalu;
    }
    if (widget.meter != "") {
      p.meter2C.text = widget.meter;
    }
    if (widget.desc != "") p.descC.text = widget.desc;
  }

  @override
  Widget build(BuildContext context) {
    final assetMeterP = context.watch<AssetMeterProvider>();

    Widget form() {
      return Form(
        key: assetMeterP.createAssetKey,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.borderTextField(
                controller: assetMeterP.assetC,
                labelText: "Asset",
                hintText: "Asset",
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                readOnly: widget.isEdit,
                required: true,
                enabled: false,
              ),
              Constant.xSizedBox16,
              CustomTextField.borderTextField(
                controller: assetMeterP.dateC,
                labelText: "Date",
                hintText: "dd-mm-yyyy",
                readOnly: true,
                onTap: widget.isEdit
                    ? null
                    : () async {
                        await assetMeterP.setDate(
                            await CustomDatePicker.pickDateAndTime(
                                context, DateTime.now()));
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                suffixIcon: Icon(Icons.calendar_month),
                suffixIconColor: Constant.textHintColor,
                required: true,
              ),
              Constant.xSizedBox16,
              CustomTextField.borderTextField(
                controller: assetMeterP.categoryC,
                labelText: "Category",
                hintText: "Select",
                readOnly: true,
                // enabled: !widget.isEdit,
                required: true,
                suffixIcon: Icon(Icons.keyboard_arrow_down),
                suffixIconColor: Constant.textHintColor,
                onTap: widget.isEdit
                    ? null
                    : () async {
                        assetMeterP.assetMeterCategorySearchC.clear();
                        final AssetMeterCategoryModelData? selectedCategory =
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchAssetMeterView()));
                        if (selectedCategory != null) {
                          await context
                              .read<AssetMeterProvider>()
                              .fetchAssetMeterLalu(
                                  assetMeterCode: selectedCategory.code ?? "");
                          assetMeterP.categoryV = selectedCategory;
                          assetMeterP.categoryC.text =
                              selectedCategory.code ?? "";
                          assetMeterP.meter1C.text =
                              assetMeterP.assetMeterMeterLaluModel.data ?? "";
                          setState(() {});
                        }
                      },
              ),
              Constant.xSizedBox16,
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: CustomTextField.borderTextField(
                      padding: EdgeInsets.only(left: 20),
                      required: false,
                      readOnly: true,
                      enabled: false,
                      controller: assetMeterP.meter1C,
                      labelText: "Meter Lalu",
                      hintText: "Meter Lalu",
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d?')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Constant.xSizedBox16,
                  Expanded(
                    flex: 5,
                    child: CustomTextField.borderTextField(
                      padding: EdgeInsets.only(right: 20),
                      required: true,
                      readOnly: widget.isEdit,
                      controller: assetMeterP.meter2C,
                      labelText: "Meter",
                      hintText: "Meter",
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d?')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
              Constant.xSizedBox16,
              CustomTextField.borderTextArea(
                controller: assetMeterP.descC,
                labelText: "Description",
                hintText: "Free text",
                required: true,
                readOnly: widget.isEdit,
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                focusNode: assetMeterP.descNode,
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
            assetMeterP.assetMeterCategorySearchC.clear();
            CusNav.nPop(context);
          })),
          Constant.xSizedBox16,
          Expanded(
            child: CustomButton.mainButton(
              "Save",
              () => handleTap(() async {
                FocusManager.instance.primaryFocus?.unfocus();
                assetMeterP.assetMeterCategorySearchC.clear();
                await assetMeterP
                    .addAssetMeter(
                        assetId: widget.assetId, assetCode: widget.assetCode)
                    .then((value) async {
                  await Utils.showSuccess(msg: "Create Asset Success");
                  Future.delayed(
                      Duration(seconds: 2), () => Navigator.pop(context, true));
                }).onError((error, stackTrace) {
                  FirebaseCrashlytics.instance
                      .log("Create Asset Error : ${error}");
                  Utils.showFailed(
                      msg: error.toString().toLowerCase().contains("doctype")
                          ? "Create Asset Failed"
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
          context, "${widget.isEdit ? "View" : "Create"} Asset Meter"),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (widget.isEdit) {
              return true;
            } else {
              await Utils.showYesNoDialog(
                context: context,
                title:
                    "Batalkan ${widget.isEdit ? "View" : "Create"} Asset Meter",
                desc:
                    'Apakah Anda yakin ingin membatalkan ${widget.isEdit ? "View" : "Create"} Asset Meter?',
                yesCallback: () async {
                  await context
                      .read<AssetMeterProvider>()
                      .clearAssetMeterForm()
                      .then((value) {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                    return true;
                  }).onError((error, stackTrace) {
                    FirebaseCrashlytics.instance.log(
                        "Cancel ${widget.isEdit ? "View" : "Create"} Asset Meter Error : " +
                            error.toString());
                    Utils.showFailed(
                        msg: error.toString().toLowerCase().contains("doctype")
                            ? "Gagal ${widget.isEdit ? "View" : "Create"} Asset Meter"
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
            child: RefreshIndicator(
              color: Constant.primaryColor,
              onRefresh: () async {},
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
                  if (!widget.isEdit)
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: cancelSaveButton(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
