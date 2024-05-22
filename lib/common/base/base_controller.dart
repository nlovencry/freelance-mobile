import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';
import '../helper/xenolog.dart';
import 'base_state.dart';

class BaseController<S extends BaseState> {
  List<StreamSubscription> streams = List.empty(growable: true);
  List<TextEditingController> controllers = List.empty(growable: true);
  SharedPreferences? _preferences;

  Future<SharedPreferences?> preferences() async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  T registerStream<T extends StreamSubscription>(T stream) {
    streams.add(stream);
    return stream;
  }

  T registerController<T extends TextEditingController>(T c) {
    controllers.add(c);
    return c;
  }

  TextEditingController createTextController({String text = ''}) {
    return registerController(TextEditingController(text: text));
  }

  dispose() {
    streams.forEach((element) {
      element.cancel();
    });
    controllers.forEach((element) => element.dispose());
    controllers.clear();
    streams.clear();
    Utils.dismissLoading();
  }

  Future<String?> getToken() async {
    return (await preferences())!.getString('token');
  }

  Future get(String url, {Map? headers, Map<String, String?>? query}) async {
    Map<String, String> h = Map<String, String>();
    h.putIfAbsent('Connection', () => 'Keep-Alive');
    h.putIfAbsent('accept', () => 'application/json');
    var token = await getToken();
    if (token != null) h.putIfAbsent('Authorization', () => 'Bearer ' + token);
    if (headers != null) h.addAll(headers as Map<String, String>);

    final uri = Uri.parse(url);
    final queryUri = Uri.https(uri.authority, uri.path, query);

    log("==== PARAMETERS ====");
    log("URL : $url");
    log("QUERY : $queryUri");
    Response response =
        await http.get(queryUri, headers: h).timeout(Duration(minutes: 1));
    log("RESPONSE GET $url : ${response.body}");
    log("====================");

    String log2 = "Log : " +
        "==== PARAMETERS ===="
            '\r\n' +
        "URL : $url"
            '\r\n' +
        "QUERY : $queryUri"
            '\r\n' +
        "RESPONSE GET $url : ${response.body}"
            '\r\n' +
        "===================="
            '\r\n';
    // if (kDebugMode) {
    XenoLog("GET").save(log2, alwaysLog: true);
    // }

    return response;
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? body,
      List<http.MultipartFile>? files}) async {
    // print(body);
    Map<String, String> h = Map<String, String>();
    h.putIfAbsent('Connection', () => 'Keep-Alive');
    h.putIfAbsent('accept', () => 'application/json');
    var token = await getToken();
    if (token != null) h.putIfAbsent('Authorization', () => 'Bearer ' + token);
    if (headers != null) h.addAll(headers);

    if (files == null) {
      log("==== PARAMETERS ====");
      log("URL : $url");
      log("BODY : $body");
      Response response = await http
          .post(Uri.parse(url),
              headers: h, body: body, encoding: Encoding.getByName("utf-8"))
          .timeout(Duration(minutes: 1));
      log("RESPONSE POST $url : ${response.body}");
      log("====================");
      String log2 = "Log : " +
          "==== PARAMETERS ===="
              '\r\n' +
          "URL : $url"
              '\r\n' +
          "BODY : $body"
              '\r\n' +
          "FILES : $files"
              '\r\n' +
          "RESPONSE POST $url : ${response.body}"
              '\r\n' +
          "===================="
              '\r\n';
      // if (kDebugMode) {
      XenoLog("POST").save(log2, alwaysLog: true);
      // }
      return response;
    } else {
      var req = http.MultipartRequest("POST", Uri.parse(url));
      h.putIfAbsent("Content-Type", () => 'multipart/form-data');
      req.headers.addAll(h);
      if (body != null)
        req.fields
            .addAll(body.map((key, value) => MapEntry(key, value.toString())));
      req.files.addAll(files);
      log("==== PARAMETERS ====");
      log("URL : $url");
      log("BODY : $body");
      log("FILES : $files");
      Response response = await http.Response.fromStream(await req.send())
          .timeout(Duration(minutes: 1));
      log("RESPONSE POST FILE $url : ${response.body}");
      log("====================");
      String log2 = "Log : " +
          "==== PARAMETERS ===="
              '\r\n' +
          "URL : $url"
              '\r\n' +
          "BODY : $body"
              '\r\n' +
          "FILES : $files"
              '\r\n' +
          "RESPONSE POST $url : ${response.body}"
              '\r\n' +
          "===================="
              '\r\n';
      // if (kDebugMode) {
      XenoLog("POST").save(log2, alwaysLog: true);
      // }
      return response;
    }
  }

  loading(bool show) async {
    if (show)
      await Utils.showLoading();
    else
      await Utils.dismissLoading();
  }
}
