import 'package:bimops/common/component/custom_navigator.dart';
import 'package:bimops/src/work_order/wo_realization/provider/wo_realization_provider.dart';
import 'package:bimops/src/work_order/wo_realization/view/create_wo_realization/labours_wo_realization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/base/base_state.dart';
import '../../../../../common/component/custom_appbar.dart';
import '../../../../../common/component/custom_button.dart';
import '../../../../../common/component/custom_textField.dart';
import '../../../../../common/helper/constant.dart';
import '../../../../../utils/utils.dart';
import '../../model/wo_search.dart';
import '../header_wo_realization_view.dart';
import '../search/wo_service_search_view.dart';
import '../sub_header_wo_realization_view.dart';

class ServiceWORealization extends StatefulWidget {
  bool isEdit;
  ServiceWORealization({super.key, this.isEdit = false});

  @override
  State<ServiceWORealization> createState() => _ServiceWORealizationState();
}

class _ServiceWORealizationState extends BaseState<ServiceWORealization> {
  @override
  Widget build(BuildContext context) {
    final serviceP = context.watch<WORealizationProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return Container(
          height: 350,
          child: Column(
            children: [
              CustomTextField.borderTextField(
                readOnly: !serviceP.isEdit || !serviceP.isCreate,
                required: true,
                enabled: true,
                controller: serviceP.serviceC,
                labelText: "Service",
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
                onTap: !serviceP.isEdit
                    ? null
                    : () async {
                        WOServiceSearchModelData? result =
                            await CusNav.nPush(context, WOServiceSearchView());
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (result != null) {
                          serviceP.serviceSelected = result;
                          serviceP.serviceC.text = result.name ?? "0";
                          serviceP.uom5C.text = result.uom ?? "0";
                          state(() {});
                        }
                      },
              ),
              Constant.xSizedBox8,
              CustomTextField.borderTextField(
                readOnly: true,
                required: true,
                enabled: false,
                controller: serviceP.uom5C,
                labelText: "Uom",
                hintText: "Autofilled by service yang dipilih",
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              Constant.xSizedBox8,
              CustomTextField.borderTextField(
                readOnly: !serviceP.isEdit,
                required: true,
                enabled: true,
                controller: serviceP.quantity5C,
                labelText: "Quantity",
                hintText: "Input",
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              Constant.xSizedBox16,
              if (serviceP.isEdit || serviceP.isCreate)
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
                        serviceP.onEditOrAddButtonWoService(
                            context: context, index: index);
                      }),
                    )
                  ],
                )
            ],
          ),
        );
      });
    }

    Widget kontenService() {
      return SingleChildScrollView(
        child: Container(
          child: serviceP.listWoServiceParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(serviceP.listWoServiceParam.length,
                      (index) {
                    final item = serviceP.listWoServiceParam[index];
                    return InkWell(
                      onTap: () {
                        serviceP.onTapWoService(
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
                                    "Service",
                                    style: Constant.grayRegular
                                        .copyWith(fontSize: 10),
                                  ),
                                  SizedBox(height: 10),
                                  Text(item.serviceName,
                                      style: Constant.grayRegular13),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "UoM",
                                    style: Constant.grayRegular
                                        .copyWith(fontSize: 10),
                                  ),
                                  SizedBox(height: 10),
                                  Text(item.uom, style: Constant.grayRegular13),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Quantity",
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
                                      serviceP.listWoServiceParam
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

    Widget serviceList() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Service List",
                style: Constant.grayMedium15.copyWith(color: Colors.grey),
              ),
              if (serviceP.isEdit || serviceP.isCreate)
                CustomButton.smallMainButton(
                  "+ Add New",
                  () async {
                    await serviceP.createWoService(
                        context: context, logPopUp: logPopUp());
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  textStyle: Constant.whiteBold,
                ),
            ],
          ),
          Constant.xSizedBox16,
          kontenService(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "${serviceP.isEdit ? "Edit" : "View"} WO Realization",
        onBack: () {
          if (serviceP.isEdit)
            serviceP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (serviceP.isEdit) {
            serviceP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (!serviceP.isEdit) headerWo(context),
                subHeaderWo(4, context, isEdit: widget.isEdit),
                Constant.xSizedBox32,
                serviceList(),
                Constant.xSizedBox32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          serviceP.isEdit ? serviceP.cancelSaveButton(context) : null,
    );
  }
}
