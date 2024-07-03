import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/common/component/custom_navigator.dart';
import 'package:hy_tutorial/common/component/custom_textField.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/model/wo_search.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/provider/wo_realization_provider.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/view/create_wo_realization/labours_wo_realization.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/view/search/wo_system_search_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/utils.dart';
import '../header_wo_realization_view.dart';
import '../search/wo_sub_system_search_view.dart';
import '../sub_header_wo_realization_view.dart';

class FailureCodeView extends StatefulWidget {
  FailureCodeView({super.key});

  @override
  State<FailureCodeView> createState() => _FailureCodeViewState();
}

class _FailureCodeViewState extends BaseState<FailureCodeView> {
  @override
  Widget build(BuildContext context) {
    final failureP = context.watch<WORealizationProvider>();
    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                CustomTextField.borderTextField(
                  readOnly: !failureP.isEdit,
                  required: true,
                  enabled: true,
                  controller: failureP.system9C,
                  labelText: "System",
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
                  onTap: !failureP.isEdit
                      ? null
                      : () async {
                          WOSystemSearchModelData? result =
                              await CusNav.nPush(context, WOSystemSearchView());

                          FocusManager.instance.primaryFocus?.unfocus();
                          if (result != null) {
                            failureP.systemSelected = result;
                            failureP.system9C.text = result.name ?? "";
                            state(() {});
                          }
                        },
                ),
                Constant.xSizedBox8,
                CustomTextField.borderTextField(
                  readOnly: !failureP.isEdit,
                  required: true,
                  enabled: true,
                  controller: failureP.subsystem9C,
                  labelText: "Sub System",
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
                  onTap: !failureP.isEdit
                      ? null
                      : () async {
                          WOSubSystemSearchModelData? result =
                              await CusNav.nPush(
                                  context, WOSubSystemSearchView());

                          FocusManager.instance.primaryFocus?.unfocus();
                          if (result != null) {
                            failureP.subSystemSelected = result;
                            failureP.subsystem9C.text = result.name ?? "";
                            state(() {});
                          }
                        },
                ),
                Constant.xSizedBox8,
                CustomTextField.borderTextArea(
                  controller: failureP.desc9C,
                  readOnly: !failureP.isEdit,
                  labelText: "Description",
                  hintText: "Free text",
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  focusNode: failureP.desc9Node,
                ),
                Constant.xSizedBox16,
                if (failureP.isEdit)
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
                          failureP.onEditOrAddButtonWoFailureCode(
                              context: context, index: index);
                        }),
                      )
                    ],
                  )
              ],
            ),
          ),
        );
      });
    }

    Widget kontenFailureCode() {
      return SingleChildScrollView(
        child: Container(
          child: failureP.listWoFailureCodeParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                      failureP.listWoFailureCodeParam.length, (index) {
                    final item = failureP.listWoFailureCodeParam[index];
                    return InkWell(
                      onTap: () {
                        failureP.onTapWoFailureCode(
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "System",
                                        style: Constant.grayRegular
                                            .copyWith(fontSize: 10),
                                      ),
                                      SizedBox(height: 10),
                                      Text(item.assetSystemName,
                                          style: Constant.grayRegular13),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description",
                                        style: Constant.grayRegular
                                            .copyWith(fontSize: 10),
                                      ),
                                      SizedBox(height: 10),
                                      Text(item.assetSubSystemName,
                                          style: Constant.grayRegular13),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 30),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sub System",
                                    style: Constant.grayRegular
                                        .copyWith(fontSize: 10),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Asset Sub System",
                                    style: Constant.grayRegular13
                                        .copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            if (failureP.isEdit)
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
                                        failureP.listWoFailureCodeParam
                                            .removeAt(index);
                                        setState(() {});
                                      }),
                                      noCallback: () => Navigator.pop(context),
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
                  }),
                ),
        ),
      );
    }

    Widget failureCodeList() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Failure Code List",
                style: Constant.grayMedium15.copyWith(color: Colors.grey),
              ),
              if (failureP.isEdit)
                CustomButton.smallMainButton("+ Add New", () async {
                  await failureP.createWoFailureCode(
                      context: context, logPopUp: logPopUp());
                },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    textStyle: Constant.whiteBold)
            ],
          ),
          Constant.xSizedBox16,
          kontenFailureCode(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "${failureP.isEdit ? "Edit" : "View"} WO Realization",
        onBack: () {
          if (failureP.isEdit)
            failureP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (failureP.isEdit) {
            failureP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!failureP.isEdit) headerWo(context),
                subHeaderWo(8, context),
                Constant.xSizedBox32,
                failureCodeList(),
                Constant.xSizedBox32,
                Constant.xSizedBox32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          failureP.isEdit ? failureP.cancelSaveButton(context) : null,
    );
  }
}
