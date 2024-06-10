import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_button.dart';
import 'package:mata/common/component/custom_navigator.dart';
import 'package:mata/common/component/custom_textField.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/work_order/view/wo_search_view.dart';
import 'package:mata/src/work_order/wo_realization/provider/wo_realization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:path/path.dart' as path;
import '../../../../../common/component/custom_image_picker.dart';
import '../../../../../common/helper/safe_network_image.dart';
import '../header_wo_realization_view.dart';
import '../sub_header_wo_realization_view.dart';

class AttachmentRealizationView extends StatefulWidget {
  AttachmentRealizationView({super.key});

  @override
  State<AttachmentRealizationView> createState() =>
      _AttachmentRealizationViewState();
}

class _AttachmentRealizationViewState extends State<AttachmentRealizationView> {
  @override
  Widget build(BuildContext context) {
    final attchrealP = context.watch<WORealizationProvider>();

    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return Container(
          height: 350,
          child: Column(
            children: [
              CustomTextField.borderTextField(
                readOnly: !attchrealP.isEdit,
                required: true,
                enabled: true,
                controller: attchrealP.attach10C,
                labelText: "Attachment",
                hintText: attchrealP.attach10C.text != ""
                    ? attchrealP.attach10C.text
                    : "browse",
                hintColor: Constant.textHintColor,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset('assets/icons/ic-browse.png',
                      width: 5, height: 5),
                ),
                onTap: !attchrealP.isEdit
                    ? null
                    : () async {
                        String fileName;
                        final file =
                            await CustomImagePicker.cameraOrGallery(context);

                        FocusManager.instance.primaryFocus?.unfocus();
                        if (file != null) {
                          fileName = path.basename(file.path);
                          attchrealP.attach10C.text = fileName;
                          attchrealP.imageAttachment1 = file;
                        }
                        setState(() {});
                      },
              ),
              Constant.xSizedBox8,
              CustomTextField.borderTextArea(
                controller: attchrealP.desc10C,
                readOnly: !attchrealP.isEdit,
                labelText: "Description",
                hintText: "Free text",
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                focusNode: attchrealP.desc10Node,
              ),
              Constant.xSizedBox16,
              if (attchrealP.isEdit)
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
                        attchrealP.onEditOrAddButtonWoAttachment2(
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

    Widget logPopUpPreview({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return Container(
          height: 350,
          child: Column(
            children:
                // attchrealP.isEdit
                //     ? [
                //         CustomTextField.borderTextField(
                //           controller: attchrealP.attachC,
                //           labelText: "Attachment",
                //           hintText: attchrealP.attachC.text != ""
                //               ? attchrealP.attachC.text
                //               : "Browse",
                //           hintColor: Constant.textHintColor,
                //           suffixIcon: Padding(
                //             padding: const EdgeInsets.all(12),
                //             child: Image.asset('assets/icons/ic-browse.png',
                //                 width: 5, height: 5),
                //           ),
                //           readOnly: false,
                //           onTap: () async {
                //             String fileName;
                //             final file =
                //                 await CustomImagePicker.cameraOrGallery(context);

                //             FocusManager.instance.primaryFocus?.unfocus();
                //             if (file != null) {
                //               fileName = path.basename(file.path);
                //               attchrealP.attachC.text = fileName;
                //             }
                //           },
                //         ),
                //         Constant.xSizedBox8,
                //         CustomTextField.borderTextArea(
                //           controller: attchrealP.desc7C,
                //           labelText: "Description",
                //           hintText: "Free text",
                //           textInputType: TextInputType.text,
                //           textCapitalization: TextCapitalization.words,
                //           focusNode: attchrealP.desc7Node,
                //         ),
                //         Constant.xSizedBox16,
                //         Row(
                //           children: [
                //             Expanded(
                //                 flex: 5,
                //                 child:
                //                     CustomButton.secondaryButton("Cancel", () {})),
                //             Constant.xSizedBox8,
                //             Expanded(
                //               flex: 5,
                //               child: CustomButton.mainButton(
                //                   index != null ? "Edit" : "Add", () {
                //                 attchrealP.onEditOrAddButtonWoAttachment(
                //                     context: context, index: index);
                //               }),
                //             )
                //           ],
                //         ),
                //       ]
                //     :
                [
              Container(
                height: 200,
                child: SafeNetworkImage(
                  url: attchrealP.fileAttach10Url ?? "",
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Constant.xSizedBox16,
              Text(attchrealP.desc10C.text != ""
                  ? attchrealP.desc10C.text
                  : "-"),
            ],
          ),
        );
      });
    }

    Widget kontenAttachment() {
      return SingleChildScrollView(
        child: Container(
          child: attchrealP.listWoAttachmentRealizationParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                      attchrealP.listWoAttachmentRealizationParam.length,
                      (index) {
                    final item =
                        attchrealP.listWoAttachmentRealizationParam[index];
                    return InkWell(
                      onTap: () {
                        attchrealP.editOrPreview(
                          context: context,
                          onEdit: () {
                            attchrealP.onTapWoAttachment2(
                              context: context,
                              index: index,
                              isPreview: false,
                              logPopUp: logPopUp(index: index),
                            );
                          },
                          onPreview: () {
                            attchrealP.onTapWoAttachment2(
                              context: context,
                              index: index,
                              isPreview: true,
                              logPopUp: logPopUpPreview(index: index),
                            );
                          },
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
                                    "Attachment",
                                    style: Constant.grayRegular
                                        .copyWith(fontSize: 10),
                                  ),
                                  SizedBox(height: 10),
                                  Text(item.fileName,
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
                                    "Description",
                                    style: Constant.grayRegular
                                        .copyWith(fontSize: 10),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    item.description,
                                    style: Constant.grayRegular13
                                        .copyWith(fontSize: 15),
                                  ),
                                ],
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

    Widget attachmentList() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attachment Realisasi List",
                style: Constant.grayMedium15.copyWith(color: Colors.grey),
              ),
              if (attchrealP.isEdit)
                CustomButton.smallMainButton("+ Add New", () async {
                  await attchrealP.createWoAttachment2(
                      context: context, logPopUp: logPopUp());
                },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    textStyle: Constant.whiteBold)
            ],
          ),
          Constant.xSizedBox16,
          kontenAttachment(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "${attchrealP.isEdit ? "Edit" : "View"} WO Realization",
        onBack: () {
          if (attchrealP.isEdit)
            attchrealP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (attchrealP.isEdit) {
            attchrealP.isEdit = false;
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (!attchrealP.isEdit) headerWo(context),
                subHeaderWo(9, context),
                Constant.xSizedBox32,
                attachmentList(),
                Constant.xSizedBox32,
                Constant.xSizedBox32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          attchrealP.isEdit ? attchrealP.cancelSaveButton(context) : null,
    );
  }
}
