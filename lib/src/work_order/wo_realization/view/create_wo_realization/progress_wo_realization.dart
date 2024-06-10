import 'package:mata/common/base/base_state.dart';
import 'package:mata/common/component/custom_date_picker.dart';
import 'package:mata/common/component/custom_image_picker.dart';
import 'package:mata/common/component/custom_navigator.dart';

import 'package:mata/src/work_order/wo_realization/provider/wo_realization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:path/path.dart' as path;
import '../../../../../common/component/custom_appbar.dart';
import '../../../../../common/component/custom_button.dart';
import '../../../../../common/component/custom_textField.dart';
import '../../../../../common/helper/constant.dart';
import '../../../../../utils/utils.dart';
import '../../model/wo_search.dart';
import '../header_wo_realization_view.dart';
import '../search/wo_progress_search_view.dart';
import '../sub_header_wo_realization_view.dart';

class ProgressWORealization extends StatefulWidget {
  // bool isEdit = false;
  ProgressWORealization({super.key});

  @override
  State<ProgressWORealization> createState() => _ProgressWORealizationState();
}

class _ProgressWORealizationState extends BaseState<ProgressWORealization> {
  @override
  Widget build(BuildContext context) {
    final progressP = context.watch<WORealizationProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  CustomTextField.borderTextField(
                    readOnly: !progressP.isEdit,
                    controller: progressP.desc8C,
                    labelText: "Description",
                    hintText: "Select",
                    hintColor: Constant.textHintColor,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/icons/ic-search.png',
                        width: 5,
                        height: 5,
                      ),
                    ),
                    onTap: !progressP.isEdit
                        ? null
                        : () async {
                            WOProgressSearchModelData? result =
                                await CusNav.nPush(
                                    context, WOProgressSearchView());

                            FocusManager.instance.primaryFocus?.unfocus();
                            if (result != null) {
                              progressP.progressSelected = result;
                              progressP.desc8C.text = result.description ?? "";
                              progressP.desc8V = result.description ?? "";
                              progressP.desc8IdV = result.id ?? "";
                              state(() {});
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                  ),
                  // CustomDropdown.normalDropdown(
                  //   required: true,
                  //   labelText: "Description",
                  //   hintText: "Select",
                  //   selectedItem: progressP.desc8V,
                  //   list: [
                  //     DropdownMenuItem(
                  //         value: "Pemeriksaan", child: Text("Pemeriksaan")),
                  //     DropdownMenuItem(
                  //         value: "Pembuatan Penawaran",
                  //         child: Text("Pembuatan Penawaran")),
                  //     DropdownMenuItem(
                  //         value: "Approval Penawaran",
                  //         child: Text("Approval Penawaran")),
                  //     DropdownMenuItem(
                  //         value: "Proses Pengadaan Part",
                  //         child: Text("Proses Pengadaan Part")),
                  //     DropdownMenuItem(
                  //         value: "Proses Pekerjaan",
                  //         child: Text("Proses Pekerjaan")),
                  //     DropdownMenuItem(
                  //         value: "Commissioning Test",
                  //         child: Text("Commissioning Test")),
                  //   ],
                  //   onChanged: (val) {
                  //     progressP.desc8V = val;
                  //   },
                  // ),
                  Constant.xSizedBox8,
                  CustomTextField.borderTextField(
                    controller: progressP.date8C,
                    labelText: "Date",
                    hintText: "dd-mm-yyyy",
                    readOnly: !progressP.isEdit,
                    onTap: !progressP.isEdit
                        ? null
                        : () async {
                            progressP.reqDate8 =
                                await CustomDatePicker.pickDateAndTime(
                                    context, DateTime.now());
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                    suffixIcon: Icon(Icons.calendar_month),
                    suffixIconColor: Constant.textHintColor,
                    required: true,
                  ),
                  Constant.xSizedBox8,
                  CustomTextField.borderTextField(
                    readOnly: !progressP.isEdit,
                    required: true,
                    enabled: true,
                    controller: progressP.justifyC,
                    labelText: "Justification",
                    hintText: "Input",
                    textInputType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                  ),
                  Constant.xSizedBox8,
                  CustomTextField.borderTextField(
                    readOnly: !progressP.isEdit,
                    required: true,
                    enabled: true,
                    controller: progressP.attach8C,
                    labelText: "Attachment",
                    hintText: "browse",
                    hintColor: Constant.textHintColor,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/icons/ic-browse.png',
                        width: 5,
                        height: 5,
                      ),
                    ),
                    onTap: !progressP.isEdit
                        ? null
                        : () async {
                            String fileName;
                            final file =
                                await CustomImagePicker.cameraOrGallery(
                                    context);
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (file != null) {
                              progressP.attach8C.text =
                                  path.basename(file.path);
                              fileName = path.basename(file.path);
                              progressP.imageAttachment2 = file;
                            }
                            setState(() {});
                          },
                  ),
                  Constant.xSizedBox16,
                  if (progressP.isEdit)
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
                            progressP.onEditOrAddButtonWoProgress(
                                context: context, index: index);
                          }),
                        )
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget kontenActivity() {
      return SingleChildScrollView(
        child: Container(
          child: progressP.listWoProgressParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                    progressP.listWoProgressParam.length,
                    (index) {
                      final item = progressP.listWoProgressParam[index];
                      return InkWell(
                        onTap: () {
                          progressP.onTapWoProgress(
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
                                          "Description",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item.baseProgressId,
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
                                          "Justification",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text("SESUAI HASIL PEMERIKSAAN",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 30,
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
                                          "Date",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text("04/03/2024",
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
                                          "Attachment",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text("DSC_8971 (2).JPG",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (progressP.isEdit)
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
                                          progressP.listWoProgressParam
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

    Widget progressList() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress List",
                style: Constant.grayMedium15.copyWith(color: Colors.grey),
              ),
              if (progressP.isEdit)
                CustomButton.smallMainButton("+ Add New", () async {
                  await progressP.createWoProgress(
                      context: context, logPopUp: logPopUp());
                },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    textStyle: Constant.whiteBold)
            ],
          ),
          Constant.xSizedBox16,
          kontenActivity(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "${progressP.isEdit ? "Edit" : "View"} WO Realization",
        onBack: () {
          if (progressP.isEdit)
            progressP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (progressP.isEdit) {
            progressP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (!progressP.isEdit) headerWo(context),
                subHeaderWo(7, context),
                Constant.xSizedBox32,
                progressList(),
                Constant.xSizedBox32,
                Constant.xSizedBox32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          progressP.isEdit ? progressP.cancelSaveButton(context) : null,
    );
  }
}
