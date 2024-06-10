import 'package:mata/common/base/base_state.dart';
import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_button.dart';
import 'package:mata/common/component/custom_dropdown.dart';
import 'package:mata/common/component/custom_navigator.dart';
import 'package:mata/common/component/custom_textField.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/work_order/wo_agreement/model/wo_param.dart';
import 'package:mata/src/work_order/wo_realization/model/wo_search.dart';
import 'package:mata/src/work_order/wo_realization/provider/wo_realization_provider.dart';
import 'package:mata/src/work_order/wo_realization/view/search/wo_personil_search_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/utils.dart';
import '../header_wo_realization_view.dart';
import '../sub_header_wo_realization_view.dart';

class LaboursWORealization extends StatefulWidget {
  LaboursWORealization({super.key});

  @override
  State<LaboursWORealization> createState() => _LaboursWORealizationState();
}

class _LaboursWORealizationState extends BaseState<LaboursWORealization> {
  @override
  void initState() {
    context.read<WORealizationProvider>().fetchWOLaboursCraft();
    context.read<WORealizationProvider>().fetchWOLaboursSkill();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final laboursP = context.watch<WORealizationProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                CustomDropdown.normalDropdown(
                  controller: laboursP.craftC,
                  readOnly: !laboursP.isEdit,
                  required: true,
                  // enabled: true,
                  labelText: "Craft",
                  hintText: laboursP.craftC.text != ""
                      ? laboursP.craftC.text
                      : "Select",
                  selectedItem: laboursP.craftV,
                  list: (laboursP.woLaboursCraftModel.data ?? [])
                      .map((e) => DropdownMenuItem<String>(
                          value: e?.name ?? "0", child: Text(e?.name ?? "")))
                      .toList(),
                  onChanged: (val) {
                    laboursP.craftV = val;
                    laboursP.craftIdV =
                        (laboursP.woLaboursCraftModel.data ?? [])
                                .firstWhere((element) => element?.name == val)
                                ?.id ??
                            "0";
                    setState(() {});
                  },
                ),
                Constant.xSizedBox8,
                CustomDropdown.normalDropdown(
                  controller: laboursP.skillC,
                  readOnly: !laboursP.isEdit,
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
                    laboursP.skillIdV =
                        (laboursP.woLaboursSkillModel.data ?? [])
                                .firstWhere((element) => element?.name == val)
                                ?.id ??
                            "0";
                    setState(() {});
                  },
                ),
                Constant.xSizedBox8,
                CustomTextField.borderTextField(
                  readOnly: !laboursP.isEdit,
                  required: true,
                  enabled: true,
                  controller: laboursP.amountC,
                  labelText: "Amount",
                  hintText: "Input",
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                ),
                Constant.xSizedBox16,
                CustomTextField.borderTextField(
                    readOnly: !laboursP.isEdit,
                    enabled: true,
                    controller: laboursP.personilC,
                    labelText: "Personil",
                    hintText: "Search",
                    hintColor: Constant.textHintColor,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/icons/ic-search.png',
                        width: 5,
                        height: 5,
                      ),
                    ),
                    onTap: !laboursP.isEdit
                        ? null
                        : () async {
                            String result = await CusNav.nPush(
                                context, WOPersonilSearchView());

                            FocusManager.instance.primaryFocus?.unfocus();
                            if (result != "") {
                              // laboursP.personilSelected = result;
                              laboursP.personilC.text = result;
                              state(() {});
                            }
                          }),
                Constant.xSizedBox16,
                if (laboursP.isEdit)
                  Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: CustomButton.secondaryButton("Cancel", () {
                            laboursP.clearAllListPersonil();
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
                      }
                      if ((laboursP.woLaboursSkillModel.data ?? [])
                          .isNotEmpty) {
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
                              SizedBox(width: 16),
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
                              SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Personil",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      children: List.generate(
                                        item.personilNip.length,
                                        (index) {
                                          final data = item.personilNip[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              data ?? "",
                                              style: Constant.grayRegular
                                                  .copyWith(fontSize: 12),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (laboursP.isEdit)
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Labours List",
                style: Constant.grayMedium15.copyWith(color: Colors.grey),
              ),
              if (laboursP.isEdit)
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
          Constant.xSizedBox16,
          kontenLabours(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "${laboursP.isEdit ? "Edit" : "View"} WO Realization",
        onBack: () {
          if (laboursP.isEdit)
            laboursP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (laboursP.isEdit) {
            laboursP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (!laboursP.isEdit) headerWo(context),
                subHeaderWo(3, context),
                Constant.xSizedBox32,
                laboursList(),
                Constant.xSizedBox32,
                Constant.xSizedBox32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          laboursP.isEdit ? laboursP.cancelSaveButton(context) : null,
    );
  }
}
