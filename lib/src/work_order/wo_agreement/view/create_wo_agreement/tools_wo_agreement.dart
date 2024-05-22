import 'package:bimops/common/base/base_state.dart';
import 'package:bimops/src/work_order/wo_agreement/provider/wo_agreement_provider.dart';
import 'package:bimops/src/work_order/wo_agreement/view/search/wo_tools_search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../common/component/custom_appbar.dart';
import '../../../../../common/component/custom_button.dart';
import '../../../../../common/component/custom_navigator.dart';
import '../../../../../common/component/custom_textField.dart';
import '../../../../../common/helper/constant.dart';
import '../../../../../utils/utils.dart';
import '../../model/wo_search.dart';
import '../header_wo_agreement_view.dart';
import '../sub_header_wo_agreement_view.dart';

class ToolsWOAgreement extends StatefulWidget {
  ToolsWOAgreement({super.key});

  @override
  State<ToolsWOAgreement> createState() => _ToolsWOAgreementState();
}

class _ToolsWOAgreementState extends BaseState<ToolsWOAgreement> {
  @override
  Widget build(BuildContext context) {
    final toolsP = context.watch<WOAgreementProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return Container(
          height: 350,
          child: Column(
            children: [
              CustomTextField.borderTextField(
                readOnly: !toolsP.isEdit || !toolsP.isCreate,
                required: true,
                enabled: true,
                controller: toolsP.toolsC,
                labelText: "Tools",
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
                onTap: () async {
                  WOToolsSearchModelData? result = await
                  CusNav.nPush(context, WOToolsSearchView());
                  
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (result != null) {
                    toolsP.toolsSelected = result;
                    toolsP.toolsC.text = result.name ?? "0";
                    toolsP.uomC.text = result.satuan ?? "0";
                    state(() {});
                  }
                },
              ),
              Constant.xSizedBox8,
              CustomTextField.borderTextField(
                readOnly: !toolsP.isEdit || !toolsP.isCreate,
                required: true,
                enabled: true,
                controller: toolsP.uomC,
                labelText: "Uom",
                hintText: "Autofilled by tools yang dipilih",
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              Constant.xSizedBox8,
              CustomTextField.borderTextField(
                readOnly: !toolsP.isEdit && !toolsP.isCreate,
                required: true,
                enabled: true,
                controller: toolsP.quantityC,
                labelText: "Quantity",
                hintText: "Input",
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              Constant.xSizedBox16,
              if (toolsP.isEdit || toolsP.isCreate)
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
                        toolsP.onEditOrAddButtonWoTools(
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

    Widget kontenTools() {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 64),
          width: 600,
          child: toolsP.listWoToolsParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                    toolsP.listWoToolsParam.length,
                    (index) {
                      final item = toolsP.listWoToolsParam[index];
                      return InkWell(
                        onTap: () {
                          toolsP.onTapWoTools(
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
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tools",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text(item.toolsName,
                                        style: Constant.grayRegular13),
                                  ],
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "UoM",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      item.uom,
                                      style: Constant.grayRegular13
                                          .copyWith(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Quality",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      item.qty,
                                      style: Constant.grayRegular13
                                          .copyWith(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              if (toolsP.isEdit || toolsP.isCreate)
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
                                          toolsP.listWoToolsParam
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

    Widget toolsList() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tools List",
                  style: Constant.grayMedium15.copyWith(color: Colors.grey),
                ),
                if (toolsP.isEdit || toolsP.isCreate)
                  CustomButton.smallMainButton(
                    "+ Add New",
                    () async {
                      await toolsP.createWoTools(
                          context: context, logPopUp: logPopUp());
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    textStyle: Constant.whiteBold,
                  ),
              ],
            ),
          ),
          kontenTools(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        toolsP.isCreate
            ? "Create WO Agreement"
            : "${toolsP.isEdit ? "Edit" : "View"} WO Agreement",
        onBack: () {
          if (toolsP.isEdit && !toolsP.isCreate)
            toolsP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (toolsP.isEdit && !toolsP.isCreate) {
            toolsP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (!toolsP.isEdit && !toolsP.isCreate) headerWo(context),
                subHeaderWo(2,context),
                Constant.xSizedBox32,
                toolsList(),
                Constant.xSizedBox32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: toolsP.isEdit || toolsP.isCreate
          ? toolsP.cancelSaveButton(context)
          : null,
    );
  }
}
