import 'package:bimops/common/component/custom_appbar.dart';
import 'package:bimops/common/component/custom_button.dart';
import 'package:bimops/common/component/custom_textField.dart';
import 'package:bimops/common/helper/constant.dart';
import 'package:bimops/src/work_order/wo_agreement/provider/wo_agreement_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../common/base/base_state.dart';
import '../../../../../common/component/custom_navigator.dart';
import '../../../../../utils/utils.dart';
import '../header_wo_agreement_view.dart';
import '../sub_header_wo_agreement_view.dart';

class ActivityWOAgreement extends StatefulWidget {
  ActivityWOAgreement({super.key});

  @override
  State<ActivityWOAgreement> createState() => _ActivityWOAgreementState();
}

class _ActivityWOAgreementState extends BaseState<ActivityWOAgreement> {
  @override
  Widget build(BuildContext context) {
    final activityP = context.watch<WOAgreementProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return Container(
          height: 300,
          child: Column(
            children: [
              CustomTextField.borderTextField(
                readOnly: !activityP.isEdit && !activityP.isCreate,
                required: true,
                enabled: true,
                controller: activityP.taskNameC,
                labelText: "Task Name",
                hintText: "Input",
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              Constant.xSizedBox8,
              CustomTextField.borderTextField(
                readOnly: !activityP.isEdit && !activityP.isCreate,
                required: true,
                enabled: true,
                controller: activityP.taskDurationC,
                labelText: "Task Duration",
                hintText: "Input",
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
                  FilteringTextInputFormatter.digitsOnly
                  ],
              ),
              Constant.xSizedBox16,
              if (activityP.isEdit || activityP.isCreate)
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
                        activityP.onEditOrAddButtonWoActivities(
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

    Widget kontenActivity() {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 64),
          width: 600,
          child: activityP.listWoActivitiesParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                    activityP.listWoActivitiesParam.length,
                    (index) {
                      final item = activityP.listWoActivitiesParam[index];
                      return InkWell(
                        onTap: () {
                          activityP.onTapWoActivites(
                            context: context,
                            index: index,
                            logPopUp: logPopUp(index: index),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Row(
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
                                      "Task Name",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text(item.taskName,
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
                                      "Task Duration",
                                      style: Constant.grayRegular
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text("${item.taskDuration} Menit",
                                        style: Constant.grayRegular13),
                                  ],
                                ),
                              ),
                              if (activityP.isEdit || activityP.isCreate)
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
                                          activityP.listWoActivitiesParam
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
                                )
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

    Widget activitiesList() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activities List",
                  style: Constant.grayMedium15.copyWith(color: Colors.grey),
                ),
                if (activityP.isEdit || activityP.isCreate)
                  CustomButton.smallMainButton(
                    "+ Add New",
                    () async {
                      await activityP.createWoActivities(
                          context: context, logPopUp: logPopUp());
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    textStyle: Constant.whiteBold,
                  )
              ],
            ),
          ),
          kontenActivity(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        activityP.isCreate
            ? "Create WO Agreement"
            : activityP.isCreate
                ? "Create WO Agreement"
                : "${activityP.isEdit ? "Edit" : "View"} WO Agreement",
        onBack: () {
          if (activityP.isEdit && !activityP.isCreate)
            activityP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (activityP.isEdit && !activityP.isCreate) {
            activityP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (!activityP.isEdit && !activityP.isCreate)
                  headerWo(context),
                subHeaderWo(1,context),
                Constant.xSizedBox32,
                activitiesList(),
                Constant.xSizedBox32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: activityP.isEdit || activityP.isCreate
          ? activityP.cancelSaveButton(context)
          : null,
    );
  }
}
