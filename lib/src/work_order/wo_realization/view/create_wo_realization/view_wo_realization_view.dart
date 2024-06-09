import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_button.dart';
import 'package:mata/common/component/custom_navigator.dart';
import 'package:mata/common/component/custom_textfield.dart';
import 'package:mata/src/work_order/wo_realization/model/wo_search.dart';
import 'package:mata/src/work_order/wo_realization/view/create_wo_realization/activity_wo_realization.dart';
import 'package:mata/src/work_order/wo_realization/view/sub_header_wo_realization_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/component/custom_date_picker.dart';
import '../../../../../common/helper/constant.dart';
import '../../provider/wo_realization_provider.dart';
import '../header_wo_realization_view.dart';

class ViewWORealizationView extends StatefulWidget {
  // bool isEdit;
  // ViewWORealizationView({super.key, this.isEdit = false});
  ViewWORealizationView({super.key});

  static String thousandSeparator(int val) {
    return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
        .format(val);
  }

  @override
  State<ViewWORealizationView> createState() => _ViewWORealizationViewState();
}

class _ViewWORealizationViewState extends State<ViewWORealizationView> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = true; // Atur nilai awal state di initState
  }

  @override
  Widget build(BuildContext context) {
    final woRealizationP = context.watch<WORealizationProvider>();

    Widget formWoNumber() {
      final data = woRealizationP.woRealizationModelData;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField.borderTextField(
            readOnly: true,
            required: false,
            enabled: false,
            controller: woRealizationP.woNumberC,
            labelText: "WO Number",
            hintText: data.docNo,
            textInputType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextField(
            readOnly: true,
            required: false,
            enabled: false,
            controller: woRealizationP.workTypeC,
            labelText: "Work Type",
            hintText: data.typeWork?.name ?? "-",
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Constant.textHintColor2,
              ),
            ),
            textInputType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextField(
            readOnly: true,
            required: false,
            enabled: false,
            controller: woRealizationP.assetC,
            labelText: "Asset",
            hintText: data.asset?.name ?? "-",
            hintColor: Constant.textHintColor2,
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
          if (woRealizationP.workTypeV == "Shutdown" ||
              woRealizationP.workTypeC.text == "Shutdown" ||
              woRealizationP.workTypeV == "Corrective Maintenance" ||
              woRealizationP.workTypeC.text == "Corrective Maintenance")
            Constant.xSizedBox16,
          if (woRealizationP.workTypeV == "Shutdown" ||
              woRealizationP.workTypeC.text == "Shutdown" ||
              woRealizationP.workTypeV == "Corrective Maintenance" ||
              woRealizationP.workTypeC.text == "Corrective Maintenance")
            CustomTextField.borderTextField(
              readOnly: true,
              required: true,
              enabled: false,
              controller: woRealizationP.workOrderC,
              labelText: "Work Order",
              hintText: data.workorderId ?? "Work Order",
              hintColor: Constant.textHintColor2,
              // onTap: () async {
              //   WOWorkOrderSearchModelData? result = await Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => WOCompleteSearchView()));
              //   FocusManager.instance.primaryFocus?.unfocus();
              //   if (result != null) {
              //     woRealizationP.woWorkOrderSearchModelData = result;
              //     woRealizationP.workOrderC.text = result.type ?? "";
              //     setState(() {});
              //   }
              // },
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
                value: woRealizationP.isEdit
                    ? woRealizationP.isDowntime
                    : data.isDowntime == "1"
                        ? true
                        : false,
                activeColor: Constant.primaryColor,
                onChanged: (value) {
                  // setState(() {
                  //   _isChecked = value!;
                  // });
                },
              ),
              Text("Is Downtime")
            ],
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextField(
            readOnly: true,
            required: false,
            enabled: false,
            controller: woRealizationP.dateDocC,
            labelText: "Date Doc",
            hintText: data.dateDoc ?? "dd-MM-yyyy",
            onTap: () async {
              await woRealizationP.setDate(
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
            enabled: true,
            controller: woRealizationP.estimatedStartC,
            labelText: "Actual Start",
            hintText: data.dateStart ?? "dd-MM-yyyy",
            onTap: () async {
              await woRealizationP.setEstimatedStart(
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
            enabled: true,
            controller: woRealizationP.dateDocC,
            labelText: "Actual Completion",
            hintText: data.dateEnd ?? "dd-MM-yyyy",
            onTap: () async {
              await woRealizationP.setEstimatedStart(
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
            readOnly: true,
            required: false,
            enabled: false,
            controller: woRealizationP.descC,
            labelText: "Description",
            hintText: data.description ?? "Deskripsi",
            textInputType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            focusNode: woRealizationP.descNode,
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: CustomAppBar.appBar(
        context,
        "${woRealizationP.isEdit ? "Edit" : "View"} WO Realization",
        onBack: () {
          if (woRealizationP.isEdit)
            woRealizationP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (woRealizationP.isEdit) {
            woRealizationP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [
                    if (!woRealizationP.isEdit) headerWo(context),
                    subHeaderWo(0, context, isEdit: true),
                    Constant.xSizedBox32,
                    formWoNumber(),
                    SizedBox(height: 100)
                  ],
                )),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: woRealizationP.isEdit
          ? woRealizationP.cancelSaveButton(context)
          : null,
    );
  }
}
