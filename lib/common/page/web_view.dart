import 'package:mata/common/component/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helper/constant.dart';

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;

  WebViewPage(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, title,
          isCenter: true, isLeading: true, color: Colors.black),
      // appBar: (title != "Panduan Pengguna") ? Utils.appBar(title) : null,
      body: InkWell(
        onDoubleTap: () {
          ////
        },
        onLongPress: () {
          /////
        },
        child: (title != "Panduan Pengguna")
            ? WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
              )
            : Container(
                color: Constant.primaryColor,
                child: SafeArea(
                  left: false,
                  right: false,
                  bottom: false,
                  child: WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
              ),
      ),
    );
  }
}
