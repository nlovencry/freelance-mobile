import 'dart:async';
import 'dart:developer';

import 'package:bimops/common/base/base_state.dart';
import 'package:bimops/common/component/custom_appbar.dart';
import 'package:bimops/common/component/custom_navigator.dart';
import 'package:bimops/common/helper/constant.dart';
import 'package:bimops/common/helper/launch_url.dart';
import 'package:bimops/src/report/download_ba/provider/ba_provider.dart';
import 'package:bimops/src/report/download_ba/view/detail_view_download_ba_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/helper/convert_date.dart';
import '../../../../common/helper/download.dart';
import '../../../../main.dart';

class ViewDownloadBAView extends StatefulWidget {
  final String id;
  final String docNo;
  const ViewDownloadBAView({super.key, required this.id, required this.docNo});

  @override
  State<ViewDownloadBAView> createState() => _ViewDownloadBAViewState();
}

class _ViewDownloadBAViewState extends BaseState<ViewDownloadBAView> {
  @override
  void initState() {
    context.read<BAProvider>()
          ..controller = Completer<PDFViewController>()
          ..controller2 = Completer<PDFViewController>()
          ..fetchViewBA(id: widget.id)
        // ..createFileOfPdfUrlPersetujuan()
        // ..createFileOfPdfUrlRealisasi()
        ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final baP = context.watch<BAProvider>();
    final printP = context.watch<BAProvider>().baModel.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Download BA"),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
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
                            widget.docNo,
                            style: Constant.blackBold16
                                .copyWith(fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                ),
                Constant.xSizedBox24,
                baP.remotePDFpath == ""
                    ? SizedBox()
                    : InkWell(
                        onTap: baP.remotePDFpath == ""
                            ? null
                            : () => CusNav.nPush(
                                context,
                                DetailViewDownloadBAView(
                                    typeBA: "Persetujuan",
                                    docNo: widget.docNo)),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "BA Persetujuan",
                                style: Constant.iPrimaryMedium8
                                    .copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              InkWell(
                                onTap: () async {
                                  log("LINK DOWNLOAD BA PERSETUJUAN : ${baP.remotePDFpath}");
                                  await requestPermission(
                                      Permission.manageExternalStorage);
                                  if (baP.remotePDFpath != "") {
                                    await requestPermission(
                                        Permission.manageExternalStorage);
                                    await downloadFile(
                                      context,
                                      baP.remotePDFpath,
                                      filename:
                                          "${widget.docNo}-Persetujuan-${convertTglCombine(DateTime.now().toString())}",
                                      openAfterDownload: true,
                                      typeFile: 'pdf',
                                    );
                                  }
                                },
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
                                        scale: 3,
                                      ),
                                      Constant.xSizedBox8,
                                      Text(
                                        "Download",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                Constant.xSizedBox16,
                Container(
                  height: 25.h,
                  child: baP.remotePDFpath == ""
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("PDF Tidak Tersedia"),
                        )
                      : PDF(
                          // filePath: baP.remotePDFpath,
                          fitEachPage: true,
                          enableSwipe: false,
                          swipeHorizontal: false,
                          autoSpacing: true,
                          pageFling: true,
                          pageSnap: true,
                          defaultPage: baP.currentPage!,
                          fitPolicy: FitPolicy.WIDTH,
                          preventLinkNavigation:
                              true, // if set to true the link is handled in flutter
                          onRender: (_pages) {
                            baP.pages = _pages;
                            baP.isReady = true;
                          },
                          onError: (error) {
                            baP.errorMessage = error.toString();
                            log(error.toString());
                          },
                          onPageError: (page, error) {
                            baP.errorMessage = '$page: ${error.toString()}';

                            log('$page: ${error.toString()}');
                          },
                          onViewCreated: (PDFViewController pdfViewController) {
                            baP.controller.complete(pdfViewController);
                          },
                          onLinkHandler: (String? uri) {
                            log('goto uri: $uri');
                          },
                          onPageChanged: (int? page, int? total) {
                            log('page change: $page/$total');

                            baP.currentPage = page;
                          },
                        ).cachedFromUrl(
                          baP.remotePDFpath,
                          placeholder: (progress) => Center(
                              child: Text('Memuat BA Persetujuan $progress %')),
                          errorWidget: (error) =>
                              Center(child: Text(error.toString())),
                        ),
                ),
                Constant.xSizedBox16,
                InkWell(
                  onTap: baP.remotePDFpath2 == ""
                      ? null
                      : () => CusNav.nPush(
                          context,
                          DetailViewDownloadBAView(
                              typeBA: "Realisasi", docNo: widget.docNo)),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "BA Realisasi",
                          style:
                              Constant.iPrimaryMedium8.copyWith(fontSize: 16),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        baP.remotePDFpath2 == ""
                            ? SizedBox()
                            : InkWell(
                                onTap: () async {
                                  log("LINK DOWNLOAD BA REALISASI : ${baP.remotePDFpath2}");
                                  await requestPermission(
                                      Permission.manageExternalStorage);
                                  if (baP.remotePDFpath2 != "") {
                                    await requestPermission(
                                        Permission.manageExternalStorage);
                                    await downloadFile(
                                      context,
                                      baP.remotePDFpath2,
                                      filename:
                                          "${widget.docNo}-Realisasi-${convertTglCombine(DateTime.now().toString())}",
                                      openAfterDownload: true,
                                      typeFile: 'pdf',
                                    );
                                  }
                                },
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
                                        scale: 3,
                                      ),
                                      Constant.xSizedBox8,
                                      Text(
                                        "Download",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 25.h,
                  child: baP.remotePDFpath2 == ""
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("PDF Tidak Tersedia"),
                        )
                      : PDF(
                          // filePath: baP.remotePDFpath2,
                          enableSwipe: false,
                          swipeHorizontal: false,
                          autoSpacing: true,
                          pageFling: true,
                          pageSnap: true,
                          defaultPage: baP.currentPage2!,
                          fitPolicy: FitPolicy.WIDTH,
                          preventLinkNavigation:
                              true, // if set to true the link is handled in flutter
                          onRender: (_pages) {
                            baP.pages2 = _pages;
                            baP.isReady2 = true;
                          },
                          onError: (error) {
                            baP.errorMessage2 = error.toString();
                            log(error.toString());
                          },
                          onPageError: (page, error) {
                            baP.errorMessage2 = '$page: ${error.toString()}';

                            log('$page: ${error.toString()}');
                          },
                          onViewCreated: (PDFViewController pdfViewController) {
                            baP.controller2.complete(pdfViewController);
                          },
                          onLinkHandler: (String? uri) {
                            log('goto uri: $uri');
                          },
                          onPageChanged: (int? page, int? total) {
                            log('page change: $page/$total');

                            baP.currentPage2 = page;
                          },
                        ).cachedFromUrl(
                          baP.remotePDFpath2,
                          placeholder: (progress) => Center(
                              child: Text('Memuat BA Realisasi $progress %')),
                          errorWidget: (error) =>
                              Center(child: Text(error.toString())),
                        ),
                ),
              ],
            ),
            // if (baP.remotePDFpath2 == "")
            //   baP.errorMessage2.isEmpty
            //       ? !baP.isReady2
            //           ? Center(child: CircularProgressIndicator())
            //           : Container()
            //       : Center(child: Text(baP.errorMessage2))
          ],
        ),
      ),
    );
  }
}
