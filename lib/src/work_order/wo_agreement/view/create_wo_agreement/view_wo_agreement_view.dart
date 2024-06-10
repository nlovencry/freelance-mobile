import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_button.dart';
import 'package:mata/common/component/custom_navigator.dart';
import 'package:mata/common/component/custom_textfield.dart';
import 'package:mata/src/work_order/wo_agreement/model/wo_search.dart';
import 'package:mata/src/work_order/wo_agreement/view/search/wo_asset_search_view.dart';
import 'package:mata/src/work_order/wo_agreement/view/search/wo_complete_search_view.dart';
import 'package:mata/src/work_order/wo_agreement/view/sub_header_wo_agreement_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/component/custom_date_picker.dart';
import '../../../../../common/component/custom_dropdown.dart';
import '../../../../../common/helper/constant.dart';
import '../../provider/wo_agreement_provider.dart';
import 'activity_wo_agreement_view.dart';
import '../header_wo_agreement_view.dart';

class ViewWOAgreementView extends StatefulWidget {
  ViewWOAgreementView({super.key});

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<ViewWOAgreementView> createState() => _ViewWOAgreementViewState();
}

class _ViewWOAgreementViewState extends State<ViewWOAgreementView> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = true; // Atur nilai awal state di initState
  }

  @override
  Widget build(BuildContext context) {
    final woAgreementP = context.watch<WOAgreementProvider>();

    Widget formWoNumber() {
      final data = woAgreementP.woAgreementModelData;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField.borderTextField(
            readOnly: true,
            required: false,
            enabled: false,
            controller: woAgreementP.woNumberC,
            labelText: "WO Number",
            hintText: "Auto generate",
            textInputType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Constant.xSizedBox16,
          CustomDropdown.normalDropdown(
            readOnly: !woAgreementP.isCreate,
            required: true,
            enabled: woAgreementP.isCreate,
            controller: woAgreementP.workTypeC,
            labelText: "Work Type",
            selectedItem: woAgreementP.workTypeV,
            hintText: data.typeWork?.name ?? "Select",
            list: [
              DropdownMenuItem(
                  value: "CM", child: Text("Corrective Maintenance")),
              DropdownMenuItem(
                  value: "PM", child: Text("Predictive Maintenance")),
              DropdownMenuItem(value: "BD", child: Text("Breakdown")),
              DropdownMenuItem(value: "AC", child: Text("Accident")),
              DropdownMenuItem(value: "SD", child: Text("Shutdown")),
            ],
            padding: EdgeInsets.symmetric(horizontal: 10),
            onChanged: (val) {
              if (val == "BD" || val == "SD") {
                woAgreementP.isDowntime = true;
              }
              woAgreementP.workTypeV = val;
              woAgreementP.workTypeShortC.text = val ?? "";
              if (val == "CM") {
                woAgreementP.workTypeC.text = "Corrective Maintenance";
              }
              if (val == "PDM") {
                woAgreementP.workTypeC.text = "Predictive Maintenance";
              }
              if (val == "BD") {
                woAgreementP.workTypeC.text = "Breakdown";
              }
              if (val == "AC") {
                woAgreementP.workTypeC.text = "Accident";
              }
              if (val == "SD") {
                woAgreementP.workTypeC.text = "Shutdown";
              }
              setState(() {});
              // woAgreementP.workTypeV = val;
            },
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextField(
            readOnly: true,
            required: true,
            enabled: woAgreementP.isEdit || woAgreementP.isCreate,
            controller: woAgreementP.assetC,
            labelText: "Asset",
            hintText: data.asset?.code ?? "Search",
            hintColor: Constant.textHintColor2,
            onTap: () async {
              WOAssetSearchModelData? result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WOAssetSearchView()));
              FocusManager.instance.primaryFocus?.unfocus();
              if (result != null) {
                woAgreementP.woAssetSearchModelData = result;
                woAgreementP.assetC.text = result.code ?? "";
                setState(() {});
              }
            },
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/icons/ic-search.png',
                width: 5,
                height: 5,
                color: Constant.textHintColor2,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Constant.xSizedBox16,
          if (woAgreementP.workTypeV == "SD" ||
              woAgreementP.workTypeC.text == "Shutdown" ||
              woAgreementP.workTypeV == "CM" ||
              woAgreementP.workTypeC.text == "Corrective Maintenance")
            CustomTextField.borderTextField(
              readOnly: true,
              required: true,
              enabled: woAgreementP.isEdit || woAgreementP.isCreate,
              controller: woAgreementP.workOrderC,
              labelText: "Work Order",
              hintText: data.workorderId ?? "Work Order",
              hintColor: Constant.textHintColor2,
              onTap: () async {
                WOWorkOrderSearchModelData? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WOCompleteSearchView()));
                FocusManager.instance.primaryFocus?.unfocus();
                if (result != null) {
                  woAgreementP.woWorkOrderSearchModelData = result;
                  // woAgreementP.workOrderC.text = result.docNo ?? "";
                  woAgreementP.setDataAfterWoCompleteSelected();
                  setState(() {});
                }
              },
              suffixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/icons/ic-search.png',
                  width: 5,
                  height: 5,
                  color: Constant.textHintColor2,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
          Constant.xSizedBox16,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                value: woAgreementP.isEdit || woAgreementP.isCreate
                    ? (woAgreementP.workTypeShortC.text == "BD" ||
                            woAgreementP.workTypeShortC.text == "SD"
                        ? true
                        : woAgreementP.isDowntime)
                    : (data.isDowntime == "1" ? true : false),
                activeColor: Constant.primaryColor,
                onChanged: woAgreementP.isCreate &&
                        woAgreementP.workTypeShortC.text != "BD" &&
                        woAgreementP.workTypeShortC.text != "SD"
                    ? (value) {
                        setState(() {
                          woAgreementP.isDowntime = value ?? false;
                        });
                      }
                    : null,
              ),
              Text("Is Downtime")
            ],
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextField(
            readOnly: false,
            required: false,
            enabled: woAgreementP.isCreate,
            controller: woAgreementP.dateDocC,
            labelText: "Date Doc",
            hintText: data.dateDoc ?? "dd-MM-yyy",
            onTap: () async {
              await woAgreementP.setDate(
                  await CustomDatePicker.pickDate(context, DateTime.now()));
              FocusManager.instance.primaryFocus?.unfocus();
            },
            suffixIcon: Icon(Icons.calendar_month),
            suffixIconColor: Constant.textHintColor,
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextField(
            readOnly: false,
            required: false,
            enabled: woAgreementP.isEdit || woAgreementP.isCreate,
            controller: woAgreementP.estimatedStartC,
            labelText: "Estimated Start",
            hintText: data.dateStart ?? "dd-MM-yyy",
            onTap: () async {
              await woAgreementP.setEstimatedStart(
                  await CustomDatePicker.pickDateAndTime(
                      context, DateTime.now()));
              FocusManager.instance.primaryFocus?.unfocus();
            },
            suffixIcon: Icon(Icons.calendar_month),
            suffixIconColor: Constant.textHintColor,
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextField(
            readOnly: false,
            required: false,
            enabled: woAgreementP.isEdit || woAgreementP.isCreate,
            controller: woAgreementP.estimatedCompleteC,
            labelText: "Estimated Completion",
            hintText: data.dateEnd ?? "dd-MM-yyy",
            onTap: () async {
              await woAgreementP.setEstimatedComplete(
                  await CustomDatePicker.pickDateAndTime(
                      context, DateTime.now()));
              FocusManager.instance.primaryFocus?.unfocus();
            },
            suffixIcon: Icon(Icons.calendar_month),
            suffixIconColor: Constant.textHintColor,
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextArea(
            readOnly: false,
            required: false,
            enabled: woAgreementP.isEdit || woAgreementP.isCreate,
            controller: woAgreementP.descC,
            labelText: "Description",
            hintText: data.description ?? "Deskripsi",
            textInputType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            focusNode: woAgreementP.descNode,
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          SizedBox(
            height: 100,
          )
        ],
      );
    }

    return Scaffold(
      appBar: CustomAppBar.appBar(
        context,
        woAgreementP.isCreate
            ? "Create WO Agreement"
            : "${woAgreementP.isEdit ? "Edit" : "View"} WO Agreement",
        onBack: () {
          if (woAgreementP.isEdit && !woAgreementP.isCreate)
            woAgreementP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (woAgreementP.isEdit && !woAgreementP.isCreate) {
            woAgreementP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  if (!woAgreementP.isEdit && !woAgreementP.isCreate)
                    headerWo(context),
                  subHeaderWo(0, context),
                  Constant.xSizedBox32,
                  formWoNumber(),
                  Constant.xSizedBox32,
                ],
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: woAgreementP.isEdit || woAgreementP.isCreate
          ? woAgreementP.cancelSaveButton(context)
          : null,
    );
  }
}
