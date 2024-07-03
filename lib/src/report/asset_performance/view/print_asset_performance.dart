import 'dart:async';
import 'dart:developer';

import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_appbar.dart';
import 'package:hy_tutorial/src/report/asset_performance/provider/asset_performance_provider.dart';
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

class PrintAssetPerformanceView extends StatefulWidget {
  final String id;
  const PrintAssetPerformanceView({super.key, required this.id});

  @override
  State<PrintAssetPerformanceView> createState() =>
      _PrintAssetPerformanceViewState();
}

class _PrintAssetPerformanceViewState
    extends BaseState<PrintAssetPerformanceView> {
  @override
  void initState() {
    context.read<AssetPerformanceProvider>()
      ..controller = Completer<PDFViewController>()
      ..fetchPDFAssetPerformance(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final aP = context.watch<AssetPerformanceProvider>();
    final printP =
        context.watch<AssetPerformanceProvider>().pdfAssetPerformanceModel.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Print Asset Performance"),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      log("LINK DOWNLOAD ASSET PERFORMANCE : ${aP.remotePDFpath}");
                      await requestPermission(Permission.manageExternalStorage);
                      if (aP.remotePDFpath != "") {
                        await requestPermission(
                            Permission.manageExternalStorage);
                        await downloadFile(
                          context,
                          aP.remotePDFpath,
                          filename:
                              "AssetPerformance-${convertTglCombine(DateTime.now().toString())}",
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
                  defaultPage: aP.currentPage!,
                  fitPolicy: FitPolicy.BOTH,
                  preventLinkNavigation:
                      true, // if set to true the link is handled in flutter
                  onRender: (_pages) async {
                    aP.pages = _pages;
                    aP.isReady = true;
                    setState(() {});
                  },
                  onError: (error) {
                    aP.errorMessage = error.toString();
                    log(error.toString());
                    setState(() {});
                  },
                  onPageError: (page, error) {
                    aP.errorMessage = '$page: ${error.toString()}';
                    setState(() {});
                    log('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) async {
                    // aP.controller

                    // await context
                    //     .read<AssetPerformanceProvider>()
                    //     .createFileOfPdfUrl(pdfViewController);
                    aP.controller.complete(pdfViewController);
                    setState(() {});
                  },
                  onLinkHandler: (String? uri) {
                    setState(() {});
                    log('goto uri: $uri');
                  },
                  onPageChanged: (int? page, int? total) {
                    log('page change: $page/$total');

                    aP.currentPage = page;
                    setState(() {});
                  },
                ).cachedFromUrl(
                  aP.remotePDFpath,
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
                //         .read<AssetPerformanceProvider>()
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
