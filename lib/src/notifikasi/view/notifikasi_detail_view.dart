import 'dart:async';
import 'dart:developer';

import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/src/notifikasi/provider/notifikasi_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

import '../../../common/component/custom_navigator.dart';
import '../../../common/helper/constant.dart';
import '../../../utils/utils.dart';

class DetailNotifikasiView extends StatefulWidget {
  final String docCode;
  final String type;
  final String woId;
  final bool action;
  const DetailNotifikasiView({
    super.key,
    required this.docCode,
    required this.type,
    required this.woId,
    required this.action,
  });

  @override
  State<DetailNotifikasiView> createState() => _DetailNotifikasiViewState();
}

class _DetailNotifikasiViewState extends BaseState<DetailNotifikasiView> {
  @override
  void initState() {
    context.read<NotifikasiProvider>()
          ..controller = Completer<PDFViewController>()
          ..fetchViewNotif(id: widget.woId, type: widget.type)
        // ..createFileOfPdfUrl()
        ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dNP = context.watch<NotifikasiProvider>();
    final detailNotifP =
        context.watch<NotifikasiProvider>().notifikasiViewModel.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        widget.docCode,
        // action: <Widget>[
        //   IconButton(icon: Icon(Icons.share), onPressed: () async {
        //     await
        //   }),
        // ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              if (widget.action)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: CustomButton.secondaryButtonWithicon(
                          Image.asset('assets/icons/ic-reject.png', scale: 3),
                          "Reject",
                          () async {
                            await Utils.showYesNoWithNoteDialog(
                              context: context,
                              title: "Konfirmasi",
                              desc: "Apakah Anda Yakin Ingin Reject WO Ini?",
                              yesText: "Reject",
                              yesCallback: () async {
                                CusNav.nPop(context);
                                try {
                                  await context
                                      .read<NotifikasiProvider>()
                                      .approveRejectWO(
                                          type: "reject", id: widget.woId)
                                      .then((value) async {
                                    await Utils.showSuccess(
                                        msg: "Reject Success");
                                    context
                                        .read<NotifikasiProvider>()
                                        .noteN
                                        .unfocus();
                                    context
                                        .read<NotifikasiProvider>()
                                        .noteC
                                        .clear();
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          borderColor: Constant.redColor,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                      ),
                      Constant.xSizedBox8,
                      Expanded(
                        flex: 5,
                        child: CustomButton.secondaryButtonWithicon(
                          Image.asset('assets/icons/ic-approve.png', scale: 3),
                          "Approve",
                          () async {
                            await Utils.showYesNoWithNoteDialog(
                              context: context,
                              title: "Konfirmasi",
                              desc: "Apakah Anda Yakin Ingin Approve WO Ini?",
                              yesText: "Approve",
                              yesCallback: () async {
                                CusNav.nPop(context);
                                try {
                                  await context
                                      .read<NotifikasiProvider>()
                                      .approveRejectWO(
                                          type: "approve", id: widget.woId)
                                      .then((value) async {
                                    await Utils.showSuccess(
                                        msg: "Approve Success");
                                    context
                                        .read<NotifikasiProvider>()
                                        .noteN
                                        .unfocus();
                                    context
                                        .read<NotifikasiProvider>()
                                        .noteC
                                        .clear();
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          borderColor: Constant.greenColor,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                      ),
                    ],
                  ),
                ),
              Constant.xSizedBox16,
              Expanded(
                child: PDF(
                  fitEachPage: false,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  // autoSpacing: false,
                  pageFling: true,
                  pageSnap: false,
                  defaultPage: dNP.currentPage!,
                  fitPolicy: FitPolicy.BOTH,
                  preventLinkNavigation:
                      true, // if set to true the link is handled in flutter
                  onRender: (_pages) {
                    dNP.pages = _pages;
                    dNP.isReady = true;
                    setState(() {});
                  },
                  onError: (error) {
                    dNP.errorMessage = error.toString();
                    log(error.toString());
                    setState(() {});
                  },
                  onPageError: (page, error) {
                    dNP.errorMessage = '$page: ${error.toString()}';
                    setState(() {});
                    log('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    dNP.controller.complete(pdfViewController);
                    setState(() {});
                  },
                  onLinkHandler: (String? uri) {
                    setState(() {});
                    log('goto uri: $uri');
                  },
                  onPageChanged: (int? page, int? total) {
                    log('page change: $page/$total');

                    dNP.currentPage = page;
                    setState(() {});
                  },
                ).cachedFromUrl(
                  dNP.remotePDFpath,
                  placeholder: (progress) =>
                      Center(child: Text('Memuat PDF $progress %')),
                  errorWidget: (error) => Center(child: Text(error.toString())),
                ),
              ),
            ],
          ),
          // if (dNP.remotePDFpath == "")
          //   dNP.errorMessage.isEmpty
          //       ? !dNP.isReady
          //           ? Center(child: CircularProgressIndicator())
          //           : Container()
          //       : Center(child: Text(dNP.errorMessage))
        ],
      ),
    );
  }
}
