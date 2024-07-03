import 'package:hy_tutorial/common/component/custom_date_picker.dart';
import 'package:hy_tutorial/common/component/custom_navigator.dart';

import 'package:hy_tutorial/src/work_order/wo_realization/provider/wo_realization_provider.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/view/create_wo_realization/labours_wo_realization.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/view/search/wo_warehouse_search_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/base/base_state.dart';
import '../../../../../common/component/custom_appbar.dart';
import '../../../../../common/component/custom_button.dart';
import '../../../../../common/component/custom_textField.dart';
import '../../../../../common/helper/constant.dart';
import '../../../../../utils/utils.dart';
import '../../../view/wo_search_view.dart';
import '../../model/wo_search.dart';
import '../header_wo_realization_view.dart';
import '../search/wo_sparepart_search_view.dart';
import '../sub_header_wo_realization_view.dart';

class SparepartWORealization extends StatefulWidget {
  // bool isEdit;
  SparepartWORealization({super.key});

  @override
  State<SparepartWORealization> createState() => _SparepartWORealizationState();
}

class _SparepartWORealizationState extends BaseState<SparepartWORealization> {
  @override
  Widget build(BuildContext context) {
    final sparepartP = context.watch<WORealizationProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                CustomTextField.borderTextField(
                  readOnly: !sparepartP.isEdit,
                  required: true,
                  enabled: true,
                  controller: sparepartP.codeC,
                  labelText: "Code",
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
                  onTap: !sparepartP.isEdit
                      ? null
                      : () async {
                          WOSparepartSearchModelData? result =
                              await CusNav.nPush(
                                  context, WOSparepartSearchView());

                          FocusManager.instance.primaryFocus?.unfocus();
                          if (result != null) {
                            sparepartP.sparepartSelected = result;
                            sparepartP.codeC.text = result.code ?? "";
                            sparepartP.nameC.text = result.name ?? "";
                            sparepartP.uom6C.text = result.uom ?? "";
                            state(() {});
                          }
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                Constant.xSizedBox8,
                CustomTextField.borderTextField(
                  readOnly: !sparepartP.isEdit,
                  required: true,
                  enabled: false,
                  controller: sparepartP.nameC,
                  labelText: "Name",
                  hintText: "Autofilled by tools yang dipilih",
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                Constant.xSizedBox8,
                CustomTextField.borderTextField(
                  readOnly: !sparepartP.isEdit,
                  required: true,
                  enabled: false,
                  controller: sparepartP.uom6C,
                  labelText: "Uom",
                  hintText: "Autofilled by tools yang dipilih",
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                Constant.xSizedBox8,
                CustomTextField.borderTextField(
                  readOnly: !sparepartP.isEdit,
                  enabled: true,
                  controller: sparepartP.warehouseC,
                  labelText: "Warehouse",
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
                  onTap: !sparepartP.isEdit
                      ? null
                      : () async {
                          WOWarehouseSearchModelData? result =
                              await CusNav.nPush(
                                  context, WOWarehouseSearchView());

                          FocusManager.instance.primaryFocus?.unfocus();
                          if (result != null) {
                            sparepartP.warehouseSelected = result;
                            sparepartP.warehouseC.text = result.name ?? "";
                            sparepartP.priceC.text = Utils.thousandSeparator(
                                int.parse(
                                    "${sparepartP.woCheckOaModel.data?.salePrice ?? "0"}"));
                            state(() {});
                            await context
                                .read<WORealizationProvider>()
                                .fetchWOCheckOA(withLoading: true);
                            sparepartP.priceC.text =
                                sparepartP.woCheckOaModel.data?.salePrice ??
                                    "0";
                            sparepartP.priceV =
                                sparepartP.woCheckOaModel.data?.salePrice ??
                                    "0";
                            sparepartP.typeC.text =
                                sparepartP.woCheckOaModel.data?.salePrice ??
                                    "0";
                            sparepartP.typeV =
                                sparepartP.woCheckOaModel.data?.type ?? "";
                            state(() {});
                          }
                        },
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                Constant.xSizedBox8,
                CustomTextField.borderTextField(
                  readOnly: !sparepartP.isEdit,
                  required: true,
                  enabled: true,
                  controller: sparepartP.quantity6C,
                  labelText: "Quantity",
                  hintText: "Input",
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                // Constant.xSizedBox8,
                // CustomTextField.borderTextField(
                //
                //   readOnly: false,

                //   controller: sparepartP.priceC,
                //   labelText: "Price",
                //   hintText: "Autofilled by tools yang dipilih",
                //   textInputType: TextInputType.text,
                //   textCapitalization: TextCapitalization.words,
                // ),
                // Constant.xSizedBox8,
                // CustomTextField.borderTextField(
                //
                //   controller: sparepartP.typeC,
                //   labelText: "Type",
                //   hintText: "Autofilled by tools yang dipilih",
                //   textInputType: TextInputType.text,
                //   textCapitalization: TextCapitalization.words,
                // ),
                Constant.xSizedBox8,
                CustomTextField.borderTextField(
                  controller: sparepartP.etaC,
                  readOnly: !sparepartP.isEdit,
                  labelText: "Req Date",
                  hintText: "dd-mm-yyyy",
                  onTap: () async {
                    final date = await CustomDatePicker.pickDateAndTime(
                        context, DateTime.now());

                    // log("REQ DATE : $date");
                    sparepartP.setReqDate(date);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  suffixIcon: Icon(Icons.calendar_month),
                  suffixIconColor: Constant.textHintColor,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                Constant.xSizedBox8,
                CustomTextField.borderTextArea(
                  controller: sparepartP.desc6C,
                  readOnly: !sparepartP.isEdit,
                  labelText: "Description",
                  hintText: "Free text",
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  focusNode: sparepartP.desc6Node,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                Constant.xSizedBox16,
                if (sparepartP.isEdit)
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
                          sparepartP.onEditOrAddButtonWoSparepart(
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

    Widget kontenSparepart() {
      return SingleChildScrollView(
        child: Container(
          child: sparepartP.listWoSparepartParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                    sparepartP.listWoSparepartParam.length,
                    (index) {
                      final item = sparepartP.listWoSparepartParam[index];
                      return InkWell(
                        onTap: () {
                          sparepartP.onTapWoSparepart(
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Code",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.code,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Warehouse",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.whName,
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Type",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.whCode,
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.unitName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Quantity",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.qty,
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Req Date",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.eta,
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "UOM",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.uom,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Price",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text("-",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Deskripsi",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.description,
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (sparepartP.isEdit)
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
                                          sparepartP.listWoSparepartParam
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

    Widget sparepartList() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sparepart List",
                style: Constant.grayMedium15.copyWith(color: Colors.grey),
              ),
              if (sparepartP.isEdit)
                CustomButton.smallMainButton("+ Add New", () async {
                  await sparepartP.createWoSparepart(
                      context: context, logPopUp: logPopUp());
                },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    textStyle: Constant.whiteBold)
            ],
          ),
          Constant.xSizedBox16,
          kontenSparepart(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "${sparepartP.isEdit ? "Edit" : "View"} WO Realization",
        onBack: () {
          if (sparepartP.isEdit)
            sparepartP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (sparepartP.isEdit) {
            sparepartP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (!sparepartP.isEdit) headerWo(context),
                subHeaderWo(5, context),
                Constant.xSizedBox32,
                sparepartList(),
                Constant.xSizedBox32,
                Constant.xSizedBox32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          sparepartP.isEdit ? sparepartP.cancelSaveButton(context) : null,
    );
  }
}
