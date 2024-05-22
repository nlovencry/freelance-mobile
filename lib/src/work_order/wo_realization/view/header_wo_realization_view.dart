import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/wo_realization_provider.dart';
import '../../../../common/component/custom_navigator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';

String assetPath = "assets/icons/";

List<String> name = [
  "Submit",
  "Realisasi",
  "Approve",
  "Reject",
  "BA Persetujuan",
  "BA Realisasi",
  "Void",
];
List<String> iconsName = [
  "ic-submit",
  "ic-realisasi",
  "ic-approve",
  "ic-reject",
  "ic-ba",
  "ic-ba",
  "ic-void",
];

List<Color> color = [
  Colors.orange,
  Colors.blueAccent,
  Colors.green,
  Colors.red,
  Colors.blueAccent,
  Colors.blueAccent,
  Colors.black54,
];

Widget headerWo(BuildContext context) {
  final p = context.read<WORealizationProvider>();
  final actionData =
      context.read<WORealizationProvider>().woRealizationModelData.action;
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    child: Wrap(
      spacing: 7,
      runSpacing: 12,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center,
      children: List.generate(
        name.length,
        (index) {
          final itemName = name[index];
          final iconName = iconsName[index];
          final itemColor = color[index];
          bool enable = false;
          if (index == 0) enable = actionData?.submit ?? false;
          if (index == 1) enable = actionData?.realisasi ?? false;
          if (index == 2) enable = actionData?.approve ?? false;
          if (index == 3) enable = actionData?.reject ?? false;
          if (index == 4) enable = actionData?.baPersetujuan ?? false;
          if (index == 5) enable = actionData?.baRealisasi ?? false;
          if (index == 6) enable = actionData?.theVoid ?? false;
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
                          .read<WORealizationProvider>()
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
              width: 120,
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
                  Flexible(
                    child: Text(itemName,
                        style: TextStyle(
                            color: enable ? itemColor : Constant.grayColor)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
