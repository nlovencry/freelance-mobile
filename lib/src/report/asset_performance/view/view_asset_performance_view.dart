import 'package:bimops/common/base/base_state.dart';
import 'package:bimops/common/component/custom_appbar.dart';
import 'package:bimops/common/component/custom_navigator.dart';
import 'package:bimops/common/helper/constant.dart';
import 'package:bimops/src/report/asset_performance/provider/asset_performance_provider.dart';
import 'package:bimops/src/report/asset_performance/view/print_asset_performance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';

class ViewAssetPerformanceView extends StatefulWidget {
  final String id;
  const ViewAssetPerformanceView({super.key, required this.id});

  @override
  State<ViewAssetPerformanceView> createState() =>
      _ViewAssetPerformanceViewState();
}

class _ViewAssetPerformanceViewState
    extends BaseState<ViewAssetPerformanceView> {
  @override
  void initState() {
    context
        .read<AssetPerformanceProvider>()
        .fetchViewAssetPerformance(id: widget.id, withLoading: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apP = context.watch<AssetPerformanceProvider>();
    final data = context
        .watch<AssetPerformanceProvider>()
        .viewAssetPerformanceModel
        .data;
    final line = context
        .watch<AssetPerformanceProvider>()
        .viewAssetPerformanceModel
        .data
        ?.line;
    final action = context
        .watch<AssetPerformanceProvider>()
        .viewAssetPerformanceModel
        .data
        ?.action;
    Widget headerAsset() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (action?.submit ?? false)
                    //submit
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          await Utils.showYesNoDialog(
                            context: context,
                            title: "Konfirmasi",
                            desc: "Apakah Anda Yakin Ingin Submit Data Ini?",
                            yesCallback: () async {
                              CusNav.nPop(context);
                              try {
                                await context
                                    .read<AssetPerformanceProvider>()
                                    .action(type: "submit")
                                    .then((value) async {
                                  await Utils.showSuccess(
                                      msg: "Submit Success");
                                  Future.delayed(Duration(seconds: 2),
                                      () => Navigator.pop(context));
                                });
                              } catch (e) {
                                Utils.showFailed(
                                    msg: e
                                            .toString()
                                            .toLowerCase()
                                            .contains("doctype")
                                        ? "Maaf, Terjadi Galat!"
                                        : "$e");
                              }
                            },
                            noCallback: () => CusNav.nPop(context),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic-submit.png',
                                  scale: 5,
                                ),
                                Constant.xSizedBox8,
                                Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (action?.approve ?? false)
                    //aprove
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          await Utils.showYesNoDialog(
                            context: context,
                            title: "Konfirmasi",
                            desc: "Apakah Anda Yakin Ingin Approve Data Ini?",
                            yesCallback: () async {
                              CusNav.nPop(context);
                              try {
                                await context
                                    .read<AssetPerformanceProvider>()
                                    .action(type: "approve")
                                    .then((value) async {
                                  await Utils.showSuccess(
                                      msg: "Approve Success");
                                  Future.delayed(Duration(seconds: 2),
                                      () => Navigator.pop(context));
                                });
                              } catch (e) {
                                Utils.showFailed(
                                    msg: e
                                            .toString()
                                            .toLowerCase()
                                            .contains("doctype")
                                        ? "Maaf, Terjadi Galat!"
                                        : "$e");
                              }
                            },
                            noCallback: () => CusNav.nPop(context),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic-approve.png',
                                  scale: 5,
                                ),
                                Constant.xSizedBox8,
                                Text(
                                  "Approve",
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (action?.reject ?? false)
                    //reject
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          await Utils.showYesNoDialog(
                            context: context,
                            title: "Konfirmasi",
                            desc: "Apakah Anda Yakin Ingin Reject Data Ini?",
                            yesCallback: () async {
                              CusNav.nPop(context);
                              try {
                                await context
                                    .read<AssetPerformanceProvider>()
                                    .action(type: "reject")
                                    .then((value) async {
                                  await Utils.showSuccess(
                                      msg: "Reject Success");
                                  Future.delayed(Duration(seconds: 2),
                                      () => Navigator.pop(context));
                                });
                              } catch (e) {
                                Utils.showFailed(
                                    msg: e
                                            .toString()
                                            .toLowerCase()
                                            .contains("doctype")
                                        ? "Maaf, Terjadi Galat!"
                                        : "$e");
                              }
                            },
                            noCallback: () => CusNav.nPop(context),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 1,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic-reject.png',
                                  scale: 5,
                                ),
                                Constant.xSizedBox8,
                                Text(
                                  "Reject",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (action?.theVoid ?? false)
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          await Utils.showYesNoDialog(
                            context: context,
                            title: "Konfirmasi",
                            desc: "Apakah Anda Yakin Ingin Void Data Ini?",
                            yesCallback: () async {
                              CusNav.nPop(context);
                              try {
                                await context
                                    .read<AssetPerformanceProvider>()
                                    .action(type: "void")
                                    .then((value) async {
                                  await Utils.showSuccess(msg: "Void Success");
                                  Future.delayed(Duration(seconds: 2),
                                      () => Navigator.pop(context));
                                });
                              } catch (e) {
                                Utils.showFailed(
                                    msg: e
                                            .toString()
                                            .toLowerCase()
                                            .contains("doctype")
                                        ? "Maaf, Terjadi Galat!"
                                        : "$e");
                              }
                            },
                            noCallback: () => CusNav.nPop(context),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic-void.png',
                                  scale: 5,
                                ),
                                Constant.xSizedBox8,
                                Text(
                                  "Void",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (action?.print ?? false)
                    //print
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          await Utils.showYesNoDialog(
                            context: context,
                            title: "Konfirmasi",
                            desc: "Apakah Anda Yakin Ingin Print Data Ini?",
                            yesCallback: () async {
                              CusNav.nPop(context);
                              try {
                                CusNav.nPop(context);
                                CusNav.nPush(context,
                                    PrintAssetPerformanceView(id: widget.id));
                                // await context
                                //     .read<AssetPerformanceProvider>()
                                //     .action(type: "print")
                                //     .then((value) async {
                                //   await Utils.showSuccess(msg: "Print Success");
                                //   Future.delayed(Duration(seconds: 2),
                                //       () => Navigator.pop(context));
                                // });
                              } catch (e) {
                                Utils.showFailed(
                                    msg: e
                                            .toString()
                                            .toLowerCase()
                                            .contains("doctype")
                                        ? "Maaf, Terjadi Galat!"
                                        : "$e");
                              }
                            },
                            noCallback: () => CusNav.nPop(context),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 1,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic-print.png',
                                  scale: 5,
                                ),
                                Constant.xSizedBox8,
                                Text(
                                  "Print",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (action?.delete ?? false)
                    //delete
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          await Utils.showYesNoDialog(
                            context: context,
                            title: "Konfirmasi",
                            desc: "Apakah Anda Yakin Ingin Delete Data Ini?",
                            yesCallback: () async {
                              CusNav.nPop(context);
                              try {
                                await context
                                    .read<AssetPerformanceProvider>()
                                    .action(type: "delete")
                                    .then((value) async {
                                  await Utils.showSuccess(
                                      msg: "Delete Success");
                                  Future.delayed(Duration(seconds: 2),
                                      () => Navigator.pop(context));
                                });
                              } catch (e) {
                                Utils.showFailed(
                                    msg: e
                                            .toString()
                                            .toLowerCase()
                                            .contains("doctype")
                                        ? "Maaf, Terjadi Galat!"
                                        : "$e");
                              }
                            },
                            noCallback: () => CusNav.nPop(context),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 1,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic-delete.png',
                                  scale: 5,
                                ),
                                Constant.xSizedBox8,
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget kontenList() {
      return SingleChildScrollView(
        child: Container(
          child: (line ?? []).isEmpty
              ? Text("Tidak ada, tambahkan data")
              : Column(
                  children: List.generate(
                    (line ?? []).length,
                    (index) {
                      final item = line?[index];
                      return InkWell(
                        onTap: null,
                        // onTap: () => CusNav.nPush(
                        //     context, PrintAssetPerformanceView(id: widget.id)),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "No",
                                    style: Constant.grayRegular
                                        .copyWith(fontSize: 10),
                                  ),
                                  SizedBox(height: 10),
                                  Text("1", style: Constant.grayRegular13),
                                ],
                              ),
                              SizedBox(
                                width: 8,
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
                                          "Kode Alat",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.assetCode ?? "",
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
                                          "Reliability",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.realibility ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jam PDM",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.pdm ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "MTTR",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.mttr ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
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
                                          "Nama Alat",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.assetName ?? "",
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
                                          "Jam Tersedia",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.jamAvailable ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jam PM",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.pm ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "MTBF",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.mtbf ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
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
                                          "Utilitas",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.utilisasi ?? "",
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
                                          "Jam AC",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.ac ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jam Operasi",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.jamOperasi ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
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
                                          "Availibility Kontrak",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.availabilityContract ?? "",
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
                                          "Jam SD",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.sd ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jam BDA",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.em ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
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
                                          "Availibility Real",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.availabilityReal ?? "",
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
                                          "Jam CM",
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.cm ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jumlah BDA",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constant.grayRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                        SizedBox(height: 10),
                                        Text(item?.totalDataEm ?? "",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "View Asset Performance"),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Document No",
                      style: Constant.grayRegular13.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                        flex: 6,
                        child: Text(
                          data?.docNo ?? "-",
                          style: Constant.blackBold16
                              .copyWith(fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ),
              SizedBox(height: 20),
              headerAsset(),
              SizedBox(height: 20),
              kontenList(),
            ],
          ),
        ),
      ),
    );
  }
}
