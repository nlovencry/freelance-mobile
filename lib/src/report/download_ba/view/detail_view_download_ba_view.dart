import 'dart:async';
import 'dart:developer';

import 'package:mata/common/base/base_state.dart';
import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/src/report/asset_performance/provider/asset_performance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/constant.dart';
import '../../../../common/helper/convert_date.dart';
import '../../../../common/helper/download.dart';
import '../../../../common/helper/launch_url.dart';
import '../../../../main.dart';
import '../provider/ba_provider.dart';

class DetailViewDownloadBAView extends StatefulWidget {
  final String typeBA;
  final String docNo;
  const DetailViewDownloadBAView(
      {super.key, required this.typeBA, required this.docNo});

  @override
  State<DetailViewDownloadBAView> createState() =>
      _DetailViewDownloadBAViewState();
}

class _DetailViewDownloadBAViewState
    extends BaseState<DetailViewDownloadBAView> {
  @override
  void initState() {
    if (widget.typeBA == "Persetujuan")
      context.read<BAProvider>().controller = Completer<PDFViewController>();
    else
      context.read<BAProvider>().controller2 = Completer<PDFViewController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final aP = context.watch<BAProvider>();
    final printP = context.watch<BAProvider>().baModel.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "BA ${widget.typeBA}"),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      log("LINK DOWNLOAD BA : ${aP.remotePDFpath}");
                      await requestPermission(Permission.manageExternalStorage);
                      if (aP.remotePDFpath != "") {
                        await requestPermission(
                            Permission.manageExternalStorage);
                        await downloadFile(
                          context,
                          aP.remotePDFpath,
                          filename:
                              "${widget.docNo}-${widget.typeBA}-${convertTglCombine(DateTime.now().toString())}",
                          openAfterDownload: true,
                          typeFile: 'pdf',
                        );
                      }
                    },
                    child: Container(
                      height: 35,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      margin: EdgeInsets.symmetric(horizontal: 20),
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
              Constant.xSizedBox16,
              Expanded(
                child: PDF(
                  fitEachPage: false,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  // autoSpacing: false,
                  pageFling: true,
                  pageSnap: false,
                  defaultPage: widget.typeBA == "Persetujuan"
                      ? aP.currentPage!
                      : aP.currentPage2!,
                  fitPolicy: FitPolicy.WIDTH,
                  preventLinkNavigation:
                      true, // if set to true the link is handled in flutter
                  onRender: (_pages) async {
                    if (widget.typeBA == "Persetujuan") {
                      aP.pages = _pages;
                      aP.isReady = true;
                    } else {
                      aP.pages2 = _pages;
                      aP.isReady2 = true;
                    }
                    setState(() {});
                  },
                  onError: (error) {
                    if (widget.typeBA == "Persetujuan")
                      aP.errorMessage = error.toString();
                    else
                      aP.errorMessage2 = error.toString();
                    log(error.toString());
                    setState(() {});
                  },
                  onPageError: (page, error) {
                    if (widget.typeBA == "Persetujuan")
                      aP.errorMessage = '$page: ${error.toString()}';
                    else
                      aP.errorMessage2 = '$page: ${error.toString()}';
                    setState(() {});
                    log('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) async {
                    // aP.controller

                    // await context
                    //     .read<BAProvider>()
                    //     .createFileOfPdfUrl(pdfViewController);
                    if (widget.typeBA == "Persetujuan")
                      aP.controller.complete(pdfViewController);
                    else
                      aP.controller2.complete(pdfViewController);
                    setState(() {});
                  },
                  onLinkHandler: (String? uri) {
                    setState(() {});
                    log('goto uri: $uri');
                  },
                  onPageChanged: (int? page, int? total) {
                    log('page change: $page/$total');

                    if (widget.typeBA == "Persetujuan")
                      aP.currentPage = page;
                    else
                      aP.currentPage2 = page;
                    setState(() {});
                  },
                ).cachedFromUrl(
                  widget.typeBA == "Persetujuan"
                      ? aP.remotePDFpath
                      : aP.remotePDFpath2,
                  placeholder: (progress) =>
                      Center(child: Text('Memuat PDF $progress %')),
                  errorWidget: (error) => Center(child: Text(error.toString())),
                ),
                // child: PDFView(
                //   filePath: aP.remotePDFpath,
                //   fitEachPage: true,
                //   enableSwipe: true,
                //   swipeHorizontal: false,
                //   autoSpacing: false,
                //   pageFling: true,
                //   pageSnap: true,
                //   defaultPage: aP.currentPage!,
                //   fitPolicy: FitPolicy.BOTH,
                //   preventLinkNavigation:
                //       true, // if set to true the link is handled in flutter
                //   onRender: (_pages) async{
                //     aP.pages = _pages;
                //     aP.isReady = true;
                //     setState(() {});
                //   },
                //   onError: (error) {
                //     aP.errorMessage = error.toString();
                //     log(error.toString());
                //     setState(() {});
                //   },
                //   onPageError: (page, error) {
                //     aP.errorMessage = '$page: ${error.toString()}';
                //     setState(() {});
                //     log('$page: ${error.toString()}');
                //   },
                //   onViewCreated: (PDFViewController pdfViewController) async {
                //     // aP.controller

                //     await context
                //         .read<BAProvider>()
                //         .createFileOfPdfUrl(pdfViewController);
                //     // aP.controller.complete(pdfViewController);
                //     setState(() {});
                //   },
                //   onLinkHandler: (String? uri) {
                //     setState(() {});
                //     log('goto uri: $uri');
                //   },
                //   onPageChanged: (int? page, int? total) {
                //     log('page change: $page/$total');

                //     aP.currentPage = page;
                //     setState(() {});
                //   },
                // ),
              ),
            ],
          ),
          // if (aP.remotePDFpath == "")
          //   aP.errorMessage.isEmpty
          //       ? !aP.isReady
          //           ? Center(child: CircularProgressIndicator())
          //           : Container()
          //       : Center(child: Text(aP.errorMessage))
        ],
      ),
    );
  }
}
