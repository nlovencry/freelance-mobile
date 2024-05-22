import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/wo_agreement_provider.dart';
import '../../../../common/component/custom_navigator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';

String assetPath = "assets/icons/";

List<String> name = [
  "Submit",
  "Edit",
  "Delete",
  "Approve",
  "Reject",
];
List<String> iconsName = [
  "ic-submit",
  "ic-edit",
  "ic-delete",
  "ic-approve",
  "ic-reject",
];

List<Color> color = [
  Colors.orange,
  Colors.blueAccent,
  Colors.red,
  Colors.green,
  Colors.redAccent,
];

Widget headerWo(BuildContext context) {
  final p = context.read<WOAgreementProvider>();
  final actionData =
      context.read<WOAgreementProvider>().woAgreementModelData.action;
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    child: Wrap(
      spacing: 8,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: List.generate(
        name.length,
        (index) {
          final itemName = name[index];
          final iconName = iconsName[index];
          final itemColor = color[index];
          bool enable = false;
          if (index == 0) enable = actionData?.submit ?? false;
          if (index == 1) enable = actionData?.edit ?? false;
          if (index == 2) enable = actionData?.delete ?? false;
          if (index == 3) enable = actionData?.approve ?? false;
          if (index == 4) enable = actionData?.reject ?? false;
          if (!enable) return SizedBox();
          return InkWell(
            onTap: () async {
              if (index != 1 && enable)
                await Utils.showYesNoDialog(
                  context: context,
                  title: "Konfirmasi",
                  desc: "Apakah Anda Yakin Ingin ${itemName} Data Ini?",
                  yesCallback: () async {
                    CusNav.nPop(context);
                    try {
                      await context
                          .read<WOAgreementProvider>()
                          .action(type: itemName.toLowerCase())
                          .then((value) async {
                        await Utils.showSuccess(msg: "${itemName} Success");
                        Future.delayed(
                            Duration(seconds: 2), () => Navigator.pop(context));
                      });
                    } catch (e) {
                      Utils.showFailed(
                          msg: e.toString().toLowerCase().contains("doctype")
                              ? "Maaf, Terjadi Galat!"
                              : "$e");
                    }
                  },
                  noCallback: () => CusNav.nPop(context),
                );
              if (index == 1 && enable) {
                await Utils.showYesNoDialog(
                  context: context,
                  title: "Konfirmasi",
                  desc: "Apakah Anda Yakin Ingin ${itemName} Data Ini?",
                  yesCallback: () async {
                    CusNav.nPop(context);
                    try {
                      p.isEdit = true;
                    } catch (e) {
                      Utils.showFailed(
                          msg: e.toString().toLowerCase().contains("doctype")
                              ? "Maaf, Terjadi Galat!"
                              : "$e");
                    }
                  },
                  noCallback: () => CusNav.nPop(context),
                );
              }
            },
            child: Container(
              width: 90,
              padding: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: enable ? itemColor : Constant.grayColor,
                      width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    '${assetPath}${iconName}.png',
                    scale: 5,
                    color: enable ? null : Constant.grayColor,
                  ),
                  Constant.xSizedBox8,
                  Text(itemName,
                      style: TextStyle(
                          color: enable ? itemColor : Constant.grayColor)),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
