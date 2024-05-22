import 'package:bimops/common/base/base_state.dart';
import 'package:bimops/common/component/custom_appbar.dart';
import 'package:bimops/common/component/custom_button.dart';
import 'package:bimops/common/component/custom_dropdown.dart';
import 'package:bimops/common/component/custom_textField.dart';
import 'package:bimops/common/helper/constant.dart';
import 'package:bimops/src/work_order/wo_agreement/provider/wo_agreement_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../common/component/custom_navigator.dart';
import '../../../../../utils/utils.dart';
import '../header_wo_agreement_view.dart';
import '../sub_header_wo_agreement_view.dart';

class LaboursWOAgreement extends StatefulWidget {
  LaboursWOAgreement({super.key});

  @override
  State<LaboursWOAgreement> createState() => _LaboursWOAgreementState();
}

class _LaboursWOAgreementState extends BaseState<LaboursWOAgreement> {
  @override
  void initState() {
    context.read<WOAgreementProvider>().fetchWOLaboursCraft();
    context.read<WOAgreementProvider>().fetchWOLaboursSkill();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final laboursP = context.watch<WOAgreementProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return Container(
          height: 350,
          child: Column(
            children: [
              CustomDropdown.normalDropdown(
                controller: laboursP.craftC,

                readOnly: !laboursP.isEdit && !laboursP.isCreate,
                required: true,
                // enabled: true,
                labelText: "Craft",
                hintText: laboursP.craftC.text,
                selectedItem: laboursP.craftV,
                list: (laboursP.woLaboursCraftModel.data ?? [])
                    .map((e) => DropdownMenuItem<String>(
                        value: e?.name ?? "0", child: Text(e?.name ?? "")))
                    .toList(),
                onChanged: (val) {
                  laboursP.craftV = val;
                  laboursP.craftIdV = (laboursP.woLaboursCraftModel.data ?? [])
                      .firstWhere((element) => element?.name == val)
                      ?.id;
                  setState(() {});
                },
              ),
              Constant.xSizedBox8,
              CustomDropdown.normalDropdown(
                controller: laboursP.skillC,
                readOnly: !laboursP.isEdit && !laboursP.isCreate,
                required: true,
                // enabled: true,
                labelText: "Skill",
                hintText: laboursP.skillC.text != ""
                    ? laboursP.skillC.text
                    : "Select",
                selectedItem: laboursP.skillV,
                list: (laboursP.woLaboursSkillModel.data ?? [])
                    .map((e) => DropdownMenuItem<String>(
                        value: e?.name ?? "0", child: Text(e?.name ?? "")))
                    .toList(),
                onChanged: (val) {
                  laboursP.skillV = val;
                  laboursP.skillIdV = (laboursP.woLaboursSkillModel.data ?? [])
                      .firstWhere((element) => element?.name == val)
                      ?.id;
                  setState(() {});
                },
              ),
              Constant.xSizedBox8,
              CustomTextField.borderTextField(
                readOnly: !laboursP.isEdit && !laboursP.isCreate,
                required: true,
                enabled: true,
                controller: laboursP.amountC,
                labelText: "Amount",
                hintText: "Input",
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              Constant.xSizedBox16,
              if (laboursP.isEdit || laboursP.isCreate)
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: CustomButton.secondaryButton("Cancel", () {
                          Navigator.pop(context);
                        })),
                    Constant.xSizedBox8,
                    Expanded(
                      flex: 5,
                      child: CustomButton.mainButton(
                          index != null ? "Edit" : "Add", () {
                        laboursP.onEditOrAddButtonWoLabours(
                            context: context, index: index);
                      }),
                    )
                  ],
                ),
            ],
          ),
        );
      });
    }

    Widget kontenLabours() {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 64),
          width: 600,
          child: laboursP.listWoLaboursParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                    laboursP.listWoLaboursParam.length,
                    (index) {
                      String craft = "";
                      String skill = "";
                      final item = laboursP.listWoLaboursParam[index];
                      if ((laboursP.woLaboursCraftModel.data ?? [])
                          .isNotEmpty) {
                        craft = (laboursP.woLaboursCraftModel.data ?? [])
                                .firstWhere((e) => e?.id == item.craft)
                                ?.name ??
                            "";
                        skill = (laboursP.woLaboursSkillModel.data ?? [])
                                .firstWhere((e) => e?.id == item.skill)
                                ?.name ??
                            "";
                      }
                      return InkWell(
                        onTap: () {
                          laboursP.onTapWoLabours(
                            context: context,
                            index: index,
                            logPopUp: logPopUp(index: index),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "No",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text("${index + 1}",
                                        style: Constant.grayRegular13),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Craft",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text(craft ?? item.craft,
                                        style: Constant.grayRegular13),
                                  ],
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Skill",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text(skill ?? item.skill,
                                        style: Constant.grayRegular13),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Amount",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      item.amount,
                                      style: Constant.grayRegular13
                                          .copyWith(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              if (laboursP.isEdit || laboursP.isCreate)
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () async {
                                      await Utils.showYesNoDialog(
                                        context: context,
                                        title: "Konfirmasi",
                                        desc:
                                            "Apakah Anda Yakin Ingin Hapus Data Ini?",
                                        yesCallback: () => handleTap(() async {
                                          Navigator.pop(context);
                                          laboursP.listWoLaboursParam
                                              .removeAt(index);
                                          setState(() {});
                                        }),
                                        noCallback: () =>
                                            Navigator.pop(context),
                                      );
                                    },
                                    icon: Icon(Icons.cancel),
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      );
    }

    Widget laboursList() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Labours List",
                  style: Constant.grayMedium15.copyWith(color: Colors.grey),
                ),
                if (laboursP.isEdit || laboursP.isCreate)
                  CustomButton.smallMainButton(
                    "+ Add New",
                    () async {
                      await laboursP.createWoLabours(
                          context: context, logPopUp: logPopUp());
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    textStyle: Constant.whiteBold,
                  ),
              ],
            ),
          ),
          kontenLabours(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        laboursP.isCreate
            ? "Create WO Agreement"
            : "${laboursP.isEdit ? "Edit" : "View"} WO Agreement",
        onBack: () {
          if (laboursP.isEdit && !laboursP.isCreate)
            laboursP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (laboursP.isEdit && !laboursP.isCreate) {
            laboursP.isEdit = false;
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
                  if (!laboursP.isEdit && !laboursP.isCreate) headerWo(context),
                  subHeaderWo(3, context),
                  Constant.xSizedBox32,
                  laboursList(),
                  Constant.xSizedBox32,
                ],
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: laboursP.isEdit || laboursP.isCreate
          ? laboursP.cancelSaveButton(context)
          : null,
    );
  }
}
