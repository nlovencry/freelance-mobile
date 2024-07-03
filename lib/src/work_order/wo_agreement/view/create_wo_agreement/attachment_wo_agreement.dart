import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/common/component/custom_image_picker.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/common/helper/safe_network_image.dart';

import 'package:path/path.dart' as path;
import 'package:hy_tutorial/src/work_order/wo_agreement/provider/wo_agreement_provider.dart';
import 'package:hy_tutorial/src/work_order/wo_agreement/view/create_wo_agreement/labours_wo_agreement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/component/custom_navigator.dart';
import '../../../../../common/component/custom_textfield.dart';
import '../../../../../utils/utils.dart';
import '../header_wo_agreement_view.dart';
import '../sub_header_wo_agreement_view.dart';

class AttachmentWOAgreement extends StatefulWidget {
  AttachmentWOAgreement({super.key});

  @override
  State<AttachmentWOAgreement> createState() => _AttachmentWOAgreementState();
}

class _AttachmentWOAgreementState extends BaseState<AttachmentWOAgreement> {
  @override
  Widget build(BuildContext context) {
    final attachmentP = context.watch<WOAgreementProvider>();
    Widget logPopUp({int? index}) {
      return StatefulBuilder(builder: (context, state) {
        return Container(
          height: 350,
          child: Column(
            children: attachmentP.isEdit || attachmentP.isCreate
                ? [
                    CustomTextField.borderTextField(
                      controller: attachmentP.attachC,
                      labelText: "Attachment",
                      hintText: attachmentP.attachC.text != ""
                          ? attachmentP.attachC.text
                          : "Browse",
                      hintColor: Constant.textHintColor,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset('assets/icons/ic-browse.png',
                            width: 5, height: 5),
                      ),
                      readOnly: false,
                      onTap: () async {
                        String fileName;
                        final file =
                            await CustomImagePicker.cameraOrGallery(context);

                        FocusManager.instance.primaryFocus?.unfocus();
                        if (file != null) {
                          fileName = path.basename(file.path);
                          attachmentP.attachC.text = fileName;
                          attachmentP.imageAttachment1 = file;
                        }
                      },
                    ),
                    Constant.xSizedBox8,
                    CustomTextField.borderTextArea(
                      controller: attachmentP.desc7C,
                      labelText: "Description",
                      hintText: "Free text",
                      textInputType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      focusNode: attachmentP.desc7Node,
                    ),
                    Constant.xSizedBox16,
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
                            attachmentP.onEditOrAddButtonWoAttachment(
                                context: context, index: index);
                          }),
                        )
                      ],
                    ),
                  ]
                : [
                    Container(
                      height: 200,
                      child: SafeNetworkImage(
                        url: attachmentP.fileAttach7Url ?? "",
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                    Constant.xSizedBox16,
                    Text(attachmentP.desc7C.text != ""
                        ? attachmentP.desc7C.text
                        : "-"),
                  ],
          ),
        );
      });
    }

    Widget kontenAttachment() {
      return SingleChildScrollView(
        child: Container(
          width: 600,
          child: attachmentP.listWoAttachmentParam.isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                      attachmentP.listWoAttachmentParam.length, (index) {
                    final item = attachmentP.listWoAttachmentParam[index];
                    return InkWell(
                      onTap: () {
                        attachmentP.onTapWoAttachment(
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
                              flex: 4,
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
                            if (attachmentP.isEdit || attachmentP.isCreate)
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
                                        attachmentP.listWoAttachmentParam
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

    Widget attachmentList() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Attachment List",
                    style: Constant.grayMedium15.copyWith(color: Colors.grey)),
                if (attachmentP.isEdit || attachmentP.isCreate)
                  CustomButton.smallMainButton("+ Add New", () async {
                    await attachmentP.createWoAttachment(
                        context: context, logPopUp: logPopUp());
                  },
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      textStyle: Constant.whiteBold)
              ],
            ),
          ),
          kontenAttachment(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        attachmentP.isCreate
            ? "Create WO Agreement"
            : "${attachmentP.isEdit ? "Edit" : "View"} WO Agreement",
        onBack: () {
          if (attachmentP.isEdit && !attachmentP.isCreate)
            attachmentP.isEdit = false;
          else
            CusNav.nPop(context);
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (attachmentP.isEdit && !attachmentP.isCreate) {
            attachmentP.isEdit = false;
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
                  if (!attachmentP.isEdit && !attachmentP.isCreate)
                    headerWo(context),
                  subHeaderWo(6, context),
                  Constant.xSizedBox32,
                  attachmentList(),
                  Constant.xSizedBox32,
                ],
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: attachmentP.isEdit || attachmentP.isCreate
          ? attachmentP.cancelSaveButton(context)
          : null,
    );
  }
}
