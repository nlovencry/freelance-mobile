import 'package:mata/src/work_order/wo_agreement/provider/wo_agreement_provider.dart';
import 'package:mata/src/work_order/wo_agreement/view/create_wo_agreement/labours_wo_agreement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../common/base/base_state.dart';
import '../../../../../common/component/custom_appbar.dart';
import '../../../../../common/component/custom_button.dart';
import '../../../../../common/component/custom_navigator.dart';
import '../../../../../common/component/custom_textField.dart';
import '../../../../../common/helper/constant.dart';
import '../../../../../utils/utils.dart';
import '../../model/wo_search.dart';
import '../header_wo_agreement_view.dart';
import '../search/wo_service_search_view.dart';
import '../sub_header_wo_agreement_view.dart';

class ServiceWOAgreement extends StatefulWidget {
  ServiceWOAgreement({super.key});

  @override
  State<ServiceWOAgreement> createState() => _ServiceWOAgreementState();
}

class _ServiceWOAgreementState extends BaseState<ServiceWOAgreement> {
  @override
  Widget build(BuildContext context) {
    final serviceP = context.watch<WOAgreementProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return Container(
          height: 350,
          child: Column(
            children: [
              CustomTextField.borderTextField(
                readOnly: !serviceP.isEdit && !serviceP.isCreate,
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
                onTap: !serviceP.isEdit && !serviceP.isCreate
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
                readOnly: !serviceP.isEdit && !serviceP.isCreate,
                required: true,
                enabled: true,
                controller: serviceP.quantity5C,
                labelText: "Quantity",
                hintText: "Input",
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
                  FilteringTextInputFormatter.digitsOnly
                ],
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
          padding: EdgeInsets.only(bottom: 64),
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
                            if (serviceP.isEdit || serviceP.isCreate)
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
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
          ),
          kontenService(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        serviceP.isCreate
            ? "Create WO Agreement"
            : "${serviceP.isEdit ? "Edit" : "View"} WO Agreement",
        onBack: () {
          if (serviceP.isEdit && !serviceP.isCreate)
            serviceP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (serviceP.isEdit && !serviceP.isCreate) {
            serviceP.isEdit = false;
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
                  if (!serviceP.isEdit && !serviceP.isCreate) headerWo(context),
                  subHeaderWo(4, context),
                  Constant.xSizedBox32,
                  serviceList(),
                  Constant.xSizedBox32,
                ],
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: serviceP.isEdit || serviceP.isCreate
          ? serviceP.cancelSaveButton(context)
          : null,
    );
  }
}
