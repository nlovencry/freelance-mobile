import 'package:bimops/common/component/custom_appbar.dart';
import 'package:bimops/common/component/custom_button.dart';
import 'package:bimops/common/component/custom_navigator.dart';
import 'package:bimops/common/component/custom_textfield.dart';
import 'package:bimops/src/transaction/operation_hours/view/search_operation_hours_view.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/base/base_state.dart';
import '../../../../common/component/custom_date_picker.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../model/operation_hours_category_model.dart';
import '../provider/operation_hours_provider.dart';

class CreateOperationHoursView extends StatefulWidget {
  final String operationHoursCode;
  final String operationHoursId;
  final String date;
  final String dateTime;
  final String category;
  final String meter;
  final String description;
  bool isEdit;

  CreateOperationHoursView(
      {super.key,
      required this.operationHoursCode,
      required this.operationHoursId,
      required this.date,
      required this.dateTime,
      required this.category,
      required this.meter,
      required this.description,
      this.isEdit = false});

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<CreateOperationHoursView> createState() =>
      _CreateOperationHoursViewState();
}

class _CreateOperationHoursViewState
    extends BaseState<CreateOperationHoursView> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    final p = context.read<OperationHoursProvider>();
    p.fetchAssetCategory(page: 8, withLoading: true).then((value) {
      if ((p.operationHoursCategoryModel.data ?? []).isNotEmpty) {
        p.categoryV = (p.operationHoursCategoryModel.data ?? [])
            .firstWhere((e) => e?.code == "Jam-Operasi");
        p.categoryC.text = (p.operationHoursCategoryModel.data ?? [])
                .firstWhere((e) => e?.code == "Jam-Operasi")
                ?.name ??
            "";
        setState(() {});
      }
    });
    final data =
        context.read<OperationHoursProvider>().operationHoursViewModel.data;
    p.assetC.text = widget.operationHoursCode;
    if (widget.date != "") {
      var dateDoc = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.date + " " + widget.dateTime);
      var dateDocF = DateTime(dateDoc.year, dateDoc.month, dateDoc.day,
          dateDoc.hour, dateDoc.minute);
      final dateDoc2 = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateDoc);
      p.dateC.text = "$dateDoc2";
      p.setDate(dateDoc);
    }
    if (widget.category != "") {
      p.categoryC.text = widget.category;
    }
    if (widget.meter != "") {
      p.meter1C.text = widget.meter;
    }
    if (widget.meter != "") {
      p.meter2C.text = widget.meter;
    }
    if (widget.description != "") p.descC.text = widget.description;
    // p.pagingControllerCategory = PagingController(firstPageKey: 1)
    //   ..addPageRequestListener(
    //       (pageKey) => );
  }

  @override
  Widget build(BuildContext context) {
    final operationHoursP = context.watch<OperationHoursProvider>();

    Widget form() {
      return Form(
        key: operationHoursP.createOperationHoursKey,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.borderTextField(
                controller: operationHoursP.assetC,
                labelText: "Asset",
                hintText: "Asset",
                required: true,
                enabled: false,
                readOnly: widget.isEdit,
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              Constant.xSizedBox16,
              CustomTextField.borderTextField(
                controller: operationHoursP.dateC,
                labelText: "Date",
                hintText: "Date",
                readOnly: true,
                onTap: widget.isEdit
                    ? null
                    : () async {
                        await operationHoursP.setDate(
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
                controller: operationHoursP.categoryC,
                labelText: "Category",
                hintText: "Select Category",
                readOnly: true,
                enabled: false,
                required: false,
                suffixIcon: Icon(Icons.keyboard_arrow_down),
                suffixIconColor: Constant.textHintColor,
                onTap: widget.isEdit
                    ? null
                    : () async {
                        operationHoursP.assetSearchCategoryC.clear();
                        final OperationHoursCategoryModelData?
                            selectedCategory = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchOperationHoursView()));
                        if (selectedCategory != null) {
                          operationHoursP.categoryV = selectedCategory;
                          operationHoursP.categoryC.text =
                              selectedCategory.code ?? "";
                          setState(() {});
                        }
                      },
              ),
              Constant.xSizedBox16,
              CustomTextField.borderTextField(
                required: true,
                controller: operationHoursP.meter2C,
                labelText: "Meter",
                hintText: "Meters",
                readOnly: widget.isEdit,
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              Constant.xSizedBox16,
              CustomTextField.borderTextArea(
                controller: operationHoursP.descC,
                labelText: "Description",
                hintText: "Free text",
                required: true,
                readOnly: widget.isEdit,
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                focusNode: operationHoursP.descNode,
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
              child: CustomButton.secondaryButton(
                  "Cancel", () => CusNav.nPop(context))),
          Constant.xSizedBox16,
          Expanded(
            child: CustomButton.mainButton(
              "Save",
              () => handleTap(() async {
                await operationHoursP
                    .addOperationHours(
                        assetId: widget.operationHoursId,
                        assetCode: widget.operationHoursCode)
                    .then((value) async {
                  await Utils.showSuccess(
                      msg:
                          "${widget.isEdit ? "View" : "Create"}Operation Hours Success");
                  Future.delayed(
                      Duration(seconds: 2), () => Navigator.pop(context, true));
                }).onError((error, stackTrace) {
                  FirebaseCrashlytics.instance.log(
                      "${widget.isEdit ? "View" : "Create"} Operation Hours Error : ${error}");
                  Utils.showFailed(
                      msg: error.toString().toLowerCase().contains("doctype")
                          ? "${widget.isEdit ? "View" : "Create"} Operation Hours Failed"
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
          context, "${widget.isEdit ? "View" : "Create"} Operation Hours"),
      body: WillPopScope(
        onWillPop: () async {
          if (widget.isEdit) {
            return true;
          } else {
            await Utils.showYesNoDialog(
              context: context,
              title:
                  "Batalkan ${widget.isEdit ? "View" : "Create"} Operation Hours",
              desc:
                  'Apakah Anda yakin ingin membatalkan ${widget.isEdit ? "View" : "create"} asset meter?',
              yesCallback: () async {
                await context
                    .read<OperationHoursProvider>()
                    .clearOperationHoursForm()
                    .then((value) {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                  return true;
                }).onError((error, stackTrace) {
                  FirebaseCrashlytics.instance.log(
                      "Cancel ${widget.isEdit ? "View" : "Create"} Operation Hours Error : " +
                          error.toString());
                  Utils.showFailed(
                      msg: error.toString().toLowerCase().contains("doctype")
                          ? "Gagal ${widget.isEdit ? "View" : "Create"} Operation Hours"
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
        child: SafeArea(
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
    );
  }
}
